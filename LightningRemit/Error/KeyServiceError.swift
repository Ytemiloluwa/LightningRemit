//
//  KeyServiceError.swift
//  LightningRemit
//
//  Created by Temiloluwa on 03/07/2024.
//

import Foundation

enum KeyServiceError: Error {
    case encodingError
    case writeError
    case urlError
    case decodingError
    case readError
}
