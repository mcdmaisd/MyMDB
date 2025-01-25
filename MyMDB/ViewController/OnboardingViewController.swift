//
//  ViewController.swift
//  MyMDB
//
//  Created by ilim on 2025-01-24.
//

import UIKit

final class OnboardingViewController: BaseViewController {
    
    private let onboardingImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let startButton = CustomButton(title: C.start)
    
    override func configureHierarchy() {
        addSubView(onboardingImageView)
        addSubView(titleLabel)
        addSubView(descriptionLabel)
        addSubView(startButton)
    }
    
    override func configureLayout() {
        onboardingImageView.snp.makeConstraints { make in
            let size = UIImage.onboarding.size
            let ratio = size.height / size.width
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(onboardingImageView.snp.width).multipliedBy(ratio)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(onboardingImageView.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        startButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    
    override func configureView() {
        onboardingImageView.contentMode = .scaleAspectFit
        onboardingImageView.image = UIImage.onboarding
        
        titleLabel.text = C.onboarding
        titleLabel.textColor = .customWhite
        titleLabel.textAlignment = .center
        titleLabel.font = .italicSystemFont(ofSize: C.sizeXl)
        
        descriptionLabel.numberOfLines = 2
        descriptionLabel.text = C.description
        descriptionLabel.textColor = .customDarkGray
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = .systemFont(ofSize: C.sizeMd)
        
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func startButtonTapped() {
        navigationController?.pushViewController(SetProfileViewController(), animated: true)
    }
}

