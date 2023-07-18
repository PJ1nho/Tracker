//
//  DateFormatterService.swift
//  Tracker
//
//  Created by Тихтей  Павел on 22.05.2023.
//

import UIKit

class DateFormatterService {
    static let shared = DateFormatterService()
    
    private init() { }
    
    lazy var datePickerFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter
    }()
    
    lazy var dateFormatterCell: DateFormatter = {
        let dateFormatter = DateFormatter()
        return dateFormatter
    }()

    func getFormatterDate(date: Date) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let dateString = dateFormatter.string(from: date)
        let newDate = dateFormatter.date(from: dateString) ?? Date()
        return newDate
    }
}
