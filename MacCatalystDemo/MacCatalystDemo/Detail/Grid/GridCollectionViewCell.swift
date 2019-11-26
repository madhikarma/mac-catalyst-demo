//
//  GridCollectionViewCell.swift
//  MacCatalystDemo
//
//  Created by Beta on 21/11/2019.
//  Copyright © 2019 Beta. All rights reserved.
//

import UIKit

final class GridCollectionViewCell: UICollectionViewCell {

    @IBOutlet private(set) weak var imageView: UIImageView!
    @IBOutlet private(set) weak var titleLabel: UILabel!
    
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clearContent()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        clearContent()
    }
    

    // MARK: - Private
    
    private func clearContent() {
        if Config.shared.isDebugColorsEnabled {
            contentView.backgroundColor = .blue
            backgroundColor = .red
            imageView.backgroundColor = .orange
            titleLabel.backgroundColor = .yellow
        } else {
            contentView.backgroundColor = .clear
            backgroundColor = .clear
            imageView.backgroundColor = .clear
            titleLabel.backgroundColor = .clear

        }
        
        titleLabel.text = nil
        imageView.image = nil
    }

}
