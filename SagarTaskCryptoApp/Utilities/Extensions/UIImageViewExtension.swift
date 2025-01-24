//
//  UIImageViewExtension.swift
//  SagarTaskCryptoApp
//
//  Created by Sagar Patel on 24/01/25.
//
import UIKit

extension UIImageView {

    /// Returns desaturated image.
    func adjustSaturationForImageView(saturation: CGFloat) {
        guard let originalImage = self.image else { return }
        
        guard let ciImage = CIImage(image: originalImage) else { return }
        
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(saturation, forKey: kCIInputSaturationKey)
        
        let context = CIContext(options: nil)
        guard let outputImage = filter?.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let adjustedImage = UIImage(cgImage: cgImage)
        
        // Set the adjusted image back to the imageView
        self.image = adjustedImage
    }
}
