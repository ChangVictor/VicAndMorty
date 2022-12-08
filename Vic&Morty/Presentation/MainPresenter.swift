//
//  MainPresenter.swift
//  Vic&Morty
//
//  Created by Victor Chang on 08/12/2022.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
	var delegate: MainViewProtocol? { get set }
	var characters: [Character] { get }
	

	func getCharacters(page: Int)
	func getImage(
		from url: String,
		onSuccess: @escaping (Data) -> (Void),
		onError: @escaping (Error) -> (Void))
}

class MainPresenter: MainPresenterProtocol {
	
	weak var delegate: MainViewProtocol?
	var characters = [Character]()
	// TODO: - set restClient
	init() {
		
	}

	func getCharacters(page: Int) {
		// TODO: - get characters from API
	}
	
	func getImage(from url: String, onSuccess: @escaping (Data) -> (Void), onError: @escaping (Error) -> (Void)) {
		// TODO: - get images from API
	}
	
}
