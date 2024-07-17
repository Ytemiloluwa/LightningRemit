//
//  SendConfirmationView.swift
//  LightningRemit
//
//  Created by Temiloluwa on 12/07/2024.
//

import SwiftUI
struct SendConfirmationView: View {
    
    @ObservedObject var viewModel: SendViewModel
    @State private var isAnimating = true
    
    var body: some View {
        ZStack {
            Color(uiColor: UIColor.systemBackground).ignoresSafeArea()
            
            if isAnimating {
                VStack {
                    Spacer()
                    ThunderstormAnimationView()
                    Text("Payment is on its way")
                        .font(.title)
                        .foregroundColor(.purple)
                        .padding(.top, 20)
                    Spacer()
                }
            } else {
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
                        
                        Text(Date.now.formatted(date: .abbreviated, time: .complete))
                            .foregroundColor(.secondary)
                    
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
        .onAppear {
            Task {
                await viewModel.sendPayment(invoice: viewModel.invoice)
                //viewModel.getColor()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isAnimating = false
                    }
                }
            }
        }
    }
}

struct ThunderstormAnimationView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            Color.clear
                .edgesIgnoringSafeArea(.all)
            
            // Background clouds
            ForEach(0..<6) { index in
                CloudView()
                    .offset(x: animate ? -600 : 600)
                    .opacity(0.3)
                    .animation(Animation.easeInOut(duration: Double.random(in: 1...8)).repeatForever(autoreverses: false).delay(Double.random(in: 0...1)), value: animate)
            }
            
            // Lightning strike
            LightningStrikeView()
                .opacity(animate ? 1 : 0)
                .animation(Animation.easeInOut(duration: 0.1).repeatForever(autoreverses: true).delay(Double.random(in: 0.5...2)), value: animate)
        }
        .onAppear {
            animate = true
        }
    }
}

struct CloudView: View {
    var body: some View {
        Image(systemName: "bolt.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .foregroundColor(.purple)
            .blur(radius: 5)
    }
}

struct LightningStrikeView: View {
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.purple)
                .frame(width: 2.5, height: 100)
                .offset(x: -30, y: -50)
            Rectangle()
                .fill(Color.purple)
                .frame(width: 2.5, height: 150)
                .offset(x: 30, y: -25)
            Rectangle()
                .fill(Color.purple)
                .frame(width: 2.5, height: 200)
                .offset(x: -10, y: 25)
        }
    }
}


#Preview {
    
    SendConfirmationView(
        viewModel: .init(
            amount: "", invoice: "lntb1png62hddq4f4hkuerp0ys9wctvd3jhgnp4qd6tklpk8tzhyyewgewwjdfy0w70zf3hzn8yjvfpdl0gwkuljcxu7pp5vq8933qrhx5h0vvmqjepadv35lcwr5xaxpkcqhjpreanc2zfajjssp5k03yl5vkzefeeewka3cpg0lrs58tf9ncl3wf3yfmcv6yz5783enq9qyysgqcqpcxqrrssql6z7tr6hmt02rgpdt6p0yyzf2s77c3cp9x34xflkpwfplyj39l3427zmfwnyktv36kdzlvca783tl0wppt3kxy0vmctnzdrl7t6vmspgqdwa5"
        )
    )
    
}
