//
//  DualView.swift
//  LightningRemit
//
//  Created by Temiloluwa on 08/07/2024.
//

import SwiftUI

struct ReceiveView: View {
    
    @State private var selected: Int = 0
    @State private var ReceivePayments: [String] = ["Bitcoin", "Lightning"]
    var body: some View {
        
        VStack {
            
            Picker(selection: $selected, label: Text("")) {
                
                ForEach(0..<ReceivePayments.count, id: \.self) {
                    
                    Text(ReceivePayments[$0]).tag($0)
                        .bold()
                }
            }.pickerStyle(SegmentedPickerStyle())
                .padding()
            
            // Conditional Views
            if selected == 0 {
                BitcoinView()
            } else {
                LightningView()
            }
        }
    }
}

#Preview {
    ReceiveView()
}
