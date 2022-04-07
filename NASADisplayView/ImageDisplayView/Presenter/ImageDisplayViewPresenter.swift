//
//  ImageDisplayViewPresenter.swift

import UIKit
import Foundation

class ImageDisplayViewPresenter: ImageDisplayViewToPresenterProtocol {
    
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    weak var view: ImageDisplayViewPresenterToViewProtocol?
    var interactor: ImageDisplayViewPresenterToInteractorProtocol?
    var router: ImageDisplayViewPresenterToRouterProtocol?
    
    //**************************************************
    // MARK: - Methods
    //**************************************************

    func getApodData(param: String?) {
        interactor?.getPicData(param: param)
    }

    func fetchPictureData(searchText: String?) {
        interactor?.fetchPictureData(searchText: searchText)
    }
    
    func fetchImage(url: String?, searchText: String?) {
        interactor?.fetchImage(url: url, searchText: searchText)
    }
    
    func setFavorite(isFavorite: Bool, searchText: String?) {
        interactor?.setFavorite(isFavorite: isFavorite, searchText: searchText)
    }
    
    func fetchFav(searchText: String?) {
        interactor?.fetchFav(searchText: searchText)
    }
    
    func navigateToFavList() {
        if let view = view {
            router?.navigateToFavList(from: view)
        }
       
    }
}

extension ImageDisplayViewPresenter: ImageDisplayViewInteractorToPresenterProtocol {

    func dataReceived() {
        view?.dataReceived()
    }
    
    func failureReceived() {
        view?.failureReceived()
    }
    
    func loadData(data: Picture) {
        view?.loadData(data: data)
    }
    
    func loadFailed() {
        view?.loadFailed()
    }
    
    func imageDataReceived(data: Data) {
        view?.imageDataReceived(data: data)
    }
    
    func isFavorite(isFav: Bool) {
        view?.isFavorite(isFav: isFav)
    }
    
}
