//
//  ViewController.swift
//  WordSearch
//
//  Created by Michael Chau  on 2020-05-19.
//  Copyright © 2020 Michael Chau . All rights reserved.
//

import UIKit

private let reuseIdentifier = "LetterCell"

private let itemsPerRow = 10

private let inset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)

class ViewController: UIViewController {
    var wordSet: [String : UIColor] = ["SWIFT": UIColor(red: 0.67, green: 0.76, blue: 1.00, alpha: 1.00),
                                       "KOTLIN": UIColor(red: 1.00, green: 0.68, blue: 0.68, alpha: 1.00),
                                       "OBJECTIVEC": UIColor(red: 1.00, green: 0.93, blue: 0.58, alpha: 1.00),
                                       "VARIABLE": UIColor(red: 0.69, green: 0.90, blue: 0.49, alpha: 1.00),
                                       "JAVA": UIColor(red: 0.94, green: 0.87, blue: 0.99, alpha: 1.00),
                                       "MOBILE": UIColor(red: 0.78, green: 0.93, blue: 1.00, alpha: 1.00)]
    
    var letterArray = Array(repeating: Array(repeating: ".", count: itemsPerRow), count: itemsPerRow)
    
    var visitedPath: Set<IndexPath> = []
    var pathArray: [IndexPath] = []
    var firstPoint: CGPoint? = nil
    
    var wordLabels: [UILabel] = []
    
    var letters = (65...90).map({Character(UnicodeScalar($0))})
    
    @IBOutlet weak var gridView: UICollectionView!
        
    @IBOutlet weak var swipeView: WordGridOverlay!
    
    @IBOutlet weak var wordStackView: UIStackView!
    
    // MARK: UI
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWordStack()
        setupGrid()
        setupGesture()
        setupBackground()
        
