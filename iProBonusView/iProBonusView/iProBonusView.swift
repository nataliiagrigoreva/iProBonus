//
//  iProBonusView.swift
//  iProBonusView
//
//  Created by Nataly on 30.06.2023.
//

import Foundation
import UIKit
import CoreGraphics

private enum Constants {
    static let viewPadding: CGFloat = 20
    static let bonusBlockHorizontalPadding: CGFloat = 20
    static let bonusBlockVerticalPadding: CGFloat = 18
    static let bonusBlockVerticalSpacing: CGFloat = 12
    static let infoButtonSize: CGFloat = 24
    static let disclosureIndicatorSize: CGFloat = 36
}

public class IProBonusView: UIViewController {
    private lazy var bonusCountLabel = UILabel()
    private lazy var bonusBurningDateLabel = UILabel()
    private lazy var bonusBurningCountLabel = UILabel()
    
    private let dateFormatter = DateFormatter()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
    }
    
    private lazy var backgroundGradient: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.locations = [0.5, 0.5]
        
        return gradientLayer
    }()
    
    private lazy var logoLabel: UILabel = {
        let label = UILabel()
        
        label.text = "ЛОГОТИП"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        
        return button
    }()
    
    private lazy var bonusBlock: UIView = {
        let block = UIView()
        
        block.backgroundColor = .systemBackground
        block.layer.cornerRadius = 20
        block.layer.shadowColor = UIColor.black.cgColor
        block.layer.shadowOffset = CGSize(width: 2, height: 2)
        block.layer.shadowRadius = 16
        block.layer.shadowOpacity = 0.2
        
        return block
    }()
    
    private lazy var bonusBurningStack: UIStackView = {
        let stack = UIStackView()
        
        stack.axis = .horizontal
        stack.spacing = 8
        
        return stack
    }()
    
    private lazy var flame: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "flame")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var disclosureIndicator: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "chevron.forward.circle"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        
        return button
    }()
    
    private func setupUI() {
        view.layer.addSublayer(backgroundGradient)
        
        [bonusBurningDateLabel, flame, bonusBurningCountLabel].forEach { bonusBurningStack.addArrangedSubview($0) }
        
        [bonusCountLabel, bonusBurningStack, disclosureIndicator].forEach { bonusBlock.addSubview($0) }
        
        [
            view,
            logoLabel,
            infoButton,
            bonusCountLabel,
            bonusBurningStack,
            disclosureIndicator,
            bonusBlock
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        [logoLabel, infoButton, bonusBlock].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            logoLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.viewPadding * 1.5),
            logoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.viewPadding + 4),
            
            infoButton.centerYAnchor.constraint(equalTo: logoLabel.centerYAnchor),
            infoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(Constants.viewPadding + 4)),
            infoButton.heightAnchor.constraint(equalToConstant: Constants.infoButtonSize),
            infoButton.widthAnchor.constraint(equalTo: infoButton.heightAnchor),
            
            bonusBlock.topAnchor.constraint(equalTo: infoButton.bottomAnchor, constant: Constants.viewPadding),
            bonusBlock.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.viewPadding),
            bonusBlock.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.viewPadding),
            bonusBlock.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            bonusCountLabel.topAnchor.constraint(equalTo: bonusBlock.topAnchor, constant: Constants.bonusBlockVerticalPadding),
            bonusCountLabel.leadingAnchor.constraint(equalTo: bonusBlock.leadingAnchor, constant: Constants.bonusBlockHorizontalPadding),
            bonusCountLabel.trailingAnchor.constraint(lessThanOrEqualTo: disclosureIndicator.leadingAnchor, constant: -2 * Constants.bonusBlockHorizontalPadding),
            
            bonusBurningStack.topAnchor.constraint(equalTo: bonusCountLabel.bottomAnchor, constant: Constants.bonusBlockVerticalSpacing),
            bonusBurningStack.leadingAnchor.constraint(equalTo: bonusBlock.leadingAnchor, constant: Constants.bonusBlockHorizontalPadding),
            bonusBurningStack.trailingAnchor.constraint(lessThanOrEqualTo: disclosureIndicator.leadingAnchor, constant: -2 * Constants.bonusBlockHorizontalPadding),
            bonusBurningStack.bottomAnchor.constraint(equalTo: bonusBlock.bottomAnchor, constant: -Constants.bonusBlockVerticalPadding),
            
            flame.widthAnchor.constraint(equalTo: bonusBurningStack.heightAnchor, multiplier: 0.8),
            
            disclosureIndicator.trailingAnchor.constraint(equalTo: bonusBlock.trailingAnchor, constant: -Constants.bonusBlockHorizontalPadding),
            disclosureIndicator.centerYAnchor.constraint(equalTo: bonusBlock.centerYAnchor),
            disclosureIndicator.heightAnchor.constraint(equalToConstant: Constants.disclosureIndicatorSize),
            disclosureIndicator.widthAnchor.constraint(equalTo: disclosureIndicator.heightAnchor)
        ])
    }
    
    public func configure(bonusCount: Int, bonusBurningCount: Int, bonusBurningDateString: String, color: UIColor, fontSize: CGFloat) {
        bonusCountLabel.text = "\(bonusCount) Бонусов"
        bonusCountLabel.textColor = .label
        bonusCountLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let bonusBurningDate = dateFormatter.date(from: bonusBurningDateString) {
            dateFormatter.dateFormat = isCurrentYear(bonusBurningDate) ? "dd.MM" : "dd.MM.yy"
            
            bonusBurningDateLabel.text = "\(dateFormatter.string(from: bonusBurningDate)) сгорит"
        } else {
            bonusBurningDateLabel.text = "Однажды сгорит"
        }
        
        bonusBurningDateLabel.textColor = .secondaryLabel
        bonusBurningDateLabel.font = UIFont.systemFont(ofSize: fontSize * 0.75)
        
        bonusBurningCountLabel.text = "\(bonusBurningCount) Б."
        bonusBurningCountLabel.textColor = .secondaryLabel
        bonusBurningCountLabel.font = UIFont.systemFont(ofSize: fontSize * 0.75)
        
        bonusBurningStack.heightAnchor.constraint(equalToConstant: fontSize * 0.75).isActive = true
        
        disclosureIndicator.tintColor = color
        infoButton.tintColor = color
        
        backgroundGradient.colors = [UIColor.white.cgColor, color.cgColor]
    }
    
    private func isCurrentYear(_ date: Date) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: date) == formatter.string(from: Date())
    }
}
