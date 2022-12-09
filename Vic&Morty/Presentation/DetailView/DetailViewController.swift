//
//  DetailViewController.swift
//  Vic&Morty
//
//  Created by Victor Chang on 09/12/2022.
//

import UIKit

protocol DetailProtocol: AnyObject {
	func configure(with character: Character)
	func setImage(_ image: UIImage?)
}

class DetailViewController: UIViewController {
	
	private let characterImage: UIImageView = {
		let img = UIImageView()
		img.contentMode = .scaleAspectFill
		img.translatesAutoresizingMaskIntoConstraints = false
		img.layer.cornerRadius = 0
		img.clipsToBounds = true
		return img
	}()
	
	private let closeButton: UIButton = {
		let button = UIButton(type: .system)
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("✕", for: .normal)
		button.setTitleColor(.label, for: .normal)
		return button
	}()
	
	private let nameTitle: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 20)
		label.textColor = .label
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 1
		label.lineBreakMode = .byTruncatingTail
		label.text = "Name:"
		return label
	}()
	
	private let nameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
		label.textColor = .label
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 1
		label.lineBreakMode = .byTruncatingTail
		return label
	}()
	
	private let statusTitle: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 20)
		label.textColor = .label
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 1
		label.lineBreakMode = .byTruncatingTail
		label.text = "Status:"
		return label
	}()
	
	private let statusLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
		label.textColor = .label
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 1
		label.lineBreakMode = .byTruncatingTail
		return label
	}()
	
	private let speciesTitle: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 20)
		label.textColor = .label
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 1
		label.lineBreakMode = .byTruncatingTail
		label.text = "Species:"
		return label
	}()
	
	private let speciesLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
		label.textColor = .label
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 1
		label.lineBreakMode = .byTruncatingTail
		return label
	}()
	
	private let genderTitle: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 20)
		label.textColor = .label
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 1
		label.lineBreakMode = .byTruncatingTail
		label.text = "Gender"
		return label
	}()
	
	private let genderLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
		label.textColor = .label
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 1
		label.lineBreakMode = .byTruncatingTail
		return label
	}()
	
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("error")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = .systemGray6
		self.setupClose()
		self.setupImage()
		self.setupName()
		self.setupSpecies()
		self.setupGender()
		self.setupStatus()
	}
	
	private func setupClose() {
		self.view.addSubview(self.closeButton)
		self.closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
		self.closeButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true
		self.closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
	}
	
	@objc
	private func closeTapped() {
		self.dismiss(animated: true, completion: nil)
	}
	
	private func setupImage() {
		self.view.addSubview(self.characterImage)
		
		self.characterImage.topAnchor.constraint(equalTo: self.closeButton.bottomAnchor, constant: 16).isActive = true
		self.characterImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
		self.characterImage.widthAnchor.constraint(equalToConstant: 240).isActive = true
		self.characterImage.heightAnchor.constraint(equalToConstant: 240).isActive = true
	}
	
	private func setupName() {
		self.view.addSubview(self.nameTitle)
		self.view.addSubview(self.nameLabel)
		
		self.nameTitle.topAnchor.constraint(equalTo: self.characterImage.bottomAnchor, constant: 40).isActive = true
		self.nameTitle.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 24).isActive = true
		self.nameTitle.widthAnchor.constraint(equalToConstant: 80).isActive = true
		
		self.nameLabel.topAnchor.constraint(equalTo: self.nameTitle.topAnchor).isActive = true
		self.nameLabel.leadingAnchor.constraint(equalTo: self.nameTitle.trailingAnchor, constant: 24).isActive = true
		self.nameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
	}
	
	private func setupSpecies() {
		self.view.addSubview(self.speciesLabel)
		self.view.addSubview(self.speciesTitle)
		
		self.speciesTitle.topAnchor.constraint(equalTo: self.nameTitle.bottomAnchor, constant: 28).isActive = true
		self.speciesTitle.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 24).isActive = true
		self.speciesTitle.widthAnchor.constraint(equalToConstant: 80).isActive = true
		
		self.speciesLabel.topAnchor.constraint(equalTo: self.speciesTitle.topAnchor).isActive = true
		self.speciesLabel.leadingAnchor.constraint(equalTo: self.speciesTitle.trailingAnchor, constant: 24).isActive = true
		self.speciesLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
	}
	
	private func setupGender() {
		self.view.addSubview(self.genderTitle)
		self.view.addSubview(self.genderLabel)
		
		self.genderTitle.topAnchor.constraint(equalTo: self.speciesTitle.bottomAnchor, constant: 28).isActive = true
		self.genderTitle.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 24).isActive = true
		self.genderTitle.widthAnchor.constraint(equalToConstant: 80).isActive = true
		
		self.genderLabel.topAnchor.constraint(equalTo: self.genderTitle.topAnchor).isActive = true
		self.genderLabel.leadingAnchor.constraint(equalTo: self.genderTitle.trailingAnchor, constant: 24).isActive = true
		self.genderLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
	}
	
	private func setupStatus() {
		self.view.addSubview(self.statusTitle)
		self.view.addSubview(self.statusLabel)
		
		self.statusTitle.topAnchor.constraint(equalTo: self.genderTitle.bottomAnchor, constant: 28).isActive = true
		self.statusTitle.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 24).isActive = true
		self.statusTitle.widthAnchor.constraint(equalToConstant: 80).isActive = true
		
		self.statusLabel.topAnchor.constraint(equalTo: self.statusTitle.topAnchor).isActive = true
		self.statusLabel.leadingAnchor.constraint(equalTo: self.statusTitle.trailingAnchor, constant: 24).isActive = true
		self.statusLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
	}
}

extension DetailViewController: DetailProtocol {
	
	func configure(with character: Character) {
		self.nameLabel.text = character.name.capitalized
		self.speciesLabel.text = character.species.capitalized
		self.genderLabel.text = character.gender.capitalized
		self.statusLabel.text = character.status.capitalized
	}
	
	func setImage(_ image: UIImage?) {
		self.characterImage.image = image
	}
}
