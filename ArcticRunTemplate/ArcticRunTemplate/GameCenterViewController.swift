//
//  GameCenterViewController.swift
//  ArcticRunTemplate
//
//  Created by Clyde Chen on 2016-03-22.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import GameKit

let leaderboardID = "gctestleaderboard_001"
let fiveClicksAchievement = GKAchievement(identifier: "AchievementFiveClicks")
var score : Int64 = 0

class GameCenterViewController: UIViewController, GKGameCenterControllerDelegate {
    
    
    func authenticateWithGameCenter() {
        // called inside viewDidLoad
        
        // notify user using game center upon any status change
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: Selector("authenticationDidChange:"),
            name: GKPlayerAuthenticationDidChangeNotificationName,
            object: nil
        )
        
        // authenticate current player
        GKLocalPlayer.localPlayer().authenticateHandler = {
            viewController, error in
            
            guard let vc = viewController else { return }
            
            self.presentViewController(vc, animated: true, completion: nil)
        }
        
        // use game center to show achievement completion alert
        fiveClicksAchievement.showsCompletionBanner = true
        GKAchievement.reportAchievements([fiveClicksAchievement], withCompletionHandler: nil)
        
    }
    
    func authenticationDidChange(notification: NSNotification) {
        // do something upon successful user logging in
        displayProgress(score)
    }
    
    // display the score in a leaderboard view
    func displayProgress(s : Int64){
        let gkScore = GKScore(leaderboardIdentifier: leaderboardID)
        gkScore.value = s
        
        GKScore.reportScores([gkScore]) { error in
            guard error == nil  else { return }
            
            let vc = GKGameCenterViewController()
            vc.leaderboardIdentifier = leaderboardID
            vc.gameCenterDelegate = self
            vc.viewState = GKGameCenterViewControllerState.Leaderboards
            
            self.presentViewController(vc, animated: true, completion: nil)   }
    }
    
    // present view controller on finish
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // increment score upon click
    @IBAction func clickCounter(sender: AnyObject) {
        score++
    }
    
}
