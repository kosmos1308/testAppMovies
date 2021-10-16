//
//  CustomCollectionViewCell.swift
//  testAppMovies
//
//  Created by pavel on 15.10.21.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "cell"
    
    private let movieLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "heart"), for: .normal)
        button.backgroundColor = .clear
        
        
        return button
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemRed
        contentView.addSubview(movieLabel)
        contentView.addSubview(likeButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        movieLabel.frame = CGRect(x: 15, y: 10, width: contentView.frame.size.width - 80, height: 40)
        likeButton.frame = CGRect(x: contentView.frame.size.width - 55, y: 10, width: 40, height: 40)
        
    }
    
    
    public func configureLabel(label: String) {
        movieLabel.text = label
        movieLabel.font = UIFont(name: "Helvetica Neue Bold", size: 17)
        
    }
    
    public func configureButton(tag: Int) {
        likeButton.tag = tag
    }
    
    
    public func getButton() -> UIButton {
        
        return likeButton
    }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    
}
