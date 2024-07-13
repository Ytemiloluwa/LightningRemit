//
//  WalletViewModel.swift
//  LightningRemit
//
//  Created by Temiloluwa on 06/07/2024.
//
import Foundation
import LDKNode
import SwiftUI
import Combine

class WalletViewModel: ObservableObject {
    
    // Testing
    
    var spendablebalancesats = ""
    @Published var isNodeRunning: Bool = true
    @Published var errorMessage: String?


    @Published var address: String = ""
    @Published var selectedCurrency: String = "$"
    @Published var receiveViewError: LightningRemitError?
    @Published var bitcoinViewError: LightningRemitError?
    @Published var status: NodeStatus?
    @Published var isStatusFinished: Bool = false
    @Published var nodeID: String = ""
    @Published var listeningAddress: String = ""
    @Published var spendableBalance: UInt64 = 0
    @Published var totalBalance: UInt64 = 0
    @Published var totalLightningBalance: UInt64 = 0
    @Published var lightningBalances: [LightningBalance] = []
    @Published var isSpendableBalanceFinished: Bool = false
    @Published var isTotalBalanceFinished: Bool = false
    @Published var isTotalLightningBalanceFinished: Bool = false
    @Published var isPriceFinished: Bool = false
    
    @Published var payments: [PaymentDetails] = []
    @Published var onchainPayments: [OnchainPaymentDetails] = []
    
    var conversionRates: [String: Double] = [:]
    
    var price: Double = 0.00
    var time: Int?
    
    let nodeService: NodeService
    private var cancellables = Set<AnyCancellable>()
    
    init(nodeService: NodeService = .shared) {
        self.nodeService = nodeService
        getAddress()
        fetchBalances()
        startNode()
    }
    
    func getSpendableOnchainBalanceSats() async {
     
        do {
            
            let balance = try await NodeService.shared.spendableOnchainBalanceSats()
            print("onchain funds: \(balance)")
            DispatchQueue.main.async {
                
                self.spendablebalancesats = String(balance)
            }
        }catch {
            
            print("Error getSpendable: \(error.localizedDescription)")
            
        }
        
    }
    
    func startNode(){
           do {
               try nodeService.start()
               DispatchQueue.main.async {
                   self.isNodeRunning = true
               }
           } catch {
               errorMessage = "Failed to start node: \(error.localizedDescription)"
           }
       }
    
    func getNewFundAddress() async {
        
        do {
            let address = try await NodeService.shared.newfundingAddress()
            print("Onchainaddrerss: \(address)")
            DispatchQueue.main.async {
                
                self.address = address
            }
        }catch {
            
            print("error getting Onchainaddrerss: \(error.localizedDescription)")
            
        }
    }
    
    func listPeers() {
        
        let peers = NodeService.shared.listPeers()
        print("\(peers)")
    }
    
    func connect() async {
        
        do {
            
            try await NodeService.shared.connect(nodeID: "02274ea2810a8bd5b31e123100570760f41aa685c78c4772feb88b003651d3a908", address: "http://ldk-node.tnull.de:3002", persist: true)
            
        }catch {
            
            print("Error connect: \(error.localizedDescription)")
        }
    }
    
    func getNodeID() {
        let nodeID = NodeService.shared.nodeId()
        self.nodeID = nodeID
        print(nodeID)
    }
    
    func getsocketAddress() {
        
        let socAddress = NodeService.shared.listeningAddress()
        self.listeningAddress = socAddress ?? ""
        
        print(socAddress ?? "")
    }
    
    var satsPrice: String {
        let usdValue = Double(totalBalance).valueInUSD(price: price)
        return usdValue
    }
    var totalUSDValue: String {
        let totalUSD = Double(totalBalance).valueInUSD(price: price)
        return totalUSD
    }
    
    func listPayments() {
        self.payments = NodeService.shared.listPayments()
    }
    
    func getAddress() {
        
        if let savedAddress = nodeService.savedAddress {
            self.address = savedAddress
        } else {
            nodeService.generateAndSaveAddress()
        }
    }
    
    func fetchBalances() {
        
        Task {
            let totalBalance = await nodeService.totalOnchainBalanceSats()
            DispatchQueue.main.async {
                self.totalBalance = totalBalance
                self.isTotalBalanceFinished = true
            }
            
            let spendableBalance = try await nodeService.spendableOnchainBalanceSats()
            DispatchQueue.main.async {
                self.spendableBalance = spendableBalance
                self.isSpendableBalanceFinished = true
            }
            
            let lightningBalance = await nodeService.totalLightningBalanceSats()
            DispatchQueue.main.async {
                self.totalLightningBalance = lightningBalance
                self.isTotalLightningBalanceFinished = true
            }
        }
    }
    
    
    // balance View Model
    
    func getStatus() async {
        let status = NodeService.shared.status()
        DispatchQueue.main.async {
            self.status = status
            self.isStatusFinished = true
        }
    }
    
    func getTotalOnchainBalanceSats() async {
        let balance = await NodeService.shared.totalOnchainBalanceSats()
        
        DispatchQueue.main.async {
            print("Total Onchain Balance: \(balance)")
            self.totalBalance = balance
            self.isTotalBalanceFinished = true
        }
    }
    
//    func getSpendableOnchainBalanceSats() async {
//        let balance = await NodeService.shared.spendableOnchainBalanceSats()
//        DispatchQueue.main.async {
//            print("Spendable Onchain Balance: \(balance)")
//            self.spendableBalance = balance
//            self.isSpendableBalanceFinished = true
//        }
//    }
    
    func getTotalLightningBalanceSats() async {
        let balance = await NodeService.shared.totalLightningBalanceSats()
        DispatchQueue.main.async {
            self.totalLightningBalance = balance
            self.isTotalLightningBalanceFinished = true
        }
    }
    
    func fetchOnchainPayments() {
        if let url = Bundle.main.url(forResource: "transactions", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                print("JSON file loaded successfully.")
                
                let decoder = JSONDecoder()
                let transactions = try decoder.decode([OnchainPaymentDetails].self, from: data)
                print("JSON data decoded successfully: \(transactions)")
                
                DispatchQueue.main.async {
                    self.onchainPayments = transactions
                    print("Onchain payments updated in view model.")
                }
            } catch {
                print("Error loading JSON data: \(error.localizedDescription)")
            }
        } else {
            print("transactions.json file not found")
        }
    }
}


struct OnchainPaymentDetails: Codable, Identifiable {
    let txid: String
    let status: Status
    let block_height: Int?
    let time: Int
    let value: Int
    let id = UUID()
    
    struct Status: Codable {
        let confirmed: Bool
        let block_height: Int?
        let block_time: Int
    }
    
    enum CodingKeys: String, CodingKey {
        case txid
        case status
        case block_height
        case time = "block_time"
        case value = "value" // This may need to be updated based on your JSON structure
    }
}
