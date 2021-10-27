//
//  CommentsViewController.swift
//  RxCombineModule
//
//  Created by Sam Rowley on 20/10/2021.
//

import UIKit
import Alamofire
import RxSwift
import SwiftyJSON


class CommentsViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let tableView: UITableView = UITableView()
    var post: Post!
    
    var comments: [Comment] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    init(with post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.title = "Comments"
        self.navigationItem.largeTitleDisplayMode = .never
        
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        Session.default.request(for: Endpoint.comments(postId: self.post.id), in: Environment.debug, with: [:], and: [:])
            .subscribe { (response, data) in
                let json = try! JSON(data: data)
                var comments = [Comment]()
                for item in json.arrayValue {
                    let comment = Comment(postId: item["postId"].intValue, id: item["id"].intValue, name: item["name"].stringValue, email: item["email"].stringValue, body: item["body"].stringValue)
                    comments.append(comment)
                }
                self.comments = comments
            } onFailure: { error in
                let alert = UIAlertController(title: "Error", message: "Could not get Posts", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } onDisposed: {
                
            }.disposed(by: disposeBag)
    }
}


extension CommentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        let comment = self.comments[indexPath.row]
        cell.textLabel?.text = "\(comment.name)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
}
