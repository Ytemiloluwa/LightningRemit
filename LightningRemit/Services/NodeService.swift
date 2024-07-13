//
//  NodeService.swift
//  LightningRemit
//
//  Created by Temiloluwa on 03/07/2024.
//

import Foundation
import LDKNode
import SwiftUI
import os

class NodeService: ObservableObject {
    static let shared = NodeService()
    private let ldkNode: Node
    public var keyService: KeyClient
    var AppColor = Color.purple
    var network: Network
    
    @Published var onchainPayments: [Transaction] = []
    
    @Published var savedAddress: String? {
        didSet {
            if let address = savedAddress {
                UserDefaults.standard.set(address, forKey: "savedAddress")
            }
        }
    }
    
    init(keyService: KeyClient = .live) {
        self.keyService = keyService
        
        let storedNetworkString = try! keyService.getNetwork() ?? Network.testnet.description
        let storedEsploraURL = try! keyService.getEsploraURL() ?? Constants.Config.EsploraServerURLNetwork.Testnet.mempoolspace
        
        self.network = Network(stringValue: storedNetworkString) ?? .testnet
        
        var config = defaultConfig()
        config.storageDirPath = FileManager.default.getDocumentsDirectoryPath()
        config.logDirPath = FileManager.default.getDocumentsDirectoryPath()
        config.network = self.network
        config.trustedPeers0conf = [Constants.Config.LiquiditySourceLsps2.Signet.mutiny.nodeId]
        config.logLevel = .trace
        
        let nodeBuilder = Builder.fromConfig(config: config)
        nodeBuilder.setEsploraServer(esploraServerUrl: storedEsploraURL)
        
        switch self.network {
        case .bitcoin:
            nodeBuilder.setGossipSourceRgs(rgsServerUrl: Constants.Config.RGSServerURLNetwork.bitcoin)
            self.AppColor = Constants.BitcoinNetworkColor.bitcoin.color
        case .testnet:
            nodeBuilder.setGossipSourceRgs(rgsServerUrl: Constants.Config.RGSServerURLNetwork.testnet)
            self.AppColor = Constants.BitcoinNetworkColor.testnet.color
        case .signet:
            nodeBuilder.setLiquiditySourceLsps2(address: Constants.Config.LiquiditySourceLsps2.Signet.mutiny.address, nodeId: Constants.Config.LiquiditySourceLsps2.Signet.mutiny.nodeId, token: Constants.Config.LiquiditySourceLsps2.Signet.mutiny.token)
            self.AppColor = Constants.BitcoinNetworkColor.signet.color
        case .regtest:
            self.AppColor = Constants.BitcoinNetworkColor.regtest.color
        }
        
        let mnemonic: String
        do {
            let backupInfo = try keyService.getBackupInfo()
            if backupInfo.mnemonic.isEmpty {
                let newMnemonic = generateEntropyMnemonic()
                let backupInfo = BackupInfo(mnemonic: newMnemonic)
                try? keyService.saveBackupInfo(backupInfo)
                mnemonic = newMnemonic
            } else {
                mnemonic = backupInfo.mnemonic
            }
        } catch {
            let newMnemonic = generateEntropyMnemonic()
            let backupInfo = BackupInfo(mnemonic: newMnemonic)
            try? keyService.saveBackupInfo(backupInfo)
            mnemonic = newMnemonic
        }
        nodeBuilder.setEntropyBip39Mnemonic(mnemonic: mnemonic, passphrase: nil)
        
        
        self.ldkNode = try! nodeBuilder.build()
        
        
        // Load the saved address from UserDefaults
        self.savedAddress = UserDefaults.standard.string(forKey: "savedAddress")
        
        
    }
    
    func listPeers() -> [PeerDetails] {
        
        let peers = ldkNode.listPeers()
        
        return peers
        
    }
    
    func connect(nodeID: PublicKey, address: String, persist: Bool) async throws {
        
        do {
            
            try ldkNode.connect(nodeId: nodeID, address: address, persist: persist)
            
        }
        
        catch {
            
            print("Error connecting to peer: \(error)")
        }
    }
    
    func nodeId() -> String {
        let nodeId = ldkNode.nodeId()
        return nodeId
    }
    
    func listeningAddress() -> SocketAddress? {
        guard let socAddresses = ldkNode.listeningAddresses(), !socAddresses.isEmpty else {
            return nil
        }
        return socAddresses.first
    }
    
    func stop() throws {
        try ldkNode.stop()
    }
    
    func start() throws {
        try ldkNode.start()
    }
    
    func getBackupInfo() throws -> BackupInfo {
        return try keyService.getBackupInfo()
    }
    
    func saveBackupInfo(_ backupInfo: BackupInfo) throws {
        try keyService.saveBackupInfo(backupInfo)
    }
    
