//
//  QRCodeView.swift
//  LightningRemit
//
//  Created by Temiloluwa on 06/07/2024.
//

import Foundation
import CoreImage.CIFilterBuiltins
import SwiftUI

public enum QRCodeType {
    case lightning(String)
    case bitcoin(String)

    var qrString: String {
        
        switch self {
            
        case .bitcoin(let address):
            return "bitcoin: \(address)"
            
        case .lightning(let invoice):
            return "lightning:\(invoice)"
       
        }
    }
}
public struct QRCodeView: View {
    @State private var viewState = CGSize.zero
    let screenBounds = UIScreen.main.bounds
    public var qrCodeType: QRCodeType

    public init(qrCodeType: QRCodeType) {
        self.qrCodeType = qrCodeType
    }

    public var body: some View {
        Image(uiImage: generateQRCode(from: qrCodeType.qrString))
            .interpolation(.none)
            .resizable()
            .scaledToFit()
            .padding()
            .applyFidgetEffect(viewState: $viewState)
            .gesture(dragGesture())
    }

    private func generateQRCode(from string: String) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }

    private func dragGesture() -> some Gesture {
        DragGesture()
            .onChanged(handleDragChanged(_:))
            .onEnded(handleDragEnded(_:))
    }

    private func handleDragChanged(_ value: DragGesture.Value) {
        let translation = value.translation
        let multiplier: CGFloat = 0.05
        viewState.width = -translation.width * multiplier
        viewState.height = -translation.height * multiplier
    }

    private func handleDragEnded(_ value: DragGesture.Value) {
        withAnimation {
            self.viewState = .zero
        }
    }
}

#Preview {
    QRCodeView(qrCodeType: .lightning("lightingqrcode"))
   
}

#Preview {
    QRCodeView(qrCodeType: .bitcoin("bitcoinqrcode"))
}
