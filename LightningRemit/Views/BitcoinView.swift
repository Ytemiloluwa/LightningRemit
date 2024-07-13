//
//  RecieveView.swift
//  LightningRemit
//
//  Created by Temiloluwa on 06/07/2024.
//

import SwiftUI
import BitcoinUI

struct BitcoinView: View {
    
    @StateObject private var viewmodel = WalletViewModel()
    @State private var isCopied = false
    @State private var showCheckmark = false
    var body: some View {
        
        ZStack {
            
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
            
            VStack {
                
                VStack(spacing: 20) {
                    
                    Image(systemName: "bitcoinsign.circle.fill")
                        .resizable()
                        .foregroundColor(.orange)
                        .fontWeight(.bold)
                        .frame(width: 50, height: 50, alignment: .center)
                        .rotationEffect(.degrees(30))
                    Text("Onchain Receive Address")
                        .font(.title2)
                        .bold()
                    
                }
                .font(.caption)
                .padding(.top, 40.0)
                
                Spacer()
                
                if viewmodel.address != "" {
                    QRCodeView(qrCodeType: .bitcoin(viewmodel.address))
                        .animation(.default, value: viewmodel.address)
                    
                    Spacer()
                    
                    HStack {
                        
                        
                        Text("Address".uppercased())
                            .foregroundStyle(.secondary)
                            .fontWeight(.light)
                        Text(viewmodel.address)
                            .lineLimit(1)
                            .truncationMode(.middle)
                            .fontDesign(.monospaced)
                        
                        Button {
                            UIPasteboard.general.string = viewmodel.address
                            isCopied = true
                            showCheckmark = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                isCopied = false
                                showCheckmark = false
                            }
                        } label: {
                            HStack {
                                withAnimation {
                                    Image(systemName: showCheckmark ? "checkmark" : "doc.on.doc")
                                }
                            }
                            .fontWeight(.semibold)
                            .foregroundColor(.orange)
                        }
                        
                    }
                    .padding()
                    .fontDesign(.monospaced)
                    .font(.caption)
                }
            }
            .padding()
        }
    }
}

#Preview {
    BitcoinView()
}
