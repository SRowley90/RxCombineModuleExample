//
//  File.swift
//  
//
//  Created by Sam Rowley on 27/10/2021.
//

import Foundation
import UIKit
import Combine
import Networking

public class PictureViewController: UIViewController {
    private var networkProvider: NetworkProviding
    private let apiProvider: PicturesAPIProviding
    
    internal var cancellables = Set<AnyCancellable>()
    internal let imageCache = NSCache<AnyObject, AnyObject>()
    
    var viewModel: PicturesViewModel
    
    public init(networkProvider: NetworkProviding, apiProvider: PicturesAPIProviding, viewModel: PicturesViewModel) {
        self.networkProvider = networkProvider
        self.apiProvider = apiProvider
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var barButtonItem: UIBarButtonItem!
    
    var tableView: UITableView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
                
        barButtonItem = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(self.action))
        self.navigationItem.rightBarButtonItem = barButtonItem
        
        tableView = UITableView()
        view.addSubview(tableView)
        
        tableView.register(UINib(nibName: "PictureCell", bundle: Bundle.module), forCellReuseIdentifier: "PictureCell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        tableView.dataSource = self
        
        viewModel.$photos.sink { photos in
            self.tableView.reloadData()
        }.store(in: &cancellables)
    }
    
    @objc func action(_ sender: UIBarButtonItem) {
        viewModel.getPhotos()
    }
}

extension PictureViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let photo = viewModel.photos[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PictureCell", for: indexPath) as! PictureCell
        cell.titleLabel?.text = photo.title
        
        cell.pictureThumbnail?.image = nil
        if let imageFromCache = imageCache.object(forKey: photo.id as AnyObject) as? UIImage {
                cell.pictureThumbnail?.image = imageFromCache
            } else {
                
                URLSession.shared.dataTask(with: URL(string: photo.thumbnailUrl)!, completionHandler: { (data, _, error) -> Void in
                    guard let data = data, error == nil else {
                        print("\nerror on download \(error!)")
                        return
                    }
                    DispatchQueue.main.async {
                        let imageToCache = UIImage(data: data)
                        self.imageCache.setObject(imageToCache!, forKey: photo.id as AnyObject)
                        cell.pictureThumbnail?.image = imageToCache
                        cell.setNeedsLayout()
                    }
                }).resume()
            }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
}
