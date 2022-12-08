//
//  MainViewController.swift
//  Vic&Morty
//
//  Created by Victor Chang on 08/12/2022.
//

import UIKit

protocol MainViewProtocol: AnyObject {
	func onSuccess()
	func onError()
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
		self.navigationController?.navigationBar.barTintColor = .systemBackground
		self.title = "Vic & Morty"
	}
}

extension MainViewController: MainViewProtocol {
	func onSuccess() {
		// TODO: - updateViews after characters are fetched
	}
	
	func onError() {
		// TODO: - Handle error
	}
	
	func onMaxPagesLoaded() {
		// TODO: - handle when max pages is reached
	}
}

extension MainViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 20
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
}

extension MainViewController {
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		
		
		
		return cell
	}
}

