//
//  MenuScene.swift
//  Zombie-Run
//
//  Created by David Cruz Anaya on 10/07/2016.
//  Copyright © 2016 David Cruz Anaya. All rights reserved.
//

import UIKit
import SpriteKit

class MenuScene: SKScene {
    var soundToPlay: String?
    var label: SKLabelNode?
    var gameFinished: Bool?
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        if gameFinished! {
            label = SKLabelNode(text: "You Won, Great!")
        }else{
            label = SKLabelNode(text: "You Are killed, Try Again!")
        }
        
        label!.fontName = "AvenirNext-Bold"
        label!.fontSize = 55
        label!.fontColor = UIColor.whiteColor()
        label!.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        if let soundToPlay = soundToPlay {
            self.runAction(SKAction.playSoundFileNamed(soundToPlay, waitForCompletion: false))
        }
        
        self.addChild(label!)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let gameScene = GameScene(fileNamed: "GameScene")
        
        let transition = SKTransition.flipVerticalWithDuration(1.0)
        let sKview = self.view as SKView!
        gameScene?.scaleMode = .AspectFill
        sKview.presentScene(gameScene!, transition: transition)
    }
    
}
