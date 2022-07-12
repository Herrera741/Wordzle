//
//  ViewController.swift
//  Wordzle
//
//  Created by Sergio Herrera on 7/5/22.
//

import UIKit

class ViewController: UIViewController {
    
    let answers: [String] = ["after",
                             "money",
                             "piece",
                             "pizza",
                             "found",
                             "first",
                             "error",
                             "thumb",
                             "sound",
                             "apple",
                             "fight",
                             "order"]
    var answer = ""
    private var guessedCorrect = false
    private var guesses: [[Character?]] = Array(repeating: Array(repeating: nil, count: 5), count: 6)
    let keyboardVC = KeyboardViewController()
    let boardVC = BoardViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        answer = answers.randomElement() ?? "later"
        view.backgroundColor = .black
        
        addChildren()
    }

    private func addChildren() {
        // 
        addChild(keyboardVC)
        keyboardVC.didMove(toParent: self)
        keyboardVC.delegate = self
        keyboardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardVC.view)
        
        addChild(boardVC)
        boardVC.didMove(toParent: self)
        boardVC.view.translatesAutoresizingMaskIntoConstraints = false
        boardVC.datasource = self
        view.addSubview(boardVC.view)
        
        addConstraints()
    }
    
    func addConstraints() {
        
        NSLayoutConstraint.activate([
            // board constraints for leading/trailing/top/bottom/height
            boardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            boardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            boardVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            boardVC.view.bottomAnchor.constraint(equalTo: keyboardVC.view.topAnchor),
            boardVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            // keyboard constraints for leading/trailing/bottom
            keyboardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension ViewController: KeyboardViewControllerDelegate {
    func keyboardViewController(_ vc: KeyboardViewController, didTapKey letter: Character) {
        
        // update guess in board cell
        var stop: Bool = false
    
        for guessRow in 0..<guesses.count {
            for guessColumn in 0..<guesses[guessRow].count {
                if guesses[guessRow][guessColumn] == nil {
                    guesses[guessRow][guessColumn] = letter
                    stop = true
                    break
                }
            }
            
            if stop {
                break
            }
        }
        
        boardVC.reloadData()
    }
}

extension ViewController: BoardViewControllerDataSource {
    var currentGuesses: [[Character?]] {
        return guesses
    }
    
    func boxColor(at indexPath: IndexPath) -> UIColor? {
        let rowIndex = indexPath.section
        
        let count = guesses[rowIndex].compactMap( { $0 } ).count
        guard count == 5 else {
            return nil
        }
        
        let indexedAnswer = Array(answer)
        
        // check if letter exists in board letter location
        guard let letter = guesses[indexPath.section][indexPath.row], indexedAnswer.contains(letter) else {
            return .darkGray
        }
    
        if indexedAnswer[indexPath.row] == letter {
            return .systemGreen
        }
        
        return .systemOrange
    }
}
