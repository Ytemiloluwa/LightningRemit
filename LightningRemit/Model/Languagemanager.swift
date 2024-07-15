//
//  Languagemanager.swift
//  LightningRemit
//
//  Created by Temiloluwa on 13/07/2024.
//

import Foundation

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @Published var currentLanguage: String {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: "currentLanguage")
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: Notification.Name("LanguageChanged"), object: nil)
        }
    }
    
    private init() {
        let defaultLanguage = "en"
        currentLanguage = UserDefaults.standard.string(forKey: "currentLanguage") ?? defaultLanguage
        UserDefaults.standard.set(defaultLanguage, forKey: "currentLanguage")
    }
}
