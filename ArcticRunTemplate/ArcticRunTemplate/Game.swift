//
//  Game.swift
//  ArcticRunTemplate
//
//  Created by Anthony on 2016-04-02.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

import Foundation

public class Game {
    
    init(level:Int) {
        let manager = GameConfigManager()
        if let levelDict = manager.loadLevel(level) {
            print(manager.getLevelSegment(1))
        } else {
            print("Unable to get Plist")
        }
    }
    
}
