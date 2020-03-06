//
//  UserCollectionViewCell.swift
//  EngineerAIDemo
//
//  Created by Venkatesh on 3/5/20.
//  Copyright © 2020 EngineerAI. All rights reserved.
//

import UIKit

class UserFeedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var feedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(viewModel: CollectionViewModel){
        feedImageView.sd_setImage(with: URL(string: viewModel.image), placeholderImage: nil)
    }
}

struct CollectionViewModel {
    var image: String!
    init(image: String){
        self.image = image
    }
}
