//
//  ImageDisplayViewProtocols.swift


import UIKit

protocol ImageDisplayViewToPresenterProtocol: class {
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    var view: ImageDisplayViewPresenterToViewProtocol? { get set }
    var router: ImageDisplayViewPresenterToRouterProtocol? { get set }
    
    //**************************************************
    // MARK: - Methods
    //**************************************************
    func getApodData(param: String?)
    func fetchPictureData(searchText: String?)
    func fetchImage(url: String?, searchText: String?)
    func setFavorite(isFavorite: Bool, searchText: String?)
    func fetchFav(searchText: String?)
    func navigateToFavList()
}

protocol ImageDisplayViewPresenterToViewProtocol: class {
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    var presenter: ImageDisplayViewToPresenterProtocol? { get set }
    
    //**************************************************
    // MARK: - Methods
    //**************************************************
    func dataReceived()
    func failureReceived()
    func loadData(data: Picture)
    func loadFailed()
    func imageDataReceived(data: Data)
    func isFavorite(isFav: Bool)
}

protocol ImageDisplayViewPresenterToInteractorProtocol: class {
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    var presenter: ImageDisplayViewInteractorToPresenterProtocol? { get set }
    
    //**************************************************
    // MARK: - Methods
    //**************************************************
    func fetchPictureData(searchText: String?)
    func fetchImage(url: String?, searchText: String?)
    func setFavorite(isFavorite: Bool, searchText: String?)
    func fetchFav(searchText: String?)
    func getPicData(param: String?)
}

protocol ImageDisplayViewInteractorToPresenterProtocol: class {
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    var interactor: ImageDisplayViewPresenterToInteractorProtocol? { get set }
    
    //**************************************************
    // MARK: - Methods
    //**************************************************
    func dataReceived()
    func failureReceived()
    func loadData(data: Picture)
    func loadFailed()
    func imageDataReceived(data: Data)
    func isFavorite(isFav: Bool)
}

protocol ImageDisplayViewPresenterToRouterProtocol: class {
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    
    //**************************************************
    // MARK: - Methods
    //**************************************************
    func navigateToFavList(from view: ImageDisplayViewPresenterToViewProtocol)
  
}


