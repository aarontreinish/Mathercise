//
//  ViewController.swift
//  Mathercise
//
//  Created by Aaron Treinish on 5/25/18.
//  Copyright © 2018 Aaron Treinish. All rights reserved.
//


import UIKit
import GameKit
import Foundation
import GoogleMobileAds


class ViewController: UIViewController, GKGameCenterControllerDelegate, GADBannerViewDelegate {

    //I used https://code.tutsplus.com/tutorials/game-center-and-leaderboards-for-your-ios-app--cms-27488 to help write the game center code
    //Check if the user has Game Center enabled
    var gcEnabled = Bool()
    
    // Check the default leaderboardID
    var gcDefaultLeaderBoard = String()
    
    //my game center leaderboardID
    let LEADERBOARD_ID = "com.score.mathercise"
    
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        authenticateLocalPlayer()
        
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
        self.bannerView.adUnitID = "ca-app-pub-7930281625187952/5124543835"
        self.bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //checks if player is signed in to game center
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                //Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                //Player is logged in and loads game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error)
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
                
            } else {
                // checks if game center is enabled
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error)
            }
        }
    }
    
    //delegate function
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    
    //Used this site, http://www.nzambistudios.com/articles/how-to-create-an-app-store-button-direct-to-the-app-review-tab, to help write the code for review app button
    @IBAction func reviewApp(_ sender: Any) {
        let appleID = "1391336506"
        let appStoreLink = "https://itunes.apple.com/us/app/math-ercise/id1391336506?ls=1&mt=8"
        UIApplication.shared.open(URL(string: appStoreLink)!, options: [:], completionHandler: nil)
    
    }

    //button to bring game center leaderboard
    @IBAction func checkGC(_ sender: Any) {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = LEADERBOARD_ID
        present(gcVC, animated: true, completion: nil)
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
    }
    

    
}

