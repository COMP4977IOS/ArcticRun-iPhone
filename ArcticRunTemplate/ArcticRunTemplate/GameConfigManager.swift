//
//  GameLogic.swift
//  ArcticRunTemplate
//
//  Created by Anthony on 2016-04-02.
//  Copyright © 2016 Matt Wiseman. All rights reserved.
//

public class GameConfigManager {

    enum PlistError: ErrorType {
        case FileNotWritten
        case FileDoesNotExist
    }
    var level:String?
    var currentLevel:NSDictionary?
    var sourcePath:String? {
        guard let path = NSBundle.mainBundle().pathForResource(level, ofType: "plist") else { return .None }
        return path
    }
    
    // Loads a level configuration file (PList) into the manager object
    // File format: LevelX.plist - Where 'X' is the level number specified
    func loadLevel(level:Int) ->NSDictionary? {
        self.level = "Level" + String(level)
        let fileManager = NSFileManager.defaultManager()
        guard let source = sourcePath else { return nil }
        guard fileManager.fileExistsAtPath(source) else { return nil }

        if fileManager.fileExistsAtPath(source) {
            guard let dict = NSDictionary(contentsOfFile: source) else { return .None }
            self.currentLevel = dict
            return dict
        } else {
            return .None
        }
    }
    
    // Loads the configuration info for a specific segment inside of the level PList file
    // Segment format: segmentX - Where 'X' is the segment number specified
    func getLevelSegment(segmentNum:Int) ->NSDictionary? {
        if (self.currentLevel != nil) {
            let levelSegment = (self.currentLevel?.objectForKey("segment" + String(segmentNum))) as! NSDictionary
            return levelSegment
        } else {
            return .None
        }
    }
    
    // Returns the title, image name, and description for a specific level
    func getLevelInfo() -> NSDictionary? {
        if (self.currentLevel != nil) {
            let levelInfo = (self.currentLevel?.objectForKey("information")) as! NSDictionary
            return levelInfo
        } else {
            return .None
        }
    }

}
