//
//  Languagemanager.swift
//  LightningRemit
//
//  Created by Temiloluwa on 13/07/2024.
//

import Foundation

class LanguageManager {
    static let shared = LanguageManager()
    private init() {}

    var currentLanguage: String {
        get {
            return UserDefaults.standard.string(forKey: "appLanguage") ?? Locale.current.languageCode ?? "en"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "appLanguage")
            setLanguage(newValue)
            NotificationCenter.default.post(name: Notification.Name("LanguageChanged"), object: nil)
        }
    }

    private func setLanguage(_ language: String) {
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            print("Error: Language bundle not found for language: \(language)")
            return
        }
        objc_setAssociatedObject(Bundle.main, &bundleKey, bundle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        object_setClass(Bundle.main, PrivateBundle.self)
    }
}

private var bundleKey: UInt8 = 0

private class PrivateBundle: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        let bundle = objc_getAssociatedObject(self, &bundleKey) as? Bundle ?? .main
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}
