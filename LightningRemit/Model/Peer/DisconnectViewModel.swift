//
//  DisconnectViewModel.swift
//  LightningRemit
//
//  Created by Temiloluwa on 11/07/2024.
//

import Foundation
import SwiftUI
import LDKNode

class DisconnectViewModel: ObservableObject {
    @Published var disconnectViewError: LightningRemitError?
    @Published var networkColor = Color.gray
    @Published var nodeId: PublicKey
    
    init(nodeId: PublicKey) {
        self.nodeId = nodeId
    }
    
    func disconnect() {
        do {
            try NodeService.shared.disconnect(nodeId: self.nodeId)
            disconnectViewError = nil
        } catch let error as NodeError {
            let errorString = handleNodeError(error)
            DispatchQueue.main.async {
                self.disconnectViewError = .init(title: errorString.title, detail: errorString.detail)
            }
        } catch {
            DispatchQueue.main.async {
                self.disconnectViewError = .init(title: "Unexpected error", detail: error.localizedDescription)
            }
        }
    }
    
    func getColor() {
        let color = NodeService.shared.AppColor
        DispatchQueue.main.async {
            self.networkColor = color
        }
    }
    
}
