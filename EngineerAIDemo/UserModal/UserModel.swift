//
//  UserModel.swift
//  EngineerAIDemo
//
//  Created by Venkatesh on 3/2/20.
//  Copyright © 2020 EngineerAI. All rights reserved.
//

import Foundation
import UIKit

struct Users {
    
    var name: String!
    var userImage: String!
    var userFeeds: [String]!
    
    init(name: String, userImage: String, userFeeds: [String]) {
        self.name = name
        self.userImage = userImage
        self.userFeeds = userFeeds
    }
}
