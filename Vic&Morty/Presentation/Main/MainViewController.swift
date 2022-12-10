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
	
	let searchController = UISearchController(searchResultsController: nil)
	private var timer: Timer?

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
		self.tableView.separatorStyle = .none
		self.view.backgroundColor = .white
		
		self.setupNavigationBar()
		self.registerCell()
		self.setupSearchBar()
		self.initialDownload()
		self.setupToolbar()
		self.setupNavigationItem()
	}
	
	private func registerCell() {
		tableView.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.identifier)
	}
	
	private func initialDownload() {
		self.startRequest(with: 0)
	}
	
	private func startRequest(with page: Int) {
		DispatchQueue.global(qos: .background).async {
			self.presenter.getCharacters(page: page)
		}
	}
	
	private func setupSearchBar() {
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = Constants.Strings.searchBarPlaceholder
		navigationItem.searchController = searchController
		definesPresentationContext = true
	}
	
	private func setupNavigationBar() {
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.navigationController?.navigationBar.backgroundColor = .systemBackground
		self.title = Constants.Strings.navigationTitle
	}
	
	private func setupToolbar() {
		let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 40)))
		let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismisKeyboard))
		toolbar.setItems([flexSpace, doneButton], animated: true)
		toolbar.sizeToFit()
		self.searchController.searchBar.searchTextField.inputAccessoryView = toolbar
	}
	
	@objc fileprivate func dismisKeyboard() {
		searchController.searchBar.searchTextField.resignFirstResponder()
		self.tableView?.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
	}
	
	private func setupNavigationItem() {
		let rightNavBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchButtonTapped))
		self.navigationItem.rightBarButtonItem = rightNavBarButton
	}
	
	@objc func handleSearchButtonTapped() {
		self.tableView?.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
		searchController.searchBar.becomeFirstResponder()
	}
}

// MARK: - Protocol methods
extension MainViewController: MainViewProtocol {
	func onSuccess() {
		DispatchQueue.main.async {
			self.tableView.reloadData()
			self.cleanSpinners()
		}
	}
	
	func onError(with page: Int) {
		let alertController = UIAlertController.init(title: Constants.Alerts.requestErrorTitle, message: Constants.Alerts.requestErrorMessage, preferredStyle: .alert)
		let action = UIAlertAction.init(title: Constants.Alerts.yesActionTitle, style: .default, handler: { _ in
			self.startRequest(with: page)
		})
		let actionCancel = UIAlertAction.init(title: Constants.Alerts.noActionTitle, style: .cancel)
		alertController.addAction(actionCancel)
		alertController.addAction(action)
		DispatchQueue.main.async {
			self.present(alertController, animated: true)
			self.cleanSpinners()
		}
	}
	
	func onMaxPagesLoaded() {
		self.cleanSpinners()
		let alertController = UIAlertController.init(title: Constants.Alerts.maxPagesReached, message: nil, preferredStyle: .alert)
		let actionCancel = UIAlertAction.init(title: Constants.Alerts.okActionTitle, style: .cancel)
		alertController.addAction(actionCancel)
		DispatchQueue.main.async {
			self.present(alertController, animated: true)
		}
	}
	
	private func cleanSpinners() {
		DispatchQueue.main.async {
			self.refreshControl?.endRefreshing()
			self.tableView.tableFooterView = nil
			self.tableView.tableHeaderView = nil
		}
	}
}

// MARK: - tableView DataSource & Delegate methods
extension MainViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if self.presenter.searchedCharacters.isEmpty {
			return presenter.characters.count
		} else {
			return presenter.searchedCharacters.count
		}
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
		
		if !self.presenter.searchedCharacters.isEmpty {
			let character = self.presenter.searchedCharacters[indexPath.row]
			cell.character = character
		} else {
			let character = self.presenter.characters[indexPath.row]
			cell.character = character
		}
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let controller = DetailViewController()
		var character = self.presenter.characters[indexPath.row]
		if !self.presenter.searchedCharacters.isEmpty {
			character = self.presenter.searchedCharacters[indexPath.row]
		}
		controller.configure(with: character)
		self.present(controller, animated: true)
		controller.modalPresentationStyle = .overCurrentContext
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
		DispatchQueue.main.async {
			spinner.startAnimating()
		}
		return footerView
	}
	
	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let position = scrollView.contentOffset.y
		let tableViewHeight = self.tableView.contentSize.height
		let scrollHeight = scrollView.frame.size.height
		scrollView.keyboardDismissMode = .onDrag
		self.searchController.searchBar.resignFirstResponder()
		
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

// MARK: - Searchbar delegates
extension MainViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		
		guard let searchText = searchController.searchBar.text else { return }

		if !searchText.isEmpty {
			timer?.invalidate()
			timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
				DispatchQueue.global(qos: .background).async {
					self?.presenter.searchCharacters(character: searchText, page: 0)
				}
			})
		} else {
			self.presenter.cleanSearchedCharacters()
		}
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
}

extension MainViewController: UISearchBarDelegate {
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		self.tableView?.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
	}
}

