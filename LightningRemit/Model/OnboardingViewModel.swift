//
//  OnboardingModel.swift
//  LightningRemit
//
//  Created by Temiloluwa on 28/06/2024.
//

import Foundation
import SwiftUI
import LDKNode

class OnboardingViewModel: ObservableObject {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    let nodeService: NodeService

    init(nodeService: NodeService = .shared) {
        self.nodeService = nodeService
    }

    func createWallet() {
        do {
            let newMnemonic = generateEntropyMnemonic()
            let backupInfo = BackupInfo(mnemonic: newMnemonic)
            try nodeService.saveBackupInfo(backupInfo)
            try nodeService.start()
            isOnboarding = false
        } catch {
            print("createWallet - Error: \(error.localizedDescription)")
        }
    }

    func restoreWallet() {
        do {
            let backupInfo = try nodeService.getBackupInfo()
            if !backupInfo.mnemonic.isEmpty {
                try nodeService.start()
                isOnboarding = false
            }
        } catch {
            print("restoreWallet - Error: \(error.localizedDescription)")
        }
    }
}
