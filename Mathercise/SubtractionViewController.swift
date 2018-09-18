//
//  SubtractionViewController.swift
//  Mathercise
//
//  Created by Aaron Treinish on 5/25/18.
//  Copyright © 2018 Aaron Treinish. All rights reserved.
//


import Foundation
import UIKit
import AVFoundation
import GoogleMobileAds
import GameKit

private let reuseIdentifier = "subCell"

class SubtractionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var cellNumber: UILabel!
    
}


class SubtractionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, GADBannerViewDelegate {
    
    var timer = Timer()
    var second = 60
    var arrayOfNumbers = [arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1]
    var selNum = 1
    var val1 = 0
    var val2 = 0
    var total = 0
    var score = 0
    
    // Array of Play Attempts which unique for each game played
    var playAttempts = [PlayAttempt]()
    var currentPlayAttempt = PlayAttempt()
    
    // This will be the number of selections that were played
    var selectionsPlayed: Int = 0
    
    @IBOutlet weak var subtractionCollection: UICollectionView!
    
    @IBOutlet weak var labelTimer: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    
    
    //I used https://stackoverflow.com/questions/27604192/ios-how-to-segue-programmatically-using-swift?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa to help with segueing with the timer
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "gameOver") {
        var gameOverViewController = segue.destination as! GameOverViewController
        gameOverViewController.finalScoreNumber = score
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subtractionCollection.delegate = self
        subtractionCollection.dataSource = self
        
        
        // Step 1 - Setup our timer
        // Interval (how often to execute)
        // Target (where to execute)
        // Selector (what method to execute)
        // UserInfo (not using)
        // Repeats (if true, keeps going)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SubtractionViewController.timerTick), userInfo: nil, repeats: true)
        
        //background gradient
        let topColor = UIColor(red: (62/255.0), green: (176/255.0), blue: (247/255.0), alpha: 1)
        let bottomColor = UIColor(red: (208/255.0), green: (236/255.0), blue: (253/255.0), alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        
        //putting in the banner ad
        self.bannerView.adUnitID = "ca-app-pub-7930281625187952/9545221331"
        self.bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
    }
    
    // Step 2 - Implement our "tick" function
    @objc func timerTick() {
        // Countdown timer...reduce the time
        second -= 1
        
        if second == 0 {
            // set background to red
            labelTimer.textColor = UIColor.red
            timer.invalidate()
            performSegue(withIdentifier: "gameOver", sender: nil)
        }
        labelTimer.text = "\(second)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return arrayOfNumbers.count
    }
    
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let subCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SubtractionViewCell
        
        // Configure the cell
        let number = arrayOfNumbers[indexPath.row]
        print(number)
        subCell.cellNumber.text = String(number)
        subCell.backgroundColor = UIColor.cyan
        subCell.layer.borderColor = UIColor.black.cgColor
        subCell.layer.borderWidth = 1
        subCell.layer.cornerRadius = 8
        
        return subCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Tapped on a cell
        print ("entered did select that item")
        let subCell = collectionView.cellForItem(at: indexPath)as! SubtractionViewCell
        print ("assigned cell")
        
        //first selection get value
        if selNum == 1 {
            currentPlayAttempt = PlayAttempt()
            selectionsPlayed += 1
            print ("entering selection 1")
            val1 = Int(subCell.cellNumber.text!)!
            selNum = selNum + 1
            subCell.backgroundColor = UIColor(red: (255/255.0), green: (179/255.0), blue: (71/255.0), alpha: 1)
            currentPlayAttempt.Number1 = val1
        }
            //second selection get value
        else if selNum == 2 {
            print ("entering selection 2")
            val2 = Int(subCell.cellNumber.text!)!
            selNum = selNum + 1
            subCell.backgroundColor = UIColor(red: (255/255.0), green: (179/255.0), blue: (71/255.0), alpha: 1)
            currentPlayAttempt.Number2 = val2
        }
            //total get value, check if the total equals val1 + val2
            //if it does add 10 points to score
            //and set color to green otherwise change to red
        else if selNum == 3 {
            print ("entering total")
            total = Int(subCell.cellNumber.text!)!
            //this resets the selections because val1 + val2 = total or if it doesn't equal the total
            selNum = 1
            currentPlayAttempt.FinalScore = total
            
            // This will check if a selection has already been played
            var hasSelectionBeenPlayed: Bool = false
            
            // Check the array of Play Attempts to see if you have a match
            // If you do - the numbers have already been played...exit or penalize
            if selectionsPlayed > 1 {
                // search the array of selections played for the selection that we played
                print("Number of items in PlayAttempts: \(playAttempts.count)")
                for selection in playAttempts {
                    print("First selection Number 1: \(selection.Number1)")
                    print("First selection Number 2: \(selection.Number2)")
                    print("First selection Final Score: \(selection.FinalScore)")
                    if selection.Number1 == currentPlayAttempt.Number1 && selection.Number2 == currentPlayAttempt.Number2 && selection.FinalScore == currentPlayAttempt.FinalScore {
                        hasSelectionBeenPlayed = true
                        // already played this selection
                        subCell.backgroundColor = UIColor.red
                        
                        // take us out of the for loop
                        break
                    }
                }
            }
            
            if hasSelectionBeenPlayed == false {
                print("has been played = false so calculate score!")
                playAttempts.append(currentPlayAttempt)
                print("appended the score to the playattempt array")
                if total == val1 - val2 {
                    score = score + 5
                    second = second + 3
                    scoreLabel.text = String(score)
                    subCell.backgroundColor=UIColor.green
                    SubtractionViewController.vibrate()
                    saveHighScore(number: score)
                }
                else {
                    subCell.backgroundColor = UIColor.red
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // Un selected a cell
        let subCell = collectionView.cellForItem(at: indexPath)
        subCell?.backgroundColor = UIColor.cyan
    }

    
    //sends high score to game center leaderboard
    func saveHighScore(number : Int) {
        if GKLocalPlayer.localPlayer().isAuthenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: "com.score.mathercise")
            
            scoreReporter.value = Int64(number)
            
            let scoreArray : [GKScore] = [scoreReporter]
            
            GKScore.report(scoreArray, withCompletionHandler: nil)
            
            
        }
        
    }
    
    
    //generates new board
    @IBAction func newBoard(_ sender: Any) {
        arrayOfNumbers = [arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1, arc4random_uniform(10)+1, arc4random_uniform(20)+1]
        self.subtractionCollection.reloadData()
        self.subtractionCollection.reloadItems(at: subtractionCollection.indexPathsForVisibleItems)
        
        //resets play attempts when you tap for new board
        playAttempts.removeAll()
        
        //resets selections when tapping for new board
        selNum = 1
    }
    
     //I used https://stackoverflow.com/questions/29209453/how-to-hide-a-navigation-bar-from-first-viewcontroller-in-swift?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa to help write the code for hiding the nav bar
    //Hides nav bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        timer.invalidate()
    }
    
    //function to make phone vibrate
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
}

