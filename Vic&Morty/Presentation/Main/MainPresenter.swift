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
	var searchedCharacters: [Character] { get }
	
	func cleanSearchedCharacters()
	func canDownload() -> Bool
	func getCharacters(page: Int)
	func searchCharacters(character: String, page: Int)
}

class MainPresenter: MainPresenterProtocol {
	
	weak var delegate: MainViewProtocol?
	var characters = [Character]()
	var searchedCharacters = [Character]()
	private let restClient: RickAndMortyApiClientProtocol
	private var pages = 1
	private var searchPages = 1
	private var isDownloading = false
	
	init(
		restClient: RickAndMortyApiClientProtocol = RickAndMortyApiClient()
	) {
		self.restClient = restClient
	}

	func getCharacters(page: Int) {
		guard page <= pages else {
			self.delegate?.onMaxPagesLoaded()
			return
		}
		self.isDownloading = true
		self.restClient.getCharacters(page: page) { [weak self] result in
			guard let sSelf = self else {
				return
			}
			sSelf.isDownloading = false
			sSelf.characters.append(contentsOf: result.results)
			sSelf.pages = result.info.pages
			sSelf.delegate?.onSuccess()
		} onError: { [weak self]  _ in
			guard let sSelf = self else {
				return
			}
			sSelf.isDownloading = true
			sSelf.delegate?.onError(with: page)
			return
		}
	}
	
	func searchCharacters(character: String, page: Int) {
		guard page <= searchPages else {
			self.delegate?.onMaxPagesLoaded()
			return
		}
		self.isDownloading = true
		self.restClient.searchCharacters(character: character, page: page ) { [weak self] result in
			guard let sSelf = self else {
				return
			}
			sSelf.isDownloading = false
			sSelf.searchedCharacters.append(contentsOf: result.results)
			sSelf.searchPages = result.info.pages
			sSelf.delegate?.onSuccess()
		} onError: { [weak self]  error in
			guard let sSelf = self else {
				return
			}
			print(error.localizedDescription)
			sSelf.isDownloading = true
			sSelf.delegate?.onError(with: page)
			return
		}
	}

	func canDownload() -> Bool {
		return !self.isDownloading
	}
	
	func cleanSearchedCharacters() {
		self.searchedCharacters.removeAll()
	}
}
