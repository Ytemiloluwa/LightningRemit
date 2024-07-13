//
//  SendConfirmationView.swift
//  LightningRemit
//
//  Created by Temiloluwa on 12/07/2024.
//

import SwiftUI
struct SendConfirmationView: View {
    
    @ObservedObject var viewModel: SendViewModel
    @State private var isCopied = false
    @State private var showCheckmark = false
    
    var body: some View {
        ZStack {
            Color(uiColor: UIColor.systemBackground)
            
            VStack {
                Spacer()
                
                VStack(spacing: 30) {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .padding(25)
                        .background(Circle().fill(Color.green))
                        .foregroundColor(.white)
                    
                    Text("Sent!")
                        .font(.title)
                    
                    Text("\(viewModel.amount) sats")
                        .font(.largeTitle)
                        .bold()
                    
                    Text(Date.now.formattedDate())
                        .foregroundColor(.secondary)
                
                }
                
                Spacer()
            }
            .padding()
            .onAppear {
                Task {
                    await viewModel.sendPayment(invoice: viewModel.invoice)
                    viewModel.getColor()
                }
            }
        }
        .ignoresSafeArea()
    }
}


#Preview {
    
    SendConfirmationView(
        viewModel: .init(
            amount: "", invoice: "lntb1png62hddq4f4hkuerp0ys9wctvd3jhgnp4qd6tklpk8tzhyyewgewwjdfy0w70zf3hzn8yjvfpdl0gwkuljcxu7pp5vq8933qrhx5h0vvmqjepadv35lcwr5xaxpkcqhjpreanc2zfajjssp5k03yl5vkzefeeewka3cpg0lrs58tf9ncl3wf3yfmcv6yz5783enq9qyysgqcqpcxqrrssql6z7tr6hmt02rgpdt6p0yyzf2s77c3cp9x34xflkpwfplyj39l3427zmfwnyktv36kdzlvca783tl0wppt3kxy0vmctnzdrl7t6vmspgqdwa5"
        )
    )
    
}
