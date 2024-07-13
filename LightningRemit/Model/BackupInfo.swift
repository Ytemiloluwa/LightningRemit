//
//  BackupInfo.swift
//  LightningRemit
//
//  Created by Temiloluwa on 03/07/2024.
//

import Foundation

struct BackupInfo: Codable, Equatable {
    var mnemonic: String

    init(mnemonic: String) {
        self.mnemonic = mnemonic
    }

    static func == (lhs: BackupInfo, rhs: BackupInfo) -> Bool {
        return lhs.mnemonic == rhs.mnemonic
    }
}

#if DEBUG
    let mockBackupInfo = BackupInfo(mnemonic: "")
#endif
