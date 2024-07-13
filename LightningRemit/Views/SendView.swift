//
//  SendView.swift
//  LightningRemit
//
//  Created by Temiloluwa on 06/07/2024.
//

import SwiftUI
import BitcoinUI
import CodeScanner

struct SendView: View {
    @ObservedObject var viewModel: SendViewModel
    @EnvironmentObject var paymentListViewModel: PaymentsListViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingScanner = false
    @State private var address: String = ""
    @State var numpadAmount = "0"
    @State var parseError: LightningRemitError?
    @State var payment: PaymentType = .isNone
    @State private var showingAmountViewErrorAlert = false
    @State private var shouldNavigate = false
    let pasteboard = UIPasteboard.general
    var spendableBalance: UInt64
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    VStack(spacing: 25) {
                        HStack {
                            HStack {
                                Text("To")
                                TextField("Enter a bitcoin address or invoice", text: $address)
                                Button(action: {
                                    isShowingScanner = true
                                }, label: {
                                    Image(systemName: "qrcode.viewfinder")
                                })
                            }
                            .padding()
                            .foregroundStyle(.purple)
                        }
                        Divider()
                            .frame(height: 2)
                            .overlay(.purple)
                        Button {
                            if pasteboard.hasStrings, let string = pasteboard.string {
                                if address.starts(with: "lno") {
                                    address = address
                                    numpadAmount = "0"
                                    payment = .isLightning
                                } else {
                                    let (extractedAddress, extractedAmount, extractedPayment) = string.extractPaymentInfo(spendableBalance: spendableBalance)
                                    address = extractedAddress
                                    numpadAmount = extractedAmount
                                    payment = extractedPayment
                                    if extractedPayment == .isNone {
                                        self.parseError = .init(title: "Scan Error", detail: "Unsupported paste format")
                                    }
                                }
                            } else {
                                self.parseError = .init(title: "Pasteboard Error", detail: "No address found in pasteboard")
                            }
                        } label: {
                            Text("PASTE FROM CLIPBOARD")
                                .bold()
                                .frame(width: 350, height: 50)
                                .foregroundColor(.white)
                                .background(.purple)
                        }
                    }
                    .sheet(isPresented: $isShowingScanner) {
                        CodeScannerView(
                            codeTypes: [.qr],
                            simulatedData: "lntb1png62hddq4f4hkuerp0ys9wctvd3jhgnp4qd6tklpk8tzhyyewgewwjdfy0w70zf3hzn8yjvfpdl0gwkuljcxu7pp5vq8933qrhx5h0vvmqjepadv35lcwr5xaxpkcqhjpreanc2zfajjssp5k03yl5vkzefeeewka3cpg0lrs58tf9ncl3wf3yfmcv6yz5783enq9qyysgqcqpcxqrrssql6z7tr6hmt02rgpdt6p0yyzf2s77c3cp9x34xflkpwfplyj39l3427zmfwnyktv36kdzlvca783tl0wppt3kxy0vmctnzdrl7t6vmspgqdwa5",
                            completion: handleScan
                        )
                    }
                    Spacer()
                    Text("\(numpadAmount.formattedAmountZero()) sats")
                        .textStyle(BitcoinTitle1())
                    GeometryReader { geometry in
                        let buttonSize = geometry.size.width / 4
                        VStack(spacing: buttonSize / 10) {
                            numpadRow(["1", "2", "3"], buttonSize: buttonSize)
                            numpadRow(["4", "5", "6"], buttonSize: buttonSize)
                            numpadRow(["7", "8", "9"], buttonSize: buttonSize)
                            numpadRow([" ", "0", "<"], buttonSize: buttonSize)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(height: 300)

                    NavigationLink(
                        destination: SendConfirmationView(
                            viewModel: .init(amount: numpadAmount.formattedAmount(), invoice: viewModel.invoice)
                        ),
                        isActive: $shouldNavigate
                    ) {
                        EmptyView()
                    }

                    Button {
                        Task {
                            switch payment {
                            case .isLightning:
                                await viewModel.handleLightningPayment(address: address, numpadAmount: numpadAmount)
                            case .isBitcoin:
                                await viewModel.handleBitcoinPayment(address: address, numpadAmount: numpadAmount)
                            case .isLightningURL:
                                viewModel.amountConfirmationViewError = .init(title: "LNURL Error", detail: "LNURL not supported yet.")
                            case .isNone:
                                viewModel.amountConfirmationViewError = .init(title: "Unexpected Error", detail: "Not any payment type.")
                            }
                        }
                        if viewModel.amountConfirmationViewError == nil {
                            let amountMsat = Int(numpadAmount) ?? 0 * 1000
                            paymentListViewModel.addPayment(amountMsat: amountMsat, direction: .outbound, status: .pending)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                
                                self.presentationMode.wrappedValue.dismiss()
                            }
                            shouldNavigate = true
                        } else {
                            showingAmountViewErrorAlert = true
                        }
                    } label: {
                        Text("Send")
                            .bold()
                            .foregroundColor(Color(uiColor: UIColor.systemBackground))
                            .frame(maxWidth: .infinity)
                            .padding(.all, 8)
                    }
                    .buttonBorderShape(.capsule)
                    .buttonStyle(.borderedProminent)
                    .tint(Color.purple)
                    .frame(width: 300, height: 25)
                    .padding()
                    .padding(.bottom, 20.0)
                }
                .padding()
                .onAppear {
                    viewModel.getColor()
                }
                .alert(isPresented: $showingAmountViewErrorAlert) {
                    Alert(
                        title: Text(viewModel.amountConfirmationViewError?.title ?? "Unknown"),
                        message: Text(viewModel.amountConfirmationViewError?.detail ?? ""),
                        dismissButton: .default(Text("OK")) {
                            viewModel.amountConfirmationViewError = nil
                        }
                    )
                }
            }
        }
    }
}
extension SendView {
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let scanResult):
            let scanString = scanResult.string
            let (extractedAddress, extractedAmount, extractedPayment) =
            scanString.extractPaymentInfo(spendableBalance: spendableBalance)
            address = extractedAddress
            numpadAmount = extractedAmount
            payment = extractedPayment
            
            if extractedPayment == .isNone {
                self.parseError = .init(title: "Scan Error", detail: "Unsupported scan format")
            }
            
        case .failure(let scanError):
            self.parseError = .init(title: "Scan Error", detail: scanError.localizedDescription)
        }
    }
}

extension SendView {
    
    func numpadRow(_ characters: [String], buttonSize: CGFloat) -> some View {
        HStack(spacing: buttonSize / 2) {
            ForEach(characters, id: \.self) { character in
                NumpadButton(numpadAmount: $numpadAmount, character: character)
                    .frame(width: buttonSize, height: buttonSize / 1.5)
            }
        }
    }
}

#Preview {
    SendView(viewModel: .init(amount: "", invoice: ""), spendableBalance: (21000))
}
