//
//  ViewController.swift
//  EngineerAIDemo
//
//  Created by Venkatesh on 3/2/20.
//  Copyright © 2020 EngineerAI. All rights reserved.
//

import UIKit

class UserList: UIViewController {

    @IBOutlet weak var userListTableView: UITableView!
    private var users: [Users] = []
    private var limit = 10
    private var hasMore: Bool = false
    
    let headerConstant = 70
    let imageSizeConstant = Int(UIScreen.main.bounds.width / 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userListTableView.tableFooterView = UIView(frame: .zero)
        userListTableView.delegate = self
        userListTableView.dataSource = self
        
        userListTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
        userListTableView.estimatedRowHeight = 280
        userListTableView.rowHeight = UITableView.automaticDimension
        
        fetchUsers(limit: 10) { usersData in
            DispatchQueue.main.async {
                self.userListTableView.reloadData()
            }
        }
    }

    func fetchUsers(limit:Int, completionHandler: @escaping ([Users]) -> Void) {
        
        let url = URL(string: "http://sd2-hiring.herokuapp.com/api/users?offest=10&limit=\(limit)")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error While Fetching User List with \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Error While Fetching User List")
                    return
            }
            if let data = data,
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) {
                guard let jsonDict = jsonResponse as? [String: Any],
                    let dataList = jsonDict["data"] as? [String: Any] else {
                        return
                }
                let userList = dataList["users"] as? [[String:Any]]
                if let isPagingAllowed = dataList["has_more"] {
                    self.hasMore = isPagingAllowed as! Bool
                }
                self.users.removeAll()
                userList?.forEach { userInfo in
                    guard let name = userInfo["name"] as? String,
                        let userImage = userInfo["image"] as? String,
                        let userFeeds = userInfo["items"] as? [String] else { return }
                    let user = Users(name: name, userImage: userImage, userFeeds: userFeeds)
                    self.users.append(user)
                }
                completionHandler(self.users)
                print(self.users)
            }
        }
        task.resume()
    }
}

extension UserList : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (users.count > 0) ? users.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        userCell.setup(viewModel: TableViewModel(username: users[indexPath.row].name, userImage: users[indexPath.row].userImage, userFeedCollectionView: userCell.userFeedCollectionView, userFeedList: users[indexPath.row].userFeeds))
        
        if indexPath.row ==  users.count - 1 && hasMore == true {
            limit = limit + 10
            fetchUsers(limit: limit) { usersData in
                DispatchQueue.main.async {
                    self.userListTableView.reloadData()
                }
            }
        }
        userCell.layoutIfNeeded()
        userCell.userFeedCollectionView.reloadData()
        return userCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ((users[indexPath.row].userFeeds.count / 2) > 0) {
            if ((users[indexPath.row].userFeeds.count % 2) == 0) {
                return CGFloat((users[indexPath.row].userFeeds.count / 2) * imageSizeConstant + headerConstant)
            }else {
                return CGFloat((users[indexPath.row].userFeeds.count / 2) * imageSizeConstant + Int(userListTableView.frame.size.width) + headerConstant)
            }
        }
        return CGFloat(Int(userListTableView.frame.size.width) + headerConstant)
    }
}