        self.gridView.dataSource = self
        self.gridView.delegate = self
        self.gridView.register(LetterCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func setupBackground() {
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame.size = self.view.frame.size
        gradient.colors = [UIColor(red: 0.99, green: 0.71, blue: 0.62, alpha: 1.00).cgColor,
                           UIColor(red: 1.00, green: 0.93, blue: 0.82, alpha: 1.00).cgColor]
        gradient.zPosition = -5
        self.view.layer.addSublayer(gradient)
    }
    
    // MARK: Game setup
    func setupWordStack() {
        wordStackView.spacing = 10
        for (word, _) in wordSet {
            let label = UILabel()
            label.text = word
            label.sizeToFit()
            wordLabels.append(label)
            wordStackView.addArrangedSubview(label)
        }
    }
    
    func setupGrid() {
        //pseudo random, ObjectiveC word is not
        //if fails to create random board x amount of tries will fallback
        //based on the constrant of this problem went a probalistic approach
        setWord(word: "OBJECTIVEC",
                startX: 0,
                startY: 0,
                vDirection: 1,
                hDirection: 0)
        let defaultGrid = letterArray //backup
        let numOfFailAttempt = 4
        var completedWords: Set<String> = []
        
        for _ in 0..<numOfFailAttempt {
            if completedWords.count == 5 { break }
            
            //clear
            completedWords = []
            letterArray = defaultGrid
            
            for (word, _) in wordSet {
                if word == "OBJECTIVEC" { continue }
                var wordSucess = false
                
                for _ in 0..<numOfFailAttempt {
                    if wordSucess {
                        completedWords.insert(word)
                        break
                    }
                    
                    let y = Int.random(in: 0...9)
                    let x = Int.random(in: 0...9)
                    
                    //right
                    wordSucess = wordSucess || setWord(word: word,
                                                       startX: x,
                                                       startY: y,
                                                       vDirection: 0,
                                                       hDirection: 1)
                    
                    //right down
                    wordSucess = wordSucess || setWord(word: word,
                                                       startX: x,
                                                       startY: y,
                                                       vDirection: 1,
                                                       hDirection: 1)
                    
                    //down
                    wordSucess = wordSucess || setWord(word: word,
                                                       startX: x,
                                                       startY: y,
                                                       vDirection: 1,
                                                       hDirection: 0)
                    
                    //left down
                    wordSucess = wordSucess || setWord(word: word,
                                                       startX: x,
                                                       startY: y,
                                                       vDirection: 1,
                                                       hDirection: -1)
                    
                    //left
                    wordSucess = wordSucess || setWord(word: word,
                                                       startX: x,
                                                       startY: y,
                                                       vDirection: 0,
                                                       hDirection: -1)
                    
                    //left up
                    wordSucess = wordSucess || setWord(word: word,
                                                       startX: x,
                                                       startY: y,
                                                       vDirection: -1,
                                                       hDirection: -1)
                    
                    //up
                    wordSucess = wordSucess || setWord(word: word,
                                                       startX: x,
                                                       startY: y,
                                                       vDirection: -1,
                                                       hDirection: 0)
                    
                    //right up
                    wordSucess = wordSucess || setWord(word: word,
                                                       startX: x,
                                                       startY: y,
                                                       vDirection: -1,
                                                       hDirection: 1)
                }
                if wordSucess { completedWords.insert(word) }
            }
            
        }
        
        //fall back
        if completedWords.count != 5  {
            print("falling back")
            letterArray = defaultGrid
            setWord(word: "SWIFT",
                    startX: 1,
                    startY: 1,
                    vDirection: 1,
                    hDirection: 1)
            setWord(word: "VARIABLE",
                    startX: 9,
                    startY: 9,
                    vDirection: 0,
                    hDirection: -1)
            setWord(word: "JAVA",
                    startX: 9,
                    startY: 3,
                    vDirection: 0,
                    hDirection: -1)
            setWord(word: "MOBILE",
                    startX: 1,
                    startY: 7,
                    vDirection: 0,
                    hDirection: 1)
            setWord(word: "KOTLIN",
                    startX: 3,
                    startY: 0,
                    vDirection: 0,
                    hDirection: 1)
        }
        
        //fill in the rest
        for row in 0..<letterArray.count {
            for col in 0..<letterArray.count {
                if letterArray[row][col] == "." {
                    let pos = Int.random(in: 0..<26)
                    letterArray[row][col] = String(letters[pos])
                }
            }
        }
    }
    
    func setWord(word: String,
                 startX: Int,
                 startY: Int,
                 vDirection: Int,
                 hDirection: Int) ->Bool {
        //out of bound check
        let length = word.count - 1
        if ((length*vDirection+startY < 0) ||
            (length*vDirection+startY > 9) ||
            (length*hDirection+startX < 0) ||
            (length*hDirection+startX > 9)) {
             return false
        }
        //no collison check
        for (i, _) in word.enumerated() {
            if (letterArray[i*vDirection+startY][i*hDirection+startX] != ".") {
                return false
            }
        }
        
        //set the word
        for (i, char) in word.enumerated() {
            letterArray[i*vDirection+startY][i*hDirection+startX] = String(char)
        }
        return true
    }
    
    // MARK: Gestures
    func setupGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(sender:)))
        swipeView.addGestureRecognizer(pan)
    }
    
    @objc func handleGesture(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            let point = sender.location(in: gridView)
            if let indexPath = gridView.indexPathForItem(at: point) {
                firstPoint = point
                visitedPath.insert(indexPath)
                pathArray.append(indexPath)
            }
            
        case .ended:
            //get the word created
            var word = ""
            for indexPath in pathArray {
                word += letterArray[indexPath.row/itemsPerRow][indexPath.row%itemsPerRow]
            }
            
            //check if its a word
            if let firstIndex = pathArray.first, let endIndex = pathArray.last, let color = wordSet[word]{
                let firstPoint = collectionView(gridView, cellForItemAt: firstIndex).center
                let endPoint = collectionView(gridView, cellForItemAt: endIndex).center
                swipeView.addCompletedLine(begin: firstPoint, end: endPoint, colour: color)
                
                //cross out
                for wordLabel in wordLabels {
                    if let text = wordLabel.text, text == word {
                        let aString = NSMutableAttributedString(string: word)
                        aString.addAttribute(.strikethroughStyle, value: 2, range: NSRange(location: 0, length: aString.length))
                        wordLabel.attributedText = aString
                    }
                }
                wordSet.removeValue(forKey: word)
            }
            
            clearGrid()
            checkWin()
            
        case .changed:
            //redraw line
            if let _ = firstPoint{
                swipeView.setCurrentLine(begin: firstPoint, end: Optional(sender.location(in: gridView)))
            }
            
            //update the paths if valid
            if let indexPath = gridView.indexPathForItem(at: sender.location(in: gridView)) ,
                !visitedPath.contains(indexPath){
                visitedPath.insert(indexPath)
                pathArray.append(indexPath)
            }
            
        case .cancelled, .failed:
            clearGrid()
        default:
            print("Do nothing")
        }
    }
    
    // MARK: Game helpers
    func clearGrid() {
        firstPoint = nil
        visitedPath = []
        pathArray = []
        swipeView.setCurrentLine(begin: nil,
                                 end: nil)
    }
    
    func checkWin() {
        if (wordSet.count == 0){
            let alert = UIAlertController(title: "You Win!",
                                          message: nil,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: nil))
            self.present(alert,
                         animated: true,
                         completion: nil)
        }
    }
}

// MARK: UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LetterCell
        
        cell.setLetter(char: letterArray[indexPath.row/itemsPerRow][indexPath.row%10])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = inset.left * CGFloat(itemsPerRow + 1)
        let widthLeft = collectionView.frame.width - padding
        let width = widthLeft / CGFloat(itemsPerRow)
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return inset
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return inset.left
    }
}
