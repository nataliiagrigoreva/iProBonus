//
//  ViewController.swift
//  iProBonus
//
//  Created by Nataly on 30.06.2023.
//
import UIKit
import iProBonusView
import iProBonusApi

class ViewController: UIViewController {
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let accessKey = Bundle.main.object(forInfoDictionaryKey: "AccessKey") as? String
    private let clientID = Bundle.main.object(forInfoDictionaryKey: "ClientID") as? String
    private let deviceID = Bundle.main.object(forInfoDictionaryKey: "DeviceID") as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        
        setupActivityIndicator()
        fetchData()
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func fetchData() {
        guard let accessKey = accessKey, let clientID = clientID, let deviceID = deviceID else {
            return
        }
        
        
        let apiService = IProBonusAPI(accessKey: accessKey, clientID: clientID, deviceID: deviceID)
        
        apiService.getBonusInfo { [weak self] (result: Result<BonusInfoResponseData, Error>) in
            switch result {
            case .success(let info):
                DispatchQueue.main.async {
                    self?.setupBonusView(with: info)
                }
            case .failure:
                break
            }
        }
    }
    
    private func setupBonusView(with bonusInfo: BonusInfoResponseData) {
        activityIndicator.stopAnimating()
        
        let bonusContainer = IProBonusView()
        bonusContainer.configure(bonusCount: bonusInfo.currentQuantity, bonusBurningCount: bonusInfo.forBurningQuantity, bonusBurningDateString: bonusInfo.dateBurning, color: .systemPink, fontSize: 24)
        
        guard let bonusView = bonusContainer.view else { return }
        view.addSubview(bonusView)
        
        NSLayoutConstraint.activate([
            bonusView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bonusView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bonusView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
