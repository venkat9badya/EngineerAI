//
//  UserTableViewCell.swift
//  EngineerAIDemo
//
//  Created by Venkatesh on 3/5/20.
//  Copyright © 2020 EngineerAI. All rights reserved.
//

import UIKit
import SDWebImage

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userFeedCollectionView: UICollectionView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    var userFeedList: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width / 2-15), height: (UIScreen.main.bounds.width / 2-15))
        flowLayout.minimumInteritemSpacing = 10.0
        userFeedCollectionView.collectionViewLayout = flowLayout
        
        userFeedCollectionView.delegate = self
        userFeedCollectionView.dataSource = self
        userFeedCollectionView.register(UINib(nibName: "UserFeedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UserFeedCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(viewModel: TableViewModel){
        userImageView.sd_setImage(with: URL(string: viewModel.userImage), placeholderImage: UIImage(named: "PlaceHolder"))
        userName.text = viewModel.userName
        userFeedCollectionView = viewModel.userFeedCollectionView
        userFeedList = viewModel.userFeedList
    }
}

struct TableViewModel {
    var userName: String!
    var userImage: String!
    var userFeedCollectionView: UICollectionView!
    var userFeedList: [String]!
    
    init(username: String, userImage: String, userFeedCollectionView: UICollectionView, userFeedList: [String]) {
        self.userName = username
        self.userImage = userImage
        self.userFeedCollectionView = userFeedCollectionView
        self.userFeedList = userFeedList
    }
}

//MARK: CollectionView Delegate and DataSources

extension UserTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userFeedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserFeedCollectionViewCell", for: indexPath) as! UserFeedCollectionViewCell
        feedCell.setup(viewModel: CollectionViewModel(image: userFeedList[indexPath.row]))
        return feedCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            if ((userFeedList.count / 2) > 0) {
                if ((userFeedList.count % 2) == 0) {
                    return CGSize(width: (UIScreen.main.bounds.width / 2-15), height: (UIScreen.main.bounds.width / 2-15))
                }else {
                    return CGSize(width: (self.userFeedCollectionView.frame.width), height: (self.userFeedCollectionView.frame.width))
                }
            }
            return CGSize(width: (self.userFeedCollectionView.frame.width), height: (self.userFeedCollectionView.frame.width))
        }else {
            return CGSize(width: (UIScreen.main.bounds.width / 2-15), height: (UIScreen.main.bounds.width / 2-15))
        }
    }
}
