//
//  BaseRestClient.swift
//  Vic&Morty
//
//  Created by Victor Chang on 08/12/2022.
//

import Foundation

protocol BaseNetworkingProtocol {
	func performRequest<ResponseModel: Codable>(
		with components: URLComponents,
		queryParams: [String: String]?,
		onSuccess: @escaping (ResponseModel) -> (Void),
		onError: @escaping (Error) -> (Void)
	)
	
	func download(
		url: String,
		onSuccess: @escaping (Data) -> (Void),
		onError: @escaping (Error) -> (Void)
	) -> UUID?
	
	func cancelLoad(id: UUID)
}

enum Error: Swift.Error {
	case requestServerUnknownError(URLResponse?)
	case requestServerError
	case requestClientError
	case responseParseError
}

class BaseRestClient: BaseNetworkingProtocol {
	let urlSession: URLSession
	
	init(urlSession: URLSession = URLSession.shared) {
		self.urlSession = urlSession
	}
	
	var commonHeaders: [String: String] = {
		var headers = [String: String]()
		headers["Content-Type"] = "application/json"
		headers["accept"] = "application/json"
		return headers
	}()
	
	var defaultDecoder: JSONDecoder {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return decoder
	}
	
	private func requestSucceeded(_ response: HTTPURLResponse) -> Bool {
		return (200...299).contains(response.statusCode)
	}
	
	var requestsQueue = [UUID: URLSessionDownloadTask]()

	func download(
		url: String,
		onSuccess: @escaping (Data) -> (Void),
		onError: @escaping (Error) -> (Void)
	) -> UUID? {
		guard let imageURL = URL(string: url) else {
			onError(.requestClientError)
			return nil
		}
		
		let id = UUID()
		let task = self.urlSession.downloadTask(with: imageURL) { localUrl, response, error in
			
			if let error = error {
				if (error as NSError).code == NSURLErrorCancelled {
					return
				} else {
					onError(.requestServerError)
				}
			}
			
			guard let httpResponse = response as? HTTPURLResponse, self.requestSucceeded(httpResponse) else {
				onError(.requestServerUnknownError(response))
				return
			}
			
			guard let localUrl = localUrl else {
				onError(.requestServerError)
				return
			}
			
			do {
				let data = try Data(contentsOf: localUrl)
				onSuccess(data)
			} catch {
				onError(.responseParseError)
			}
		}
		
		task.resume()
		
		requestsQueue[id] = task
		return id
	}
	
	func cancelLoad(id: UUID) {
		requestsQueue[id]?.cancel()
		requestsQueue.removeValue(forKey: id)
	}
	
	func performRequest<ResponseModel: Codable>(
		with components: URLComponents,
		queryParams: [String: String]?,
		onSuccess: @escaping (ResponseModel) -> (Void),
		onError: @escaping (Error) -> (Void)
	) {
		var components = components
		if let queryParams = queryParams {
			var queryItems = [URLQueryItem]()
			queryParams.forEach({ (key, value) in
				queryItems.append(URLQueryItem(name: key, value: value))
			})
			components.queryItems = queryItems
		}
		guard let url = components.url else {
			onError((.requestClientError))
			return
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "get"
		
		commonHeaders.forEach { (key, value) in
			request.addValue(value, forHTTPHeaderField: key)
		}

		self.urlSession.dataTask(with: request) { data, response, error in
			guard let response = response as? HTTPURLResponse, self.requestSucceeded(response), error == nil else {
				onError(.requestServerUnknownError(response))
				return
			}
			
			guard let data = data,
				  let decodedData = try? self.defaultDecoder.decode(ResponseModel.self, from: data)
			else {
				onError((.responseParseError))
				return
			}
			
			onSuccess(decodedData)
		}.resume()
	}
}
