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
                             "order",
                             "final",
                             "bison",
                             "sugar",
                             "diner",
                             "crane",
                             "ember",
                             "house",
                             "igloo",
                             "rapid",
                             "taste"]
    var answer = ""
    private var currentGuessRow = 0
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
        
        if currentGuessRow < guesses.count {
            for guessColumn in 0..<guesses[currentGuessRow].count {
                if guesses[currentGuessRow][guessColumn] == nil {
                    
                    // check if action key and not a guessed letter
                    if (letter == "<" || letter == ">") {
                        if letter == "<" {
                            // submit guess
                            print("submit guess")
                            currentGuessRow += 1
                            stop = true
                            break
                        } else {
                            // delete last guessed letter
                            if guessColumn > 0 {
                                guesses[currentGuessRow][guessColumn-1] = nil
                            }
                        }
                    } else {
                        // guess is a letter
                        guesses[currentGuessRow][guessColumn] = letter
                        
                        // if last guessed letter was in final position update current row
                        if guessColumn == 4 {
                            currentGuessRow += 1
                        }
                        
                        stop = true
                        break
                    }
                }
            
                if stop {
                    break
                }
            } // for-loop
        } // current guess row check
        
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
