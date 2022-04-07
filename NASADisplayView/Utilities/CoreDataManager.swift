//
//  CoreDataManager.swift
//  NASADisplayView

import UIKit
import Foundation
import CoreData

class CoreDataManager {
    
    public static let sharedInstance = CoreDataManager()
    var managedObjectContext: NSManagedObjectContext?
    
    func configureCurrentContext() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.managedObjectContext = appDelegate?.persistentContainer.viewContext
    }
}

