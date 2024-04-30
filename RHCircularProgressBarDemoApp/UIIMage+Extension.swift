//
//  UIIMage+Extension.swift
//  RHCircularProgressBarDemoApp
//
//  Created by Chung Han Hsin on 2024/4/13.
//

import RHUIComponent
import UIKit

extension UIImage {
    func getDominantColor() -> UIColor {
        var mostCommonColor: UIColor

        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: 1, height: 1))

        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(CIImage(image: resizedImage!)!, from: CIImage(image: resizedImage!)!.extent)

        let pixelData = cgImage?.dataProvider?.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let r = CGFloat(data[0]) / 255
        let g = CGFloat(data[1]) / 255
        let b = CGFloat(data[2]) / 255
        let color = UIColor(red: r, green: g, blue: b, alpha: 1.0)
        
        // 转换为HSB颜色空间来检测亮度和饱和度
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        // 灰色调颜色的饱和度很低，同时亮度不会特别低也不会特别高
        // 黑色的亮度非常低
        // 白色的亮度非常高
        if saturation < 0.1 && (brightness > 0.9 || brightness < 0.1) {
            return Color.Purple.v900 // 接近灰色调、白色或黑色时返回紫色
        } else {
            return color // 否则返回检测到的颜色
        }
    }

}
