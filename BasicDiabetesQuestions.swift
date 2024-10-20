//
//  BasicDiabetesQuestions.swift
//  DiabetesTest
//
//  Created by Ryan Lien on 10/19/24.
//
import UIKit
import SwiftUI

class OnboardingQuestionViewController: UIViewController {
    
    private let questions = [
        Question(key: "pairMeter", text: "Would you like to pair your GP meter?", options: ["Yes", "No"]),
        Question(key: "diabetesType", text: "What type of diabetes do you have?", options: ["Type 1", "Type 2", "Prediabetic", "Other"]),
        Question(key: "diagnosisTime", text: "When were you diagnosed with diabetes?", options: ["Less than 6 months ago", "Less than 1 year ago", "1-5 years ago", "Over 5 years ago"])
    ]
    
    private var currentQuestionIndex = 0
    private var answers: [String: String] = [:]
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor(red: 0, green: 0.5, blue: 0, alpha: 1)
        label.numberOfLines = 0
        return label
    }()
    
    private let optionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        stackView.alignment = .center // Align items to the center
        return stackView
    }()

    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Previous", for: .normal)
        button.tintColor = UIColor(red: 0, green: 0.5, blue: 0, alpha: 1)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.tintColor = UIColor(red: 0, green: 0.5, blue: 0, alpha: 1)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateQuestion()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.9, green: 1.0, blue: 0.9, alpha: 1)
        
        let cardView = UIView()
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 20
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        
        view.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            cardView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7)
        ])
        
        cardView.addSubview(questionLabel)
        cardView.addSubview(optionsStackView)
        cardView.addSubview(previousButton)
        cardView.addSubview(nextButton)
        
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            questionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            questionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            optionsStackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 24),
            optionsStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            optionsStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            previousButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            previousButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -24),
            
            nextButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            nextButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -24)
        ])
        
        previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    private func updateQuestion() {
        let question = questions[currentQuestionIndex]
        questionLabel.text = question.text
        
        optionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for option in question.options {
            let button = UIButton(type: .system)
            button.setTitle(option, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            button.contentHorizontalAlignment = .center // Center the text within the button
            button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
            button.layer.cornerRadius = 8
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(red: 0, green: 0.5, blue: 0, alpha: 1).cgColor
            
            // Set button background based on selection
            if answers[question.key] == option {
                button.backgroundColor = UIColor(red: 0, green: 0.8, blue: 0, alpha: 1)
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = UIColor(red: 0.9, green: 1.0, blue: 0.9, alpha: 1)
                button.setTitleColor(UIColor(red: 0, green: 0.5, blue: 0, alpha: 1), for: .normal)
            }
            
            button.addTarget(self, action: #selector(optionButtonTapped(_:)), for: .touchUpInside)
            optionsStackView.addArrangedSubview(button)
        }

        
        previousButton.isEnabled = currentQuestionIndex > 0
        nextButton.isEnabled = currentQuestionIndex < questions.count - 1
    }
    
    @objc private func optionButtonTapped(_ sender: UIButton) {
        guard let option = sender.title(for: .normal) else { return }
        answers[questions[currentQuestionIndex].key] = option
        updateQuestion()
        
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            updateQuestion()
        }
    }
    
    @objc private func previousButtonTapped() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
            updateQuestion()
        }
    }
    
    @objc private func nextButtonTapped() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            updateQuestion()
        }
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .right:
            previousButtonTapped()
        case .left:
            nextButtonTapped()
        default:
            break
        }
    }
}

struct Question {
    let key: String
    let text: String
    let options: [String]
}

// SwiftUI wrapper
struct OnboardingQuestionView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> OnboardingQuestionViewController {
        return OnboardingQuestionViewController()
    }
    
    func updateUIViewController(_ uiViewController: OnboardingQuestionViewController, context: Context) {
        // Update the UIViewController if needed
    }
}

// Preview
struct OnboardingQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingQuestionView()
            .previewDevice("iPhone 14")
    }
}
