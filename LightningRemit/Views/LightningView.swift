//
//  LightningView.swift
//  LightningRemit
//
//  Created by Temiloluwa on 09/07/2024.
//

import SwiftUI
import LDKNode

struct LightningView: View {
    
    @StateObject private var viewmodel = InvoiceViewModel()
    @State private var isCopied = false
    @State private var showCheckmark = false
    @State private var showingReceiveViewErrorAlert = false
    @State private var isKeyboardVisible = false
    
    var body: some View {
        
        ZStack {
            
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
            
            VStack {
                
                VStack(spacing: 20) {
                    
                    Image(systemName: "bolt.circle.fill")
                        .resizable()
                        .foregroundColor(.purple)
                        .fontWeight(.bold)
                        .frame(width: 50, height: 50, alignment: .center)
                    Text("Invoice")
                        .font(.largeTitle)
                        .bold()
                    
                }
                .font(.caption)
                .padding(.top, 40.0)
                
                Spacer()
                
                QRCodeView(qrCodeType: .lightning(viewmodel.invoice))
                
                Spacer()
                
                HStack(spacing: 10) {
                    
                    Text("Expiry time : ")
                        .foregroundStyle(.purple)
                    if let expiryDate = viewmodel.expirySecs {
                        CountDownView(expiryDate: expiryDate)
                           
                    }
                }
                .padding(.bottom, 30)
                
                HStack {
                    
                    
                    Text("Invoice".uppercased())
                        .foregroundStyle(.secondary)
                        .fontWeight(.light)
                    Text(viewmodel.invoice)
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .fontDesign(.monospaced)
                    
                    Button {
                        UIPasteboard.general.string = viewmodel.invoice
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
                        .foregroundColor(.purple)
                    }
                    
                }
                .padding()
                .fontDesign(.monospaced)
                .font(.caption)
            }
            .padding()
            .onAppear {
                
                Task {
                    await viewmodel.receiveVariableAmountPayment(
                        description: "Lightning Remit",
                        expirySecs: UInt32(3600)
                    )
                }
            }
            .onReceive(viewmodel.$receiveViewError) { errorMessage in
                if errorMessage != nil {
                    showingReceiveViewErrorAlert = true
                }
            }
            .onReceive(
                NotificationCenter.default.publisher(
                    for: UIResponder.keyboardWillShowNotification
                )
            ) { _ in
                isKeyboardVisible = true
            }
            .onReceive(
                NotificationCenter.default.publisher(
                    for: UIResponder.keyboardWillHideNotification
                )
            ) { _ in
                isKeyboardVisible = false
            }
            .alert(isPresented: $showingReceiveViewErrorAlert) {
                Alert(
                    title: Text(viewmodel.receiveViewError?.title ?? "Unknown"),
                    message: Text(viewmodel.receiveViewError?.detail ?? ""),
                    dismissButton: .default(Text("OK")) {
                        viewmodel.receiveViewError = nil
                    }
                )
            }
        }
    }
}

#Preview {
    LightningView()
}
