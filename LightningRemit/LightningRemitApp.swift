//
//  LightningRemitApp.swift
//  LightningRemit
//
//  Created by Temiloluwa on 28/06/2024.
//

import SwiftUI
import LightningDevKit

@main
struct LightningRemitApp: App {
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    @StateObject private var paymentsListViewModel = PaymentsListViewModel()
    @StateObject private var languageManager = LanguageManager.shared

    var body: some Scene {
        WindowGroup {
            if isOnboarding {
                OnboardingView(viewModel: OnboardingViewModel())
//                    .environmentObject(languageManager)
//                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
            } else {
                TabHomeView()
                    .environmentObject(paymentsListViewModel)
                    .environmentObject(languageManager)
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
            }
        }
    }
}

