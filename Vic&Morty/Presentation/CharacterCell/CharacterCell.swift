//
//  CharacterCell.swift
//  Vic&Morty
//
//  Created by Victor Chang on 08/12/2022.
//

import UIKit

protocol CharacterCellProtocol: AnyObject {
	var character: Character? { get set }
	var onReuse: () -> Void { get set }
	
	func setImage(_ image: UIImage?)
}

class CharacterCell: UITableViewCell {
	static let identifier = "CharacterCell"
	
	var character: Character? {
		didSet {
			self.nameLabel.text = character!.name.capitalized
			self.descriptionLabel.text = "\(character!.species) - \(character!.status)"
			self.genre.setTitle(character!.gender.capitalized, for: .normal)
		}
	}
	var onReuse: () -> Void = {}

	private let characterImage: UIImageView = {
		let img = UIImageView()
		img.contentMode = .scaleAspectFill
		img.translatesAutoresizingMaskIntoConstraints = false
		img.layer.cornerRadius = 0
		img.clipsToBounds = true
		
		return img
	}()
	
	let nameLabel: UILabel = {
		let label = UILabel()
		
		label.font = UIFont.boldSystemFont(ofSize: 16)
		label.textColor = .label
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 1
		label.lineBreakMode = .byTruncatingTail
		
		return label
	}()
	
	private let descriptionLabel: UILabel = {
		let label = UILabel()
		
		label.font = UIFont.boldSystemFont(ofSize: 14)
		label.textColor = .secondaryLabel
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		
		return label
	}()
	
	private let genre: UIButton = {
		let button = UIButton()
		
		var config =  UIButton.Configuration.tinted()
		
		config.buttonSize = .small
		config.cornerStyle = .small
		config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
			var outgoing = incoming
			outgoing.font = UIFont.systemFont(ofSize: 10)
			return outgoing
		}
		config.baseBackgroundColor = UIColor.gray
		
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius = 5
		button.configuration = config
		button.tintColor = .label
		button.isUserInteractionEnabled = false
		
		return button
	}()
	
	var activityIndicator: UIActivityIndicatorView = {
		let activityIndicator = UIActivityIndicatorView()
		activityIndicator.hidesWhenStopped = true
		activityIndicator.color = UIColor.black
		
		return activityIndicator
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.contentView.clipsToBounds = true
		self.contentView.backgroundColor = .systemGray6
		
		self.contentView.addSubview(characterImage)
		self.contentView.addSubview(nameLabel)
		self.contentView.addSubview(descriptionLabel)
		self.contentView.addSubview(genre)
		
		self.setupLayout()
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		self.onReuse()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.preservesSuperviewLayoutMargins = false
		self.separatorInset = UIEdgeInsets.zero
		self.layoutMargins = UIEdgeInsets.zero
	}
	
	private func setupLayout() {
		self.setImageConstraints()
		self.setNameLabelConstraints()
		self.setupDescriptionConstraints()
		self.setupGenreConstraints()
		self.setupImageLoaderIndicator()
	}
	
	private func setupImageLoaderIndicator() {
		self.characterImage.addSubview(activityIndicator)
		self.activityIndicator.bringSubviewToFront(characterImage)
		
		self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		self.activityIndicator.centerXAnchor.constraint(equalTo: self.characterImage.centerXAnchor).isActive = true
		self.activityIndicator.centerYAnchor.constraint(equalTo: self.characterImage.centerYAnchor).isActive = true
	}
	
	private func setImageConstraints() {
		self.characterImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
		self.characterImage.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
		self.characterImage.widthAnchor.constraint(equalToConstant: 70).isActive = true
		self.characterImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
	}
	
	private func setNameLabelConstraints() {
		self.nameLabel.leadingAnchor.constraint(equalTo: self.characterImage.trailingAnchor, constant: 10).isActive = true
		self.nameLabel.centerYAnchor.constraint(equalTo: self.characterImage.centerYAnchor, constant: -10).isActive = true
		self.nameLabel.trailingAnchor.constraint(equalTo: self.genre.leadingAnchor, constant: -4).isActive = true
	}
	
	private func setupDescriptionConstraints() {
		self.descriptionLabel.leadingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor).isActive = true
		self.descriptionLabel.centerYAnchor.constraint(equalTo: self.characterImage.centerYAnchor, constant: 10).isActive = true
		self.descriptionLabel.trailingAnchor.constraint(equalTo: self.genre.leadingAnchor, constant: -4).isActive = true
	}
	
	private func setupGenreConstraints() {
		self.genre.widthAnchor.constraint(equalToConstant: 66).isActive = true
		self.genre.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20).isActive = true
		self.genre.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12).isActive = true
	}
	
	func setImage(_ image: UIImage?) {
		DispatchQueue.main.async {
			if image == nil {
				self.activityIndicator.startAnimating()
			} else {
				self.activityIndicator.stopAnimating()
			}
			
			self.characterImage.image = image
		}
	}
}
