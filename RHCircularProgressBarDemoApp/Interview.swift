//
//  Interview.swift
//  RHCircularProgressBarDemoApp
//
//  Created by Chung Han Hsin on 2024/4/13.
//

import UIKit

struct Interview {
    let company: String
    let position: String
    let icon: String
    let allStages: Int
    let currentStages: Int
    var progressValue: Float {
        Float(currentStages) / Float(allStages)
    }
}