    func newAddress() throws -> String {
        return try ldkNode.onchainPayment().newAddress()
    }
    
    func generateAndSaveAddress() {
        do {
            let newAddress = try ldkNode.onchainPayment().newAddress()
            self.savedAddress = newAddress
        } catch {
            print("Failed to generate new address: \(error.localizedDescription)")
        }
    }
    
    func listPayments() -> [PaymentDetails] {
        let payments = ldkNode.listPayments()
        return payments
    }
    func sendToAddress(address: Address, amountMsat: UInt64) async throws -> Txid {
        let txId = try ldkNode.onchainPayment().sendToAddress(
            address: address,
            amountMsat: amountMsat
        )
        return txId
    }
    
    // Sending to BOLT 12
    func send(bolt12Invoice: Bolt12Invoice) async throws -> PaymentId {
        let payerNote = "BOLT 12 payer note"
        let paymentId = try ldkNode.bolt12Payment().send(offer: bolt12Invoice, payerNote: payerNote)
        return paymentId
    }
    
    // Sending to BOLT 11
    func send(bolt11Invoice: Bolt11Invoice) async throws -> PaymentHash {
        let paymentHash = try ldkNode.bolt11Payment().send(invoice: bolt11Invoice)
        return paymentHash
    }
    
    // Send using amount for Bolt 11
    
    func sendUsingAmount(bolt11Invoice: Bolt11Invoice, amountMsat: UInt64) async throws
    -> PaymentHash
    {
        let paymentHash = try ldkNode.bolt11Payment().sendUsingAmount(
            invoice: bolt11Invoice,
            amountMsat: amountMsat
        )
        return paymentHash
    }
    
    // Send using amount for Bolt 12
    
    func sendUsingAmount(bolt12Invoice: Bolt12Invoice, amountMsat: UInt64) async throws
    -> PaymentId
    {
        let payerNote = "BOLT 12 payer note"
        let paymentId = try ldkNode.bolt12Payment().sendUsingAmount(
            offer: bolt12Invoice,
            payerNote: payerNote,
            amountMsat: amountMsat
        )
        return paymentId
    }
    
    func receive(amountMsat: UInt64, description: String, expirySecs: UInt32) async throws
    -> Bolt11Invoice
    {
        let invoice = try ldkNode.bolt11Payment().receive(
            amountMsat: amountMsat,
            description: description,
            expirySecs: expirySecs
        )
        return invoice
    }
    
    func receiveVariableAmount(description: String, expirySecs: UInt32) async throws
    -> Bolt11Invoice
    {
        let invoice = try ldkNode.bolt11Payment().receiveVariableAmount(
            description: description,
            expirySecs: expirySecs
        )
        return invoice
    }
    
    func status() -> NodeStatus {
        let status = ldkNode.status()
        return status
    }
    
    func totalOnchainBalanceSats() async -> UInt64 {
        print("Fetching total onchain balance...")
        let balance = ldkNode.listBalances().totalOnchainBalanceSats
        print("Total Onchain Balance: \(balance)")
        return balance
    }
    
    func totalLightningBalanceSats() async -> UInt64 {
        let balance = ldkNode.listBalances().totalLightningBalanceSats
        return balance
    }
    
    func spendableOnchainBalanceSats() async throws -> UInt64 {
        print("Fetching spendable onchain balance...")
        let balance = ldkNode.listBalances().spendableOnchainBalanceSats
        print("Spendable Onchain Balance: \(balance)")
        return balance
    }
    
    func newfundingAddress() async throws -> String {
        
        let fundingAddress = try ldkNode.onchainPayment().newAddress()
        
        return fundingAddress
    }
    
    func disconnect(nodeId: PublicKey) throws {
        try ldkNode.disconnect(nodeId: nodeId)
    }
    
    func listChannels() -> [ChannelDetails] {
        let channels = ldkNode.listChannels()
        return channels
    }
    
    func connectOpenChannel(
        nodeId: PublicKey,
        address: String,
        channelAmountSats: UInt64,
        pushToCounterpartyMsat: UInt64?,
        channelConfig: ChannelConfig?,
        announceChannel: Bool = false
    ) async throws -> UserChannelId {
        let userChannelId = try ldkNode.connectOpenChannel(
            nodeId: nodeId,
            address: address,
            channelAmountSats: channelAmountSats,
            pushToCounterpartyMsat: pushToCounterpartyMsat,
            channelConfig: nil,
            announceChannel: false
        )
        return userChannelId
    }
    
    func closeChannel(userChannelId: ChannelId, counterpartyNodeId: PublicKey) throws {
        try ldkNode.closeChannel(
            userChannelId: userChannelId,
            counterpartyNodeId: counterpartyNodeId
        )
    }
    
}
