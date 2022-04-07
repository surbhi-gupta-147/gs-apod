//
//  Date+Utilities.swift
//  NASADisplayView


import Foundation

extension Date {
    
    /// get current date in format
    func getCurrentDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        print(dateFormatter.string(from: date))
        return dateFormatter.string(from: date)
    }
}
