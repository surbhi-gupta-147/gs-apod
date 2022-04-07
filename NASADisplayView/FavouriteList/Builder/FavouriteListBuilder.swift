//
//  FavouriteListBuilder.swift

import Foundation
import UIKit

class FavouriteListBuilder {
    
    //**************************************************
    // MARK: - Constants
    //**************************************************
    
    enum FavouriteListBuilderConstants {
        static let FavouriteListViewStoryboard = "FavouriteList"
        static let FavouriteListViewNavController = "FavouriteList"
    }
    
    //**************************************************
    // MARK: - Public Methods
    //**************************************************
    
    
    public class func createFavortiteListModule() -> FavouriteList? {
 
        let mainStoryboard = UIStoryboard(name: FavouriteListBuilderConstants.FavouriteListViewStoryboard,bundle: Bundle.main)
        if let view = mainStoryboard.instantiateViewController(withIdentifier: FavouriteListBuilderConstants.FavouriteListViewNavController) as? FavouriteList {
            
            let presenter: FavouriteListViewToPresenterProtocol & FavouriteListInteractorToPresenterProtocol = FavouriteListPresenter()
            let interactor: FavouriteListPresenterToInteractorProtocol = FavouriteListInteractor()
            let router: FavouriteListPresenterToRouterProtocol = FavouriteListRouter()
            
            view.presenter = presenter
            presenter.view = view
            presenter.interactor = interactor
            interactor.presenter = presenter
            presenter.router = router
            
            return view
        } else {
            return nil
        }
    
    }
}
