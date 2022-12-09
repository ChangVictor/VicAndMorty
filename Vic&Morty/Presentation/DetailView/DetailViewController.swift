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
	
	// MARK: - View Properties
	private let characterImage: UIImageView = {
		let img = UIImageView()
		img.contentMode = .scaleAspectFill
		img.translatesAutoresizingMaskIntoConstraints = false
		img.layer.cornerRadius = 10
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
	
	let cardView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	// MARK: - LifeCycle methods
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("error")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.frame = self.view.frame
		self.view.insertSubview(blurEffectView, at: 0)
		self.view.backgroundColor = .clear
		
		self.setupClose()
		self.setupCardView()
		self.setupImage()
		self.setupName()
		self.setupSpecies()
		self.setupGender()
		self.setupStatus()
	}
	
	// MARK: - View setup & constraints
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
		self.cardView.addSubview(self.characterImage)
		self.characterImage.topAnchor.constraint(equalTo: self.cardView.topAnchor, constant: -120).isActive = true
		self.characterImage.centerXAnchor.constraint(equalTo: self.cardView.centerXAnchor).isActive = true
		self.characterImage.widthAnchor.constraint(equalToConstant: 240).isActive = true
		self.characterImage.heightAnchor.constraint(equalToConstant: 240).isActive = true
		self.characterImage.layer.borderWidth = 1.5
		self.characterImage.layer.masksToBounds = false
		self.characterImage.layer.borderColor = UIColor.gray.cgColor
		self.characterImage.layer.cornerRadius = 10
		self.characterImage.clipsToBounds = true

	}
	
	private func setupCardView() {
		self.view.addSubview(self.cardView)
		self.cardView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
		self.cardView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
		self.cardView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height / 4).isActive = true
		self.cardView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true

		self.cardView.layer.cornerRadius = 15
		self.cardView.backgroundColor = .systemBackground

		self.cardView.layer.shadowColor = UIColor.black.cgColor
		self.cardView.layer.shadowOpacity = 0.3
		self.cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
		self.cardView.layer.shadowRadius = 3
	}
	
	private func setupName() {
		self.cardView.addSubview(self.nameTitle)
		self.cardView.addSubview(self.nameLabel)
		self.nameTitle.topAnchor.constraint(equalTo: self.characterImage.bottomAnchor, constant: 40).isActive = true
		self.nameTitle.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 24).isActive = true
		self.nameTitle.widthAnchor.constraint(equalToConstant: 80).isActive = true
		self.nameLabel.topAnchor.constraint(equalTo: self.nameTitle.topAnchor).isActive = true
		self.nameLabel.leadingAnchor.constraint(equalTo: self.nameTitle.trailingAnchor, constant: 24).isActive = true
		self.nameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
	}
	
	private func setupSpecies() {
		self.cardView.addSubview(self.speciesLabel)
		self.cardView.addSubview(self.speciesTitle)
		self.speciesTitle.topAnchor.constraint(equalTo: self.nameTitle.bottomAnchor, constant: 28).isActive = true
		self.speciesTitle.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 24).isActive = true
		self.speciesTitle.widthAnchor.constraint(equalToConstant: 80).isActive = true
		
		self.speciesLabel.topAnchor.constraint(equalTo: self.speciesTitle.topAnchor).isActive = true
		self.speciesLabel.leadingAnchor.constraint(equalTo: self.speciesTitle.trailingAnchor, constant: 24).isActive = true
		self.speciesLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
	}
	
	private func setupGender() {
		self.cardView.addSubview(self.genderTitle)
		self.cardView.addSubview(self.genderLabel)
		self.genderTitle.topAnchor.constraint(equalTo: self.speciesTitle.bottomAnchor, constant: 28).isActive = true
		self.genderTitle.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 24).isActive = true
		self.genderTitle.widthAnchor.constraint(equalToConstant: 80).isActive = true
		
		self.genderLabel.topAnchor.constraint(equalTo: self.genderTitle.topAnchor).isActive = true
		self.genderLabel.leadingAnchor.constraint(equalTo: self.genderTitle.trailingAnchor, constant: 24).isActive = true
		self.genderLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
	}
	
	private func setupStatus() {
		self.cardView.addSubview(self.statusTitle)
		self.cardView.addSubview(self.statusLabel)
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
