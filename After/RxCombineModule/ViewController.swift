//
//  ViewController.swift
//  RxCombineModule
//
//  Created by Sam Rowley on 20/10/2021.
//

import UIKit
import Alamofire
import RxSwift
import SwiftyJSON
import Pictures

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let authController = AuthController()
    
    var isPinValid = false
    
    let disposeBag = DisposeBag()
    
    var posts: [Post] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var barButtonItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
                
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.title = "Posts"
        
        tableView.dataSource = self
        tableView.delegate = self
        
        barButtonItem = UIBarButtonItem(image: UIImage(systemName: "lock"), style: .plain, target: self, action: #selector(self.action))
        self.navigationItem.rightBarButtonItem = barButtonItem
        
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(self.pictures))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        Session.default.request(for: Endpoint.posts, in: Environment.debug, with: [:], and: [:])
            .subscribe { (response, data) in
                let json = try! JSON(data: data)
                var posts = [Post]()
                for item in json.arrayValue {
                    let post = Post(id: item["id"].intValue, userID: item["userId"].intValue, title: item["title"].stringValue, body: item["body"].stringValue)
                    posts.append(post)
                }
                self.posts = posts
            } onFailure: { error in
                let alert = UIAlertController(title: "Error", message: "Could not get Posts", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } onDisposed: {
                
            }.disposed(by: disposeBag)
                
        self.setupSubsccribers()
    }
    
    private func setupSubsccribers() {
        authController.isValidPIN.subscribe { event in
            self.isPinValid = event.element!
            self.barButtonItem.image = event.element == false ? UIImage(systemName: "lock") : UIImage(systemName: "lock.open")
        }.disposed(by: disposeBag)
    }
    
    @objc func action(_ sender: UIBarButtonItem) {
        self.authController.togglePinValid()
    }
    
    @objc func pictures(_ sender: UIBarButtonItem) {
        let networkProvider = NetworkProvider()
        let apiProvider = PicturesAPIProvider(authController: authController)
        let pictureContainer = Container(networkProvider: networkProvider, apiProvider: apiProvider)
        let picturesVC = pictureContainer.makeGMViewController()
        present(UINavigationController(rootViewController: picturesVC), animated: true, completion: nil)
    }
}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        let post = posts[indexPath.row]
        
        cell.textLabel?.text = post.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isPinValid {
            let post = posts[indexPath.row]
            let commentsVC = CommentsViewController(with: post)
            self.navigationController?.pushViewController(commentsVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Need a valid Pin", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
