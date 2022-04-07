//
//  ImageDisplayViewBuilder.swift




import Foundation
import UIKit

class ImageDisplayViewBuilder {
    
    //**************************************************
    // MARK: - Constants
    //**************************************************
    
    enum ImageDisplayViewBuilderConstants {
        static let ImageDisplayViewStoryboard = "Main"
        static let ImageDisplayViewNavController = "NavigationVC"
    }
    
    //**************************************************
    // MARK: - Public Methods
    //**************************************************
    
    
    public class func createImageDisplayViewModule() -> UINavigationController? {
 
        let mainStoryboard = UIStoryboard(name: ImageDisplayViewBuilderConstants.ImageDisplayViewStoryboard,bundle: Bundle.main)
        if let navVC = mainStoryboard.instantiateViewController(withIdentifier: ImageDisplayViewBuilderConstants.ImageDisplayViewNavController) as? UINavigationController, let view = navVC.topViewController as? ViewController {
            
            let presenter: ImageDisplayViewToPresenterProtocol & ImageDisplayViewInteractorToPresenterProtocol = ImageDisplayViewPresenter()
            let interactor: ImageDisplayViewPresenterToInteractorProtocol = ImageDisplayViewInteractor()
            let router: ImageDisplayViewPresenterToRouterProtocol = ImageDisplayViewRouter()
            
            view.presenter = presenter
            presenter.view = view
            presenter.interactor = interactor
            interactor.presenter = presenter
            presenter.router = router
            
            return navVC
        } else {
            return nil
        }
    
    }
}
