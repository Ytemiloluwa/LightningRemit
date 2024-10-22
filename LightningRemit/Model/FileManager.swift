//
//  FileManager.swift
//  LightningRemit
//
//  Created by Temiloluwa on 03/07/2024.
//

import Foundation

extension FileManager {
    func getDocumentsDirectoryPath() -> String {
        let path = URL.documentsDirectory.path
        return path
    }

    func deleteAllContentsInDocumentsDirectory() throws {
        let documentsURL = URL.documentsDirectory
        let contents = try contentsOfDirectory(
            at: documentsURL,
            includingPropertiesForKeys: nil,
            options: []
        )
        for fileURL in contents {
            try removeItem(at: fileURL)
        }
    }
}
