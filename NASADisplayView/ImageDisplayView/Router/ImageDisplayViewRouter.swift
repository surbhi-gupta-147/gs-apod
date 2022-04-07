//
//  ImageDisplayViewRouter.swift


import Foundation
import UIKit

class ImageDisplayViewRouter: ImageDisplayViewPresenterToRouterProtocol {
   
    
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    //**************************************************
    // MARK: - Methods
    //**************************************************
    func navigateToFavList(from view: ImageDisplayViewPresenterToViewProtocol) {
        if let favListVC = FavouriteListBuilder.createFavortiteListModule(), let view = view as? ViewController {
            view.navigationController?.pushViewController(favListVC, animated: true)
        }
    }
    
}
