//
//  FavouriteListPresenter.swift

import UIKit
import Foundation

class FavouriteListPresenter: FavouriteListViewToPresenterProtocol {
    
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    weak var view: FavouriteListPresenterToViewProtocol?
    var interactor: FavouriteListPresenterToInteractorProtocol?
    var router: FavouriteListPresenterToRouterProtocol?
    
    //**************************************************
    // MARK: - Methods
    //**************************************************
    
    func fetchFavorite() {
        interactor?.fetchFavorite()
    }

}

extension FavouriteListPresenter: FavouriteListInteractorToPresenterProtocol {
    
    func receivedFavorite(picture: [Picture]) {
        view?.receivedFavorite(picture: picture)
    }
    
}
