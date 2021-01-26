//
//  CharacterCell.swift
//  RickAndMorty
//
//  Created by сергей on 23.01.2021.
//

import UIKit

class CharacterCell: UITableViewCell {
    
    let nameLabel = UILabel()
    let statusLabel = UILabel()
    let lastLocation = UILabel()
    let locationLabel = UILabel()
    let mainImage = UIImageView(image: UIImage(named: "iceT"))
    var mainStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layer.borderWidth = 4
        layer.borderColor = CGColor(red: 142, green: 142, blue: 147, alpha: 0.3)
        lastLocation.text = "Last known location:"
        setupCell()
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        
        // fonts configuration
        nameLabel.font = UIFont.boldSystemFont(ofSize: 28)
        nameLabel.adjustsFontSizeToFitWidth = true
        statusLabel.font = UIFont.systemFont(ofSize: 17)
        lastLocation.font = UIFont.systemFont(ofSize: 14)
        locationLabel.font = UIFont.systemFont(ofSize: 17)
        locationLabel.adjustsFontSizeToFitWidth = true
        
        // fonts color configuration
        nameLabel.textColor = .white
        statusLabel.textColor = .white
        lastLocation.textColor = .lightGray
        locationLabel.textColor = .white

        
        // create stackViews
        let topStackView = UIStackView(arrangedSubviews: [nameLabel, statusLabel])
        let centerStackView = UIStackView(arrangedSubviews: [lastLocation, locationLabel])
        let textStackView = UIStackView(arrangedSubviews: [topStackView, centerStackView])
        mainStackView = UIStackView(arrangedSubviews: [mainImage, textStackView])
        
        // configure stacks
        topStackView.axis = .vertical
        topStackView.alignment = .leading
        topStackView.distribution = .fill
        topStackView.spacing = 2
        
        centerStackView.axis = .vertical
        centerStackView.alignment = .leading
        centerStackView.distribution = .fill
        centerStackView.spacing = 2
        
        textStackView.axis = .vertical
        textStackView.alignment = .leading
        textStackView.distribution = .fill
        textStackView.spacing = 16
        
        mainStackView.axis = .horizontal
        mainStackView.alignment = .top
        mainStackView.distribution = .fill
        mainStackView.spacing = 8
        
        // add subviews
        contentView.addSubview(mainStackView)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
//            mainImage.widthAnchor.constraint(
//                lessThanOrEqualToConstant:
//                    (contentView.frame.width / 2) - (contentView.frame.width * 0.05))
            mainImage.widthAnchor.constraint(
                equalToConstant: (contentView.frame.width / 2) - (contentView.frame.width * 0.05))
        ])
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    
    
}
