//
//  InterviewCellModel.swift
//  RHCircularProgressBarDemoApp
//
//  Created by Chung Han Hsin on 2024/4/13.
//

import Foundation

struct InterviewCellModel: Equatable {
    static func == (lhs: InterviewCellModel, rhs: InterviewCellModel) -> Bool {
        lhs.uid == rhs.uid
    }
    
    let uid: Int
    let interview: Interview
    var currentProgressBarValue: Float = 0
    var currentCompletionRate: Int = 0
    var animationShouldFinish: Bool = false
    
    var finalProgressBarValue: Float {
        interview.progressValue
    }
    
    var completionText: String {
        let totalStages = interview.allStages
        let currentProgressBarValueToStage = Int(currentProgressBarValue * Float(totalStages))
        return "\(currentProgressBarValueToStage) / \(interview.allStages)"
    }
    
    init(uid: Int, interview: Interview) {
        self.uid = uid
        self.interview = interview
    }
}

