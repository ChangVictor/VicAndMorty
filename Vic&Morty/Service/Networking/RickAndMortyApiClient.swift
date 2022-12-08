//
//  RickAndMortyApiClient.swift
//  Vic&Morty
//
//  Created by Victor Chang on 08/12/2022.
//

import Foundation

protocol RickAndMortyApiClientProtocol {
	func getCachedImage(url: String) -> Data?
	
	func cancelLoad(id: UUID)
	
	func getCharacters(
		page: Int,
		onSuccess: @escaping (CharacterResult) -> (Void),
		onError: @escaping (Error) -> (Void)
	)
	
	func getImage(
		from url: String,
		onSuccess: @escaping (Data) -> (Void),
		onError: @escaping (Error) -> (Void)
	) -> UUID?
}

class RickAndMortyApiClient: RickAndMortyApiClientProtocol {
	private let baseRestClient: BaseRestClient
	private var images: NSCache<NSString, NSData>
	
	private func components(with path: String) -> URLComponents {
		var urlComponents = URLComponents()
		urlComponents.scheme = "https"
		urlComponents.host = Constants.Networking.baseUrl
		urlComponents.path = path
		
		return urlComponents
	}
	
	init(
		baseRestClient: BaseRestClient = BaseRestClient(),
		imagesCache: NSCache<NSString, NSData> = NSCache<NSString, NSData>()
	) {
		self.baseRestClient = baseRestClient
		self.images = imagesCache
	}
	
	func cancelLoad(id: UUID) {
		self.baseRestClient.cancelLoad(id: id)
	}
	
	func getCachedImage(url: String) -> Data? {
		return images.object(forKey: url as NSString) as Data?
	}
	
	func getImage(
		from url: String,
		onSuccess: @escaping (Data) -> (Void),
		onError: @escaping (Error) -> (Void)
	) -> UUID? {
		if let imageData = self.getCachedImage(url: url) {
			onSuccess(imageData as Data)
			return nil
		}
		
		return self.baseRestClient.download(
			url: url,
			onSuccess: { data in
				self.images.setObject(data as NSData, forKey: url as NSString)
				onSuccess(data)
			},
			onError: { error in
				onError(error)
			}
		)
	}
	
	func getCharacters(
		page: Int,
		onSuccess: @escaping (CharacterResult) -> (Void),
		onError: @escaping (Error) -> (Void)
	) {
		self.baseRestClient.performRequest(
			with: components(with: Constants.Networking.characterPath),
			queryParams: [Constants.Networking.pageQueryParam: String(page)],
			onSuccess: { (deliveryItems: CharacterResult) in
				onSuccess(deliveryItems)
			},
			onError: { error in
				onError(error)
			}
		)
	}
}
