//
//  DateExtensions.swift
//  MinDag
//
//  Created by Paul Philip Mitchell on 11/05/16.
//  Copyright © 2016 Universitetet i Oslo. All rights reserved.
//

import Foundation

extension NSDate {
    
    func toString(format: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(self)
    }
    
    func toStringDetailed() -> String {
        return self.toString("dd.MM.yyyy HH:mm:ss")
    }
    
    func isWeekend() -> Bool {
        let calendar = NSCalendar.currentCalendar()
        let day = calendar.component(.Weekday, fromDate: self)
        
        return day == 7 || day == 1
    }
    
    func isWeekday() -> Bool {
        let calendar = NSCalendar.currentCalendar()
        let day = calendar.component(.Weekday, fromDate: self)
        
        return day != 7 && day != 1
    }
    
}
