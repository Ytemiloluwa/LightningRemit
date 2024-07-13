//
//  TabHomeView.swift
//  LightningRemit
//
//  Created by Temiloluwa on 06/07/2024.
//

import SwiftUI

struct TabHomeView: View {
    var body: some View {

        ZStack {
            Color(uiColor: UIColor.systemBackground)

            TabView {
                WalletView(viewModel: WalletViewModel.init())
                    .tabItem {
                        Image(systemName: "bolt")
                    }
                ReceiveView()
                    .tabItem {
                        Image(systemName: "arrow.down")
                    }
                SendView(viewModel: SendViewModel(amount: "", invoice: ""), spendableBalance: 21000)
                    .tabItem {
                        Image(systemName: "arrow.up")
                    }
                
                SettingsView(viewModel: .init())
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                    }
            }
            .tint(.primary)

        }

    }
}

#Preview {
    TabHomeView()
}
