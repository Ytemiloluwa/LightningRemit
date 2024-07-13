//
//  Date+.swift
//  LightningRemit
//
//  Created by Temiloluwa on 12/07/2024.
//

import Foundation

extension Date {
    
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE 'at' h:mm a"
        let dateString = formatter.string(from: self)
        return dateString
    }
}
