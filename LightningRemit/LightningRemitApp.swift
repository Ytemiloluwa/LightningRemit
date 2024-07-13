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

    init() {
        // Set the initial language
        LanguageManager.shared.currentLanguage = LanguageManager.shared.currentLanguage
    }

    var body: some Scene {
        WindowGroup {
            if isOnboarding {
                OnboardingView(viewModel: OnboardingViewModel())
            } else {
                TabHomeView()
                    .environmentObject(paymentsListViewModel)
            }
        }
    }
}
