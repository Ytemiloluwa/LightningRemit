//
//  Storage.swift
//  LightningRemit
//
//  Created by Temiloluwa on 03/07/2024.
//

import Foundation
import LDKNode

struct LightningStorage {
    func getDocumentsDirectory() -> String {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let pathString = path.path
        return pathString
    }
}
