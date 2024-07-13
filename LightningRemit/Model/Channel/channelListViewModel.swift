//
//  channelListViewModel.swift
//  LightningRemit
//
//  Created by Temiloluwa on 12/07/2024.
//

import Foundation
import SwiftUI
import LDKNode

class ChannelsListViewModel: ObservableObject {
    @Published var channels: [ChannelDetails] = []
    @Published var AppColor  = Color.gray
    
    func listChannels() {
        
        self.channels = NodeService.shared.listChannels()
    }
    
    func getColor() {
        let color = NodeService.shared.AppColor
        DispatchQueue.main.async {
            self.AppColor = color
        }
    }
    
    
}
