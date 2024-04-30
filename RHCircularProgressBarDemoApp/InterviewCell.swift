//
//  AchievementCell.swift
//  RHCircularProgressBarDemoApp
//
//  Created by Chung Han Hsin on 2024/4/13.
//

import RHUIComponent
import UIKit

protocol InterviewCellDelegate: AnyObject {
    func interviewCell(_ interviewCell: InterviewCell, cellModel: InterviewCellModel, completionRateWillUpdate rate: Int, currentBarProgress value: Float)
    func interviewCell(_ interviewCell: InterviewCell, cellModel: InterviewCellModel, isDonetoValue: Bool, currentBarProgress value: Float)
}

class InterviewCell: UICollectionViewCell {
    let maxAnimationDuration = 5
    weak var delegate: InterviewCellDelegate?
    lazy var icon = makeIconImageView()
    lazy var bar = makeProgressBar(with: .red)
    lazy var companyLabel = makeCompanyLabel()
    lazy var positionLabel = makePositionLabel()
    lazy var completionLabel = makeCompletionLabel()
    lazy var stageLabel = makeStageLabel()
    
    var cellModel: InterviewCellModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension InterviewCell {
    func startBar(to value: Float = 1.0) {
        let duration = Double(maxAnimationDuration) * Double(value)
        bar.setProgressWithAnimation(duration: duration, value: value)
    }
    
    func continueBar(from fromValue: Float, to toValue: Float = 1.0) {
        let duration = Double(maxAnimationDuration) * Double(toValue - fromValue)
        bar.setProgressWithAnimationFromCurrentValue(duration: duration, from: fromValue, to: toValue)
    }

    func configureCell(with cellModel: InterviewCellModel) {
        self.cellModel = cellModel
        
        let iconImage = UIImage(named: cellModel.interview.icon)!
        let strokeColor = iconImage.getDominantColor()
        contentView.layer.borderColor = strokeColor.cgColor
        icon.image = iconImage
        companyLabel.text = cellModel.interview.company
        positionLabel.text = cellModel.interview.position
        completionLabel.text = cellModel.completionText
        bar.configureProgressBar(with: strokeColor)
    }
    
    func resetBar() {
        bar.reset()
    }
}

private extension InterviewCell {
    func setupLayout() {
        [icon, bar, companyLabel, positionLabel, completionLabel, stageLabel].forEach { contentView.addSubview($0) }
        icon.constraint(top: contentView.snp.top, leading: contentView.snp.leading, padding: .init(top: 8, left: 8, bottom: 0, right: 0), size: .init(width: 33, height: 33))
        
        let barWidth = UIScreen.main.bounds.width / 2 - 16 - 40
        bar.constraint(top: icon.snp.bottom, centerX: contentView.snp.centerX, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: 120, height: 120))
        
        positionLabel.constraint(bottom: contentView.snp.bottom, leading: contentView.snp.leading, padding: .init(top: 0, left: 8, bottom: 8, right: 0))
        companyLabel.constraint(bottom: positionLabel.snp.top, leading: contentView.snp.leading, padding: .init(top: 0, left: 8, bottom: 8, right: 0))
        completionLabel.snp.makeConstraints {
            $0.centerX.equalTo(bar.snp.centerX)
            $0.centerY.equalTo(bar.snp.centerY).offset(-10)
            
        }
        stageLabel.constraint(top: completionLabel.snp.bottom, centerX: completionLabel.snp.centerX, padding: .init(top: 4, left: 0, bottom: 0, right: 0))
        
        contentView.layer.borderWidth = 3.0
        contentView.layer.cornerRadius = 8.0
        contentView.clipsToBounds = true
        layoutIfNeeded()
    }
}

extension InterviewCell {
    func makeProgressBar(with color: UIColor) -> RHCircularProgressBar {
        let bar = RHCircularProgressBar(atStartAngle: .nineClock, forRounds: 0.5, progressLayerColor: color, strokeWidth: 20)
        bar.delegate = self
        return bar
    }
    
    func makeIconImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }
    
    func makeCompletionLabel() -> UILabel {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }
    
    func makeStageLabel() -> UILabel {
        let label = UILabel()
        label.text = "stages"
        label.font = .systemFont(ofSize: 8)
        label.textColor = .white.withAlphaComponent(0.5)
        return label
    }
    
    func makeCompanyLabel() -> UILabel {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .white
        return label
    }
    
    func makePositionLabel() -> UILabel {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .white.withAlphaComponent(0.5)
        return label
    }
}

extension InterviewCell: RHCircularProgressBarDelegate {
    func progressBar(_ progressBar: RHCircularProgressBar, completionRateWillUpdate rate: Int, currentBarProgress value: Float) {
        guard let _ = cellModel else { return }
        cellModel!.currentProgressBarValue = value
        completionLabel.text = cellModel!.completionText
        delegate?.interviewCell(self, cellModel: cellModel!, completionRateWillUpdate: rate, currentBarProgress: value)
    }
    
    
    func progressBar(_ progressBar: RHCircularProgressBar, isDonetoValue: Bool, currentBarProgress value: Float) {
        guard let cellModel else { return }
        delegate?.interviewCell(self, cellModel: cellModel, isDonetoValue: isDonetoValue, currentBarProgress: value)
    }
}
