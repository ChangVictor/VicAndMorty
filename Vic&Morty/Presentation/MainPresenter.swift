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
	
	func cleanCharacters()
	func getCachedImage(url: String) -> Data?
	func canDownload() -> Bool
	func getCharacters(page: Int)
	func getImage(
		from url: String,
		onSuccess: @escaping (Data) -> (Void),
		onError: @escaping (Error) -> (Void)
	) -> UUID?
	func cancelLoad(id: UUID)
}

class MainPresenter: MainPresenterProtocol {
	
	weak var delegate: MainViewProtocol?
	var characters = [Character]()
	private let restClient: RickAndMortyApiClientProtocol
	private var pages = 1
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
	
	func getImage(
		from url: String,
		onSuccess: @escaping (Data) -> (Void),
		onError: @escaping (Error) -> (Void)
	) -> UUID? {
		return self.restClient.getImage(
			from: url,
			onSuccess: { data in
				onSuccess(data)
			}, onError: { error in
				onError(error)
			}
		)
	}
	
	func getCachedImage(url: String) -> Data? {
		return self.restClient.getCachedImage(url: url)
	}
	
	func cancelLoad(id: UUID) {
		self.restClient.cancelLoad(id: id)
	}
	
	func canDownload() -> Bool {
		return !self.isDownloading
	}
	
	func cleanCharacters() {
		self.characters = []
	}	
}
