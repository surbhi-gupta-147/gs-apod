//
//  FavouriteListProtocols.swift


import UIKit

protocol FavouriteListViewToPresenterProtocol: class {
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    var view: FavouriteListPresenterToViewProtocol? { get set }
    var router: FavouriteListPresenterToRouterProtocol? { get set }
    
    //**************************************************
    // MARK: - Methods
    //**************************************************
    func fetchFavorite()
}

protocol FavouriteListPresenterToViewProtocol: class {
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    var presenter: FavouriteListViewToPresenterProtocol? { get set }
    
    //**************************************************
    // MARK: - Methods
    //**************************************************
    func receivedFavorite(picture: [Picture])

}

protocol FavouriteListPresenterToInteractorProtocol: class {
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    var presenter: FavouriteListInteractorToPresenterProtocol? { get set }
    
    //**************************************************
    // MARK: - Methods
    //**************************************************
    func fetchFavorite()
  
}

protocol FavouriteListInteractorToPresenterProtocol: class {
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    var interactor: FavouriteListPresenterToInteractorProtocol? { get set }
    
    //**************************************************
    // MARK: - Methods
    //**************************************************
    func receivedFavorite(picture: [Picture])
    
}

protocol FavouriteListPresenterToRouterProtocol: class {
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    
    //**************************************************
    // MARK: - Methods
    //**************************************************
   
  
}


