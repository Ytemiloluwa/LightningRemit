//
//  PriceServiceError.swift
//  LightningRemit
//
//  Created by Temiloluwa on 09/07/2024.
//

import Foundation

enum PriceServiceError: Error {
    case invalidURL
    case invalidServerResponse
    case serialization
}
