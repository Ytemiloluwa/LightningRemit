//
//  DisconnectView.swift
//  LightningRemit
//
//  Created by Temiloluwa on 11/07/2024.
//

import SwiftUI

struct DisconnectView: View {
    @ObservedObject var viewModel: DisconnectViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDisconnectViewErrorAlert = false
    
    var body: some View {
        
        ZStack {
            Color(uiColor: UIColor.systemBackground)
            
            VStack {
                
                HStack {
                    Text("Node ID")
                    Text(viewModel.nodeId.description)
                        .truncationMode(.middle)
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                    
                }
                .font(.system(.caption, design: .monospaced))
                .padding()
                
                Button {
                    viewModel.disconnect()
                    if showingDisconnectViewErrorAlert == false {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    if showingDisconnectViewErrorAlert == true {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    Text("Terminate Peer")
                        .bold()
                        .foregroundColor(Color(uiColor: UIColor.systemBackground))
                        .frame(maxWidth: .infinity)
                        .padding(.all, 8)
                }
                .buttonBorderShape(.capsule)
                .buttonStyle(.borderedProminent)
                .padding()

            }
            .padding()
            .alert(isPresented: $showingDisconnectViewErrorAlert) {
                Alert(
                    title: Text(viewModel.disconnectViewError?.title ?? "Unknown"),
                    message: Text(viewModel.disconnectViewError?.detail ?? ""),
                    dismissButton: .default(Text("OK")) {
                        viewModel.disconnectViewError = nil
                    }
                )
            }
            .onReceive(viewModel.$disconnectViewError) { errorMessage in
                if errorMessage != nil {
                    showingDisconnectViewErrorAlert = true
                }
            }
            .onAppear {
                viewModel.getColor()
            }
            
        }
        .ignoresSafeArea()
        
    }
    
}


#Preview {
    DisconnectView(viewModel: DisconnectViewModel.init(nodeId: "02274ea2810a8bd5b31e123100570760f41aa685c78c4772feb88b003651d3a908"))
}
