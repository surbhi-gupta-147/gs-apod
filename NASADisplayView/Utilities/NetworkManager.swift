//
//  NetworkManager.swift
//  NASADisplayView


import Foundation

class NetworkManager {
    
    public static let sharedInstance = NetworkManager()
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
