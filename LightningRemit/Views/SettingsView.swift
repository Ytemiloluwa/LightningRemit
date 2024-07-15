//
//  SettingsView.swift
//  LightningRemit
//
//  Created by Temiloluwa on 11/07/2024.
//
import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var viewModel: WalletViewModel
    @StateObject private var channelAddViewModel = ChannelAddViewModel()
    @StateObject private var disconnect = DisconnectViewModel(nodeId: "02274ea2810a8bd5b31e123100570760f41aa685c78c4772feb88b003651d3a908")
    @State private var isNotificationsEnabled = true
    @State private var isLocationEnabled = true
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                nodeStatusView
                
                Image(systemName: "person.crop.circle")
                    .font(.title)
                    .foregroundColor(.purple)
                
                HStack {
                    Text("ID:")
                        .bold()
                        .font(.title3)
                    Text(viewModel.nodeID)
                        .truncationMode(.middle)
                        .lineLimit(1)
                }
                
                settingsListView
            }
            .padding()
            .onAppear {
                viewModel.getNodeID()
            }
            .task {
                viewModel.startNode()
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
    
    private var nodeStatusView: some View {
        Group {
            if viewModel.isNodeRunning {
                Text("Node is running")
                    .foregroundColor(.green)
            } else {
                Text("Node is not running")
                    .foregroundColor(.red)
            }
        }
    }
    
    private var settingsListView: some View {
        List {
            Section(header: Text("Peers")) {
                NavigationLink(destination: DisconnectView(viewModel:  disconnect)) {
                    Text("List Peers")
                        .foregroundColor(.purple)
                        .font(.title3)
                }
            }
            
            Section(header: Text("Channel")) {
                
                NavigationLink(destination: ChannelDetailView()) {
                    Text("List Channel")
                        .foregroundColor(.purple)
                        .font(.title3)
                }
                
                
                NavigationLink(destination: ChannelAddView(viewModel: channelAddViewModel)) {
                    Text("Open a channel")
                        .foregroundColor(.purple)
                        .font(.title3)
                }
            }
            
            Section(header: Text("General")) {
                Toggle(isOn: $isDarkMode.animation(), label: {
                    Text("Dark Mode")
                })
                .onChange(of: isDarkMode) { value in
                    
                }.foregroundColor(.purple)
                
                NavigationLink(destination: AboutView()) {
                    Text("About")
                       // .foregroundColor(colorScheme == .dark ? .green : .primary)
                }.foregroundColor(.purple)
            }
        }
        .listStyle(GroupedListStyle())
    }
}

struct AccountSettingsView: View {
    var body: some View {
        Text("Account Settings")
            .navigationBarTitle("Account Settings", displayMode: .inline)
    }
}

struct AboutView: View {
    var body: some View {
        
        VStack(spacing: 30){
            
            VStack(spacing: 20){
                
                Text("Lightning Remit")
                
                Text("v0.1.0-alpha")
                
            }
            .font(.title)
            .navigationBarTitle("About", displayMode: .inline)
            
            Text("Built for Devpost 2024 Bitcoin Hackathon.")
                .foregroundStyle(.secondary)
            
        }
    }
}

#Preview {
    SettingsView(viewModel: .init())
}
