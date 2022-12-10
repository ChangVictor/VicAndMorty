//
//  Constants+Strings.swift
//  Vic&Morty
//
//  Created by Victor Chang on 10/12/2022.
//

import Foundation

extension Constants {
	enum Strings {
		static let searchBarPlaceholder = "Search Characters..."
		static let navigationTitle = "Vic & Morty"
		static let resultsPerPage = 20
		static let pageQueryParam = "page"
		static let nameQueryParam = "name"
	}
	
	enum Alerts {
		static let requestErrorTitle = "There was an error with the API call"
		static let requestErrorMessage = "Do you want to retry?"
		static let maxPagesReached = "There are no more results"
		static let yesActionTitle = "Yes"
		static let noActionTitle = "No"
		static let okActionTitle = "Ok"
	}
}
