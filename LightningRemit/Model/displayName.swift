//
//  displayName.swift
//  LightningRemit
//
//  Created by Temiloluwa on 03/07/2024.
//

import Foundation

extension Bundle {
    var displayName: String {
        return Bundle.main.infoDictionary?["CFBundleName"] as? String ?? Bundle.main
            .bundleIdentifier ?? "Unknown Bundle"
    }
}
