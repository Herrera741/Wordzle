//
//  KeyCell.swift
//  Wordzle
//
//  Created by Sergio Herrera on 7/5/22.
//

import UIKit

class KeyCell: UICollectionViewCell {
    
    static let identifier = "KeyCell"
    private var isActionKey = false
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray
        contentView.addSubview(label)
        // label constraints for leading/trailing/top/bottom
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    func configure(with letter: Character) {
        
        var foundActionKey: Character?
        let actionKeys: [Character] = ["<", ">"]
        var text: String
        
        for actionKey in actionKeys {
            if actionKey == letter {
                isActionKey = true
                foundActionKey = actionKey
            }
        }
        
        if isActionKey {
            guard let foundActionKey = foundActionKey else {
                return
            }
            
            text = (foundActionKey == "<") ? "Enter" : "Del"
            
        } else {
            text = String(letter).uppercased()
        }
        
        label.text = text
    }
    
    
    
}
