//
//  FavouriteListInteractor.swift
//

import UIKit
import Foundation
import CoreData

class FavouriteListInteractor: FavouriteListPresenterToInteractorProtocol {
    
    
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    weak var presenter: FavouriteListInteractorToPresenterProtocol?
    
    //**************************************************
    // MARK: - Methods
    //**************************************************
    
    func fetchFavorite() {
        
        guard let managedObjectContext = CoreDataManager.sharedInstance.managedObjectContext else {
            return
        }
        
        let favPredicate = NSPredicate(format: "isFavorite == true")
        let fetchRequest = Picture.fetchRequest()
        fetchRequest.predicate = favPredicate
        managedObjectContext.perform {
            do {
                let result = try fetchRequest.execute()
                self.presenter?.receivedFavorite(picture: result)
            } catch {
                print("Error fetching favorite")
            }
        }
    }
    
}
