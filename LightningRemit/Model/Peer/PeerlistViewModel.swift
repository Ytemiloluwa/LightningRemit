//
//  PeerlistViewModel.swift
//  LightningRemit
//
//  Created by Temiloluwa on 11/07/2024.
//

import Foundation
import SwiftUI
import LDKNode

class PeersListViewModel: ObservableObject {
    @Published var networkColor = Color.gray
    @Published var peers: [PeerDetails] = []
    
    func listPeers() {
        self.peers = NodeService.shared.listPeers()
    }
    
    func getColor() {
        let color = NodeService.shared.AppColor
        DispatchQueue.main.async {
            self.networkColor = color
        }
    }
    
}
