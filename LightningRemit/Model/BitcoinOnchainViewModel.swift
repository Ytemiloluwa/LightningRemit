//
//  ReceiveViewModel.swift
//  LightningRemit
//
//  Created by Temiloluwa on 06/07/2024.
//

import Foundation
import Combine
import LDKNode

class BitcoinOnchainViewModel: ObservableObject {
    
    @Published var address: String = ""
    @Published var receiveViewError: LightningRemitError?
    let nodeService: NodeService
    private var cancellables = Set<AnyCancellable>()
    
    init(nodeService: NodeService = .shared) {
        self.nodeService = nodeService
        observeAddressChanges()
        fetchSavedAddress()
        
    }
    
    func observeAddressChanges() {
        nodeService.$savedAddress
            .sink { [weak self] newAddress in
                self?.address = newAddress ?? "Error getting address"
            }
            .store(in: &cancellables)
    }
    
    func fetchSavedAddress() {
        if let savedAddress = nodeService.savedAddress {
            self.address = savedAddress
        } else {
            nodeService.generateAndSaveAddress()
        }
    }
    
}
