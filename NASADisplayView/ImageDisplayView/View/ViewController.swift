//
//  ViewController.swift
//  NASADisplayView
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    //**************************************************
    // MARK: - Constants
    //**************************************************
    
    var searchText: String = ""
    var presenter: ImageDisplayViewToPresenterProtocol?
    
    //**************************************************
    // MARK: - Outlets
    //**************************************************
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var favoriteButton: UIButton!
    
    //**************************************************
    // MARK: - Life Cycle Methods
    //**************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavBar()
        presenter?.getApodData(param: "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupNavBar() {
        let listViewButton = UIBarButtonItem(image: UIImage(systemName: "list.star"), style: .plain, target: self, action: #selector(self.displayFavList))
        self.navigationItem.rightBarButtonItem  = listViewButton
    }
    
    @objc func displayFavList() {
        presenter?.navigateToFavList()
    }
    
    //**************************************************
    // MARK: - Actions
    //**************************************************
    @IBAction func setfavorite(_ sender: Any) {
        presenter?.fetchFav(searchText: searchText)
    }
    
    
}

extension ViewController: UISearchBarDelegate {
    
    //**************************************************
    // MARK: - Search Bar Delegates
    //**************************************************
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchBarText = searchBar.text, !searchBarText.isEmpty {
            self.searchText = searchBarText
            performSearchAction(with: searchBarText)
        }
    }
    
    // Search Action
    func performSearchAction(with searchText: String?) {
        searchBar.resignFirstResponder()
        if let dateText = searchText {
            presenter?.getApodData(param: dateText)
        }
    }
}

extension ViewController: ImageDisplayViewPresenterToViewProtocol {
    
    func dataReceived() {
        presenter?.fetchPictureData(searchText: searchText)
    }
    
    func failureReceived() {
        print("Error")
        presenter?.fetchPictureData(searchText: searchText)
    }
    
    func loadData(data: Picture) {
        if let pictureTitle = data.value(forKey: "title") as? String {
            titleLabel.text = pictureTitle
        }
        if let dateValue = data.value(forKey: "date") as? String {
            dateLabel.text = "Dated: " + dateValue
        }
        if let descValue = data.value(forKey: "explanation") as? String {
            descLabel.text = descValue
        }
        if let imageURL = data.value(forKey: "hdurl") as? String {
            presenter?.fetchImage(url: imageURL, searchText: searchText)
        }
        if let favorite = data.value(forKey: "isFavorite") as? Bool {
            setFavButton(favorite: favorite)
        } else {
            setFavButton(favorite: false)
        }
    }
    
    func setFavButton(favorite: Bool) {
        if favorite {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    func loadFailed() {
        print("Error")
    }
    
    func imageDataReceived(data: Data) {
        DispatchQueue.main.async {
            self.imageView.image = UIImage(data: data)
        }
    }
    
    func isFavorite(isFav: Bool) {
        presenter?.setFavorite(isFavorite: !isFav, searchText: searchText)
        setFavButton(favorite: !isFav)
    }
    
}
