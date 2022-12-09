//
//  MainViewController.swift
//  Vic&Morty
//
//  Created by Victor Chang on 08/12/2022.
//

import UIKit

protocol MainViewProtocol: AnyObject {
	func onSuccess()
	func onError(with page: Int)
	func onMaxPagesLoaded()
}

class MainViewController: UITableViewController {
	
	private var presenter: MainPresenterProtocol
	
	init(_ presenter: MainPresenterProtocol = MainPresenter()) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
		self.presenter.delegate = self
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.navigationController?.navigationBar.backgroundColor = .systemBackground
		self.view.backgroundColor = .white
		self.tableView.separatorStyle = .none
		self.title = "Vic & Morty"
		
		self.registerCell()
		self.initialDownload()
	}
	
	private func registerCell() {
		tableView.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.identifier)
	}
	
	private func initialDownload() {
		self.startRequest(with: 0)
	}
	
	private func startRequest(with page: Int) {
		self.presenter.getCharacters(page: page)
	}
}

extension MainViewController: MainViewProtocol {
	func onSuccess() {
		DispatchQueue.main.async {
			self.tableView.reloadData()
			self.cleanSpinners()
		}
	}
	
	func onError(with page: Int) {
		let alertController = UIAlertController.init(title: "There was an error with the API call", message: "Do you want to retry?", preferredStyle: .alert)
		
		let action = UIAlertAction.init(title: "Yes", style: .default, handler: { _ in
			self.startRequest(with: page)
		})
		
		let actionCancel = UIAlertAction.init(title: "No", style: .cancel)
		
		alertController.addAction(actionCancel)
		alertController.addAction(action)
		
		DispatchQueue.main.async {
			self.present(alertController, animated: true)
			self.cleanSpinners()
		}
	}
	
	func onMaxPagesLoaded() {
		self.cleanSpinners()
		let alertController = UIAlertController.init(title: "There are no more results", message: nil, preferredStyle: .alert)
		let actionCancel = UIAlertAction.init(title: "Ok", style: .cancel)
		alertController.addAction(actionCancel)
		
		self.present(alertController, animated: true)
	}
	
	private func cleanSpinners() {
		self.refreshControl?.endRefreshing()
		self.tableView.tableFooterView = nil
		self.tableView.tableHeaderView = nil
	}
}

// MARK: - tableView DataSource & Delegate methods
extension MainViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.characters.count
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
}

extension MainViewController {
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 120
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.identifier, for: indexPath) as? CharacterCell else { return UITableViewCell() }
		let character = self.presenter.characters[indexPath.row]
		cell.character = character
		
		if let data = self.presenter.getCachedImage(url: character.image) {
			cell.setImage(UIImage.from(data: data))
		} else {
			cell.setImage(nil)
			let id = self.presenter.getImage(
				from: character.image,
				onSuccess: { data in
					let img = UIImage.from(data: data)
					// This is to avoid loading images that don't belong to the cell, when it finished downloading.
					if cell.character?.image == character.image {
						DispatchQueue.main.async {
							cell.setImage(img)
						}
					}
				}, onError: { error in
					DispatchQueue.main.async {
						cell.setImage(UIImage(systemName: "picture"))
					}
				}
			)
			
			// The download operation is stopped in case of cell reuse
			cell.onReuse = {
				if let id = id {
					self.presenter.cancelLoad(id: id)
				}
			}
		}
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let controller = DetailViewController()
		let character = self.presenter.characters[indexPath.row]
		
		self.present(controller, animated: true)
		controller.configure(with: character)
		
		_ = self.presenter.getImage(
			from: character.image,
			onSuccess: { data in
				
				let img = UIImage.from(data: data)
				
				controller.setImage(img)
			}, onError: { error in
				controller.setImage(UIImage(systemName: "picture"))
			}
		)
	}
}

// MARK: - scrollViewDidScroll
extension MainViewController {
	private func createSpinnerFooter() -> UIView {
		let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
		
		footerView.backgroundColor = .clear
		
		let spinner = UIActivityIndicatorView()
		spinner.center = footerView.center
		
		footerView.addSubview(spinner)
		spinner.startAnimating()
		
		return footerView
	}
	
	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let position = scrollView.contentOffset.y
		let tableViewHeight = self.tableView.contentSize.height
		let scrollHeight = scrollView.frame.size.height
		
		if position > (tableViewHeight - scrollHeight) {
			let downloadedCount = self.presenter.characters.count
			
			guard self.presenter.canDownload(), downloadedCount != 0 else {
				return
			}
			
			DispatchQueue.main.async {
				self.tableView.tableFooterView = self.createSpinnerFooter()
			}
			
			// Here I add 1 page because of the initial data that is gathered on viewDidLoad
			let page = Int(downloadedCount/20) + 1
			
			self.startRequest(with: page)
		}
	}
}


