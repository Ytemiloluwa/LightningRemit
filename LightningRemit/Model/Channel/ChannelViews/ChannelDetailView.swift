//
//  ChannelDetailView.swift
//  LightningRemit
//
//  Created by Temiloluwa on 12/07/2024.
//

import SwiftUI
import LDKNode

struct ChannelDetailView: View {
    
    var body: some View {
        VStack {
            Text("Channel Details")
                .font(.largeTitle)
                .bold()
                .padding(.top)
            VStack(alignment: .leading, spacing: 15) {
                
                HStack {
                    
                    Text("PubKey :")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("02465ed5be53d04fde66c9418ff14a5f2267723810176c9212b722e542dc1afb1b")
                        .truncationMode(.middle)
                        .lineLimit(1)
                
                }
                HStack {
                    Text("IP Address :")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("45.79.52.207:9735")
                }
                
                HStack {
                    Text("Amount: ")
                        .font(.headline)
                    .foregroundColor(.secondary)
                    
                    Text("10000")
                    
                }
            
            }
            .padding()
            .font(.title3)
            Button {
                
            } label: {
                Text("Disconnect Channel")
                    .bold()
                    .foregroundColor(Color(uiColor: UIColor.systemBackground))
                    .frame(maxWidth: .infinity)
                    .padding(.all, 8)
            }
            .buttonBorderShape(.capsule)
            .buttonStyle(.borderedProminent)
            .tint(Color.purple)
            .padding(.horizontal)
            .padding(.bottom, 80.0)

        }
        .navigationTitle("Channel Details")
        .navigationBarTitleDisplayMode(.inline)
 
    }
}

#Preview {
    
    ChannelDetailView()
}
