//
//  BongQRCode.swift
//  
//
//  Created by 이상봉 on 2023/07/12.
//

import UIKit
import CoreImage.CIFilterBuiltins

open class BongQRCode {
    
    // QR코드 생성하는 로직.
    public class func generateQRCode() -> UIImage {
        
        // 이미지 렌더링을 처리하는 부분
        let context = CIContext()
        // QR 코드 생성기 필터
        let filter = CIFilter.qrCodeGenerator()
        
        
        // QR 데이터 생성해주기.
        let qrData = "https://iosangbong.tistory.com/"
        // 필터에 원하는 Text를 넣어줍니다.
        filter.setValue(qrData.data(using: .utf8), forKey: "inputMessage")

        if let qrCodeImage = filter.outputImage {
            let transform = CGAffineTransform(scaleX: 5, y: 5)
            let scaledCIImage = qrCodeImage.transformed(by: transform)
            if let qrCodeCGImage = context.createCGImage(scaledCIImage, from: scaledCIImage.extent) {
                // Image에 바로 넣을 수 있도록 UIImage로 변환해줍니다.
                return UIImage(cgImage: qrCodeCGImage)
            }
        }
        
        // 변환 실패를 했을 경우 UIImage()를 넣어줍니다.
        return UIImage()
    }
}
