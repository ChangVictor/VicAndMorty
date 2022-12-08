//
//  UIImage+Extension.swift
//  Vic&Morty
//
//  Created by Victor Chang on 08/12/2022.
//

import UIKit

extension UIImage {
	static func from(data: Data?) -> UIImage? {
		if let data = data {
			return UIImage(data: data)
		}
		return UIImage(systemName: "picture")
	}
}

