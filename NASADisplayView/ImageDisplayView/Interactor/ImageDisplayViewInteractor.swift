//
//  ImageDisplayViewInteractor.swift
//

import UIKit
import Foundation
import CoreData

class ImageDisplayViewInteractor: ImageDisplayViewPresenterToInteractorProtocol {
    
    
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    weak var presenter: ImageDisplayViewInteractorToPresenterProtocol?
    
    //**************************************************
    // MARK: - Methods
    //**************************************************
    
    // Check local DB to see if data exist else make API call
    func getPicData(param: String?) {
        fetchPictureDataFromDB(searchText: param) { picture in
            if let pic = picture {
                self.presenter?.loadData(data: pic)
            } else {
                self.getApodData(param: param)
            }
        }
    }
    
    /// API Call to get the APOD data
    private func getApodData(param: String?) {
        if let url = URL(string: constructApodURL(param: param ?? "")) { // No date passed is considered as current date
            NetworkManager.sharedInstance.getData(from: url) { [self] data, response, error in
                if error == nil {
                    do {
                        let json =  try JSONSerialization.jsonObject(with: data!, options: [])
                        print("API DATA: \(json)")
                        self.saveDataToDB(json: json as! NSDictionary)
                    } catch {
                        print("Error during JSON serialization: \(error.localizedDescription)")
                    }
                } else {
                    self.presenter?.loadFailed()
                }
            }
        }
        
    }
    
    // Construct URL. Expand and move to new class for extra params to be added
    func constructApodURL(param: String?) -> String {
        var url = ""
        let baseURL = "https://api.nasa.gov/planetary/apod?api_key=r5Mn4YZKLsm6sTYABfDV5CAGsabTzOyw8i6luxbM"
        if let dateString = param, dateString != "" {
            url = baseURL+"&date="+dateString
            return url
        } else {
            return baseURL
        }
    }
    
    //MARK:- APOD DATA Save and Fetch
    
    func saveDataToDB(json: NSDictionary) {
        DispatchQueue.main.async { [self] in
            guard let managedObjectContext = CoreDataManager.sharedInstance.managedObjectContext else {
                return
            }
            
            let picture = Picture(context: managedObjectContext)
            picture.date = json["date"] as? String
            picture.explanation = json["explanation"] as? String
            picture.title = json["title"] as? String
            picture.hdurl = json["hdurl"] as? String
            picture.media_type = json["media_type"] as? String
            picture.service_version = json["service_version"] as? String
            picture.url = json["url"] as? String
            
            do {
                try managedObjectContext.save()
                self.presenter?.dataReceived()
            } catch {
                print("Error saving Data: \(error.localizedDescription)")
                self.presenter?.failureReceived()
            }
        }
        
    }
    
    func fetchPictureData(searchText: String?) {
        
        guard let managedObjectContext = CoreDataManager.sharedInstance.managedObjectContext else {
            return
        }
        var searchDate = searchText
        if searchDate == "" {
            searchDate = Date().getCurrentDate()
        }
        
        let datePredicate = NSPredicate(format: "date == %@", searchDate as! CVarArg)
        let fetchRequest = Picture.fetchRequest()
        fetchRequest.predicate = datePredicate
        
        managedObjectContext.perform {
            do {
                let result = try fetchRequest.execute()
                for picture in result {
                    self.presenter?.loadData(data: picture)
                }
            } catch {
                self.presenter?.loadFailed()
            }
        }
    }
    
    // TODO: Refactor to have single method
    func fetchPictureDataFromDB(searchText: String?, completion: @escaping (Picture?) -> Void) {
        
        guard let managedObjectContext = CoreDataManager.sharedInstance.managedObjectContext else {
            return
        }
        var searchDate = searchText
        if searchDate == "" {
            searchDate = Date().getCurrentDate()
        }
        
        let datePredicate = NSPredicate(format: "date == %@", searchDate as! CVarArg)
        let fetchRequest = Picture.fetchRequest()
        fetchRequest.predicate = datePredicate
        
        managedObjectContext.perform {
            do {
                let result = try fetchRequest.execute()
                if result.count > 0 {
                    for picture in result {
                        completion(picture)
                    }
                } else {
                    completion(nil)
                }
                
            } catch {
                completion(nil)
            }
        }
    }
    
    
    //MARK:- Image Save and Fetch
    func fetchImage(url: String?, searchText: String?) {
        fetchImageData(searchText: searchText, url: url)
    }
    
