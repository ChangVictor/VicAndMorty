//
//  CharacterResult.swift
//  Vic&Morty
//
//  Created by Victor Chang on 08/12/2022.
//

import Foundation

import Foundation

struct CharacterResult: Codable {
	let info: Info
	let results: [Character]
}

struct Info: Codable {
	let pages: Int
}

struct Character: Codable {
	let id: Int
	let name, status, species, gender, image: String
}
