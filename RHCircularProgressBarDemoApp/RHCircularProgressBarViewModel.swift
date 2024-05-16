//
//  RHCircularProgressBarViewModel.swift
//  RHCircularProgressBarDemoApp
//
//  Created by Chung Han Hsin on 2024/5/16.
//

import Foundation
import RHUIComponent
import UIKit

class RHCircularProgressBarViewModel {
    private(set) var toValue: Float = 0
    var isFinishProgress: Bool { toValue == 1.0 }
    
    var startAngle: CGFloat { startAngleType.angle }
    
    var endAngle: CGFloat { startAngle + rounds * 2 * CGFloat.pi }
    
    var trackLayerCGColor: CGColor { progressLayerColor.withAlphaComponent(0.5).cgColor }
    
    var progressLayerCGColor: CGColor { progressLayerColor.cgColor }
    
    let startAngleType: StartAngleType
    let rounds: CGFloat
    private(set) var progressLayerColor: UIColor
    let strokeWidth: CGFloat
    init(startAngleType: StartAngleType, rounds: CGFloat, progressLayerColor: UIColor, strokeWidth: CGFloat) {
        self.startAngleType = startAngleType
        self.rounds = rounds
        self.progressLayerColor = progressLayerColor
        self.strokeWidth = strokeWidth
    }
}

extension RHCircularProgressBarViewModel {
    func getCurrentProgressLayerValue(withProgressLayer progressLayer: CAShapeLayer) -> Float {
        let currentProgressLayerValue = progressLayer.presentation()?.strokeEnd ?? 0
        let currentProgressValue = min(currentProgressLayerValue + 0.01, 1.0)
        return Float(currentProgressValue)
    }
    
    func getCompletionRate(withProgressLayer progressLayer: CAShapeLayer) -> Int {
        let currentProgressValue = getCurrentProgressLayerValue(withProgressLayer: progressLayer)
        let completionRate = Int(min(currentProgressValue * 100 + 1, 100))
        return completionRate
    }
    
    func setToValue(with value: Float) {
        toValue = value
    }
    
    func setProgressLayerColor(withColor color: UIColor) {
        progressLayerColor = color
    }
}