    private func downloadImage(from url: URL, searchText: String?) {
        print("Download Started")
        NetworkManager.sharedInstance.getData(from: url) { [self] data, response, error in
            if let data = data, error == nil {
                print("Download Finished")
                saveImageToDB(imageData: data, searchText: searchText)
                
            } else {
                print("Download Failed")
                self.presenter?.loadFailed()
            }
        }
    }
    
    private func saveImageToDB(imageData: Data, searchText: String?) {
        guard let managedObjectContext = CoreDataManager.sharedInstance.managedObjectContext else {
            return
        }
        
        var searchDate = searchText
        if searchDate == "" {
            searchDate = Date().getCurrentDate()
        }
        
        let datePredicate = NSPredicate(format: "date == %@", searchDate as! CVarArg)
        let fetchRequest = Picture.fetchRequest()
        fetchRequest.predicate = datePredicate
        managedObjectContext.perform {
            do {
                let result = try fetchRequest.execute()
                for picture in result {
                    picture.image = imageData
                    try managedObjectContext.save()
                    print("Image Saved")
                    self.presenter?.imageDataReceived(data: imageData)
                }
            } catch {
                
                print("Error saving Image: \(error.localizedDescription)")
                self.presenter?.loadFailed()
            }
        }
        
    }
    
    func fetchImageData(searchText: String?, url: String?) {
        
        guard let managedObjectContext = CoreDataManager.sharedInstance.managedObjectContext else {
            return
        }
        var searchDate = searchText
        if searchDate == "" {
            searchDate = Date().getCurrentDate()
        }
        
        let datePredicate = NSPredicate(format: "date == %@", searchDate as! CVarArg)
        let fetchRequest = Picture.fetchRequest()
        fetchRequest.predicate = datePredicate
        fetchRequest.propertiesToFetch = ["image"]
        managedObjectContext.perform {
            do {
                let result = try fetchRequest.execute()
                if result.count > 0 {
                    for picture in result {
                        if let imageData =  (picture as? Picture)?.value(forKey: "image") as? Data {
                            self.presenter?.imageDataReceived(data: imageData)
                        } else {
                            if let urlString = url, let urlRequest = URL(string: urlString) {
                                self.downloadImage(from: urlRequest, searchText: searchText)
                            }
                        }
                    }
                } else {
                    if let urlString = url, let urlRequest = URL(string: urlString) {
                        self.downloadImage(from: urlRequest, searchText: searchText)
                    }
                }
            } catch {
                
                if let urlString = url, let urlRequest = URL(string: urlString) {
                    self.downloadImage(from: urlRequest, searchText: searchText)
                }
            }
        }
    }
    
    //MARK:- Image Save and Fetch
    func setFavorite(isFavorite: Bool, searchText: String?) {
        guard let managedObjectContext = CoreDataManager.sharedInstance.managedObjectContext else {
            return
        }
        
        var searchDate = searchText
        if searchDate == "" {
            searchDate = Date().getCurrentDate()
        }
        
        let datePredicate = NSPredicate(format: "date == %@", searchDate as! CVarArg)
        let fetchRequest = Picture.fetchRequest()
        fetchRequest.predicate = datePredicate
        managedObjectContext.perform {
            do {
                let result = try fetchRequest.execute()
                for picture in result {
                    picture.isFavorite = isFavorite
                    try managedObjectContext.save()
                    print("Favorite Saved")
                }
            } catch {
                
                print("Error saving favorite: \(error.localizedDescription)")
                self.presenter?.loadFailed()
            }
        }
        
    }
    
    func fetchFav(searchText: String?) {
        
        guard let managedObjectContext = CoreDataManager.sharedInstance.managedObjectContext else {
            return
        }
        var searchDate = searchText
        if searchDate == "" {
            searchDate = Date().getCurrentDate()
        }
        
        let datePredicate = NSPredicate(format: "date == %@", searchDate as! CVarArg)
        let fetchRequest = Picture.fetchRequest()
        fetchRequest.predicate = datePredicate
        fetchRequest.propertiesToFetch = ["isFavorite"]
        managedObjectContext.perform {
            do {
                let result = try fetchRequest.execute()
                for picture in result {
                    if let isFav =  (picture as? Picture)?.value(forKey: "isFavorite") as? Bool {
                        self.presenter?.isFavorite(isFav: isFav)
                    } else {
                        self.presenter?.isFavorite(isFav: false)
                    }
                }
            } catch {
                self.presenter?.isFavorite(isFav: false)
            }
        }
    }
    
}
