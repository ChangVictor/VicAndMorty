//
//  CustomImageView.swift
//  Vic&Morty
//
//  Created by Victor Chang on 10/12/2022.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
	
	var lastUrlUsedToLoadImage: String?
	
	func loadImage(fromUrl: String) {
		
		lastUrlUsedToLoadImage = fromUrl
		self.image = nil
		
		if let cachedImage = imageCache[fromUrl] {
			
			self.image = cachedImage
			return
		}
		
		guard let url = URL(string: fromUrl) else { return }
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			if let error = error {
				print("Failed to fetch image: ", error)
				return
			}
			
			if url.absoluteString != self.lastUrlUsedToLoadImage {
				return
			}
			
			guard let imageData = data else { return }
			let imagePhoto = UIImage(data: imageData)
			imageCache[url.absoluteString] = imagePhoto
			
			DispatchQueue.main.async {
				self.image = imagePhoto
			}
		}
		.resume()
	}
}
