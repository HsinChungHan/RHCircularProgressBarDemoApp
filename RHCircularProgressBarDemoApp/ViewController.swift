//
//  ViewController.swift
//  RHCircularProgressBarDemoApp
//
//  Created by Chung Han Hsin on 2024/4/13.
//

import RHUIComponent
import UIKit

class ViewController: UIViewController {
    lazy var collectionView = makeCollectionView()
    let bgImageView = UIImageView(image: .init(named: "background"))
    
    lazy var interviewCellModels = makeInterviewCellModels()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bgImageView)
        view.addSubview(collectionView)
        collectionView.fillSuperView()
        bgImageView.fillSuperView()
    }
}

extension ViewController {
    func makeCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(InterviewCell.self, forCellWithReuseIdentifier: "AchievementCellID")
        collectionView.backgroundColor = .clear
        collectionView.contentInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        return collectionView
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interviewCellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AchievementCellID", for: indexPath) as! InterviewCell
        let cellModel = interviewCellModels[indexPath.row]
        cell.configureCell(with: cellModel)
        cell.delegate = self
        cell.backgroundColor = .clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? InterviewCell else { return }
        let cellModel = interviewCellModels[indexPath.row]
        if cellModel.currentProgressBarValue == 0 {
            cell.startBar(to: cellModel.finalProgressBarValue)
        } else {
            cell.continueBar(from: cellModel.currentProgressBarValue, to: cellModel.finalProgressBarValue)
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            let indexPath = collectionView.indexPath(for: cell)!
            let cellFrame = collectionView.layoutAttributesForItem(at: indexPath)!.frame
            if collectionView.bounds.intersects(cellFrame) {
                // visible cell
            } else {
                // invisible cell
                guard let cell = cell as? InterviewCell else {
                    return
                }
                interviewCellModels[indexPath.row].animationShouldFinish = true
                cell.resetBar()
            }
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width / 2 - 16
        return .init(width: width, height: 200)
    }
}

// MARK: - Mock Data
extension ViewController {
    
    func makeInterviewCellModels() -> [InterviewCellModel] {
        let companies = [
            "Twitter", "Docker",
            "Spotify", "TripAdvisor",
            "Sketch", "Zeplin",
            "Postman", "GitLab",
            "Netflix", "Pintrest",
            "Twitch", "Craft",
            "Linkedin", "PayPal",
             "Adobe", "Airbnb",
            "Zoom", "Trello",
            "Facebook", "Discord",
            "Raddit",
        ]
        
        let positions = [
            "Software Engineer", "iOS Developer", "Frontend Developer",
            "Backend Developer", "Android Developer",
            "Data Scientist", "DevOps Engineer",
            "Security Engineer"
        ]

        var interviews: [Interview] = []

        // 確保 colors 列表中的顏色數量至少與 companies 數量一致
        for i in 0..<companies.count {
            let company = companies[i]
            let position = positions[i % positions.count]
            let icon = company
            let allStages = Int.random(in: 3...5) // 假設所有階段數在 1 到 5 之間
            // 當前階段數不超過所有階段數
            let currentStages = Int.random(in: 1...allStages)
//            let currentStages = allStages
            let interview = Interview(company: company, position: position, icon: icon, allStages: allStages, currentStages: currentStages)
            interviews.append(interview)
        }
        
        var interviewCellModels = [InterviewCellModel]()
        for (index, interview) in interviews.enumerated() {
            interviewCellModels.append(InterviewCellModel.init(uid: index, interview: interview))
        }
        return interviewCellModels
    }
}

extension ViewController: InterviewCellDelegate {
    func interviewCell(_ interviewCell: InterviewCell, cellModel: InterviewCellModel, completionRateWillUpdate rate: Int, currentBarProgress value: Float) {
        let index = interviewCellModels.firstIndex { cellModel == $0 }!
        interviewCellModels[index].currentProgressBarValue = value
        interviewCellModels[index].currentCompletionRate = rate
    }
    
    func interviewCell(_ interviewCell: InterviewCell, cellModel: InterviewCellModel, isDonetoValue: Bool, currentBarProgress value: Float) {
    }
}
