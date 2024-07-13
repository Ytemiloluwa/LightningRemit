//
//  ChannelDetailViewModel.swift
//  LightningRemit
//
//  Created by Temiloluwa on 12/07/2024.
//

import Foundation
import SwiftUI
import LDKNode

class ChannelDetailViewModel: ObservableObject {
    @Published var channel: ChannelDetails
    @Published var channelDetailViewError: LightningRemitError?
    @Published var AppColor = Color.gray
    
    init(channel: ChannelDetails) {
        self.channel = channel
    }
    
    func close() {
        do {
            try NodeService.shared.closeChannel(
                userChannelId: self.channel.channelId,
                counterpartyNodeId: self.channel.counterpartyNodeId
            )
            channelDetailViewError = nil
        } catch let error as NodeError {
            let errorString = handleNodeError(error)
            DispatchQueue.main.async {
                self.channelDetailViewError = .init(title: errorString.title, detail: errorString.detail)
            }
        } catch {
            DispatchQueue.main.async {
                self.channelDetailViewError = .init(title: "Unexpected error", detail: error.localizedDescription)
            }
        }
    }
    
    func getColor() {
        let color = NodeService.shared.AppColor
        DispatchQueue.main.async {
            self.AppColor = color
        }
    }
    
}

