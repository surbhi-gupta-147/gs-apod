//
//  FavouriteList.swift
//  NASADisplayView
//

import UIKit
import CoreData

class FavouriteList: UIViewController {
    
    //**************************************************
    // MARK: - Constants
    //**************************************************
    
    var searchText: String = ""
    var presenter: FavouriteListViewToPresenterProtocol?
    var favorite: [Picture]?
    
    //**************************************************
    // MARK: - Outlets
    //**************************************************
    @IBOutlet weak var tableView: UITableView!
    
    //**************************************************
    // MARK: - Life Cycle Methods
    //**************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        presenter?.fetchFavorite()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupUI() {
        tableView.estimatedRowHeight = 110
        navigationItem.title = "My Favorites"
    }
    

    //**************************************************
    // MARK: - Actions
    //**************************************************
    
    
}

extension FavouriteList: FavouriteListPresenterToViewProtocol {
    
    func receivedFavorite(picture: [Picture]) {
        self.favorite = picture
        tableView.reloadData()
    }
}

extension FavouriteList: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favorite?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "listViewCell") as? ListViewCell {
            if favorite?.count != 0 {
                cell.titleLabel.text = self.favorite?[indexPath.row].value(forKey: "title") as? String
                cell.dateLabel.text = self.favorite?[indexPath.row].value(forKey: "date") as? String
                if let imageData = self.favorite?[indexPath.row].value(forKey: "image") as? Data {
                      cell.thumbNailImageView.image = UIImage(data: imageData)
                }
                return cell
            } else {
                return UITableViewCell()
            }
                
        } else {
            return UITableViewCell()
        }
       
    }
    
    
}
