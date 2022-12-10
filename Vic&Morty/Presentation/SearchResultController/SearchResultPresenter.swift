//
//  SearchResultPresenter.swift
//  Vic&Morty
//
//  Created by Victor Chang on 10/12/2022.
//

import Foundation

protocol SearchResultPresenterProtocol: AnyObject {
	var delegate: SearchResultProtocol? { get set }
	var characterResults: [Character] { get }
	
	
}

class SearchResultPresenter {
	
}
