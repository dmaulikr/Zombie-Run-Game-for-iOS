//
//  GameScene.swift
//  Zombie-Run
//
//  Created by David Cruz Anaya on 09/07/2016.
//  Copyright (c) 2016 David Cruz Anaya. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let playerSpeed: CGFloat = 170.0
    
    let zombieSpeed: CGFloat = 100.0
    
    var player: SKSpriteNode?
    
    var zombies: [SKSpriteNode] = []
    
    var lastTouch: CGPoint? = nil
    
    var playerTextures: [SKTexture] = []
    var zombieTextures: [SKTexture] = []
    
    override func didMoveToView(view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        // set up the player node
        player = self.childNodeWithName("player") as?  SKSpriteNode
        // setup player physics
        player?.physicsBody?.mass = 2
        
        for i in 1...4 {
            playerTextures.append(SKTexture(imageNamed: "person0\(i)"))
        }
        playerTextures.append(playerTextures[2])
        playerTextures.append(playerTextures[1])
        
        for child in self.children {
            if child.name == "zombie" {
                if let child = child as? SKSpriteNode {
                    child.physicsBody?.mass = 0.14
                    
                    zombies.append(child)
                }
            }
        }
        
        for i in 1...4 {
            zombieTextures.append(SKTexture(imageNamed: "zombie0\(i)"))
        }
        zombieTextures.append(zombieTextures[2])
        zombieTextures.append(zombieTextures[1])
        
    }
    
    // private func to handle touches
    private func handleTouches(touches: Set<UITouch>){
        for touch in touches{
            let touchLocation = touch.locationInNode(self)
            lastTouch = touchLocation
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        handleTouches(touches)
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        handleTouches(touches)
        
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        handleTouches(touches)
        
    }
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    private func shouldMove(currentPosition currentPosition: CGPoint, touchPosition: CGPoint) -> Bool {
        return abs(currentPosition.x - touchPosition.x) > player!.frame.width / 2 || abs(currentPosition.y - touchPosition.y) > player!.frame.height / 2
    }
    
    override func didSimulatePhysics() {
        if let _ = player {
            updatePlayer()
            
            updateZombies()
        }
    }

    func updatePlayer() {
        if let touch = lastTouch {
            let currentPosition = player!.position
            if shouldMove(currentPosition: currentPosition, touchPosition: touch) {
                let angle = atan2(currentPosition.y - touch.y, currentPosition.x - touch.x) + CGFloat(M_PI)
                let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI * 0.5), duration: 0)
                
                player!.runAction(rotateAction)
                
                let velocityX = playerSpeed * cos(angle)
                let velocityY = playerSpeed * sin(angle)
                
                let newVelocity = CGVector(dx: velocityX, dy: velocityY)
                player!.physicsBody!.velocity = newVelocity
                
                startPlayerAnimation()
                
            } else {
                player!.physicsBody!.resting = true
                
                stopPlayerAnimation()
            }
        }
    }
    
    func updateZombies() {
        
        let targetPosition = player!.position
        
        for zombie in zombies {
            
            let currentPosition = zombie.position
            let angle = atan2(currentPosition.y - targetPosition.y, currentPosition.x - targetPosition.x) + CGFloat(M_PI)
            let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI * 0.5), duration: 0)
                
            zombie.runAction(rotateAction)
                
            let velocityX = zombieSpeed * cos(angle)
            let velocityY = zombieSpeed * sin(angle)
                
            let newVelocity = CGVector(dx: velocityX, dy: velocityY)
            zombie.physicsBody!.velocity = newVelocity
        }
        
        startZombieAnimation()
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == player?.physicsBody?.categoryBitMask && secondBody.categoryBitMask == zombies[0].physicsBody?.categoryBitMask {
            gameOver();
        }
    }
    
    private func gameOver(){
        print("game Ended");
    }
    
    
    func startPlayerAnimation(){
        if player!.actionForKey("animation") == nil {
            let playerAnimation = SKAction.animateWithTextures(playerTextures, timePerFrame: 0.1)
            player!.runAction(SKAction.repeatActionForever(playerAnimation), withKey: "animation")
        }
    }
    
    func stopPlayerAnimation() {
        player!.removeActionForKey("animation")
    }
    
    func startZombieAnimation(){
        
        for zombie in zombies {
            if zombie.actionForKey("animation") == nil {
                let zombieAnimation = SKAction.animateWithTextures(zombieTextures, timePerFrame: 0.1)
                zombie.runAction(SKAction.repeatActionForever(zombieAnimation), withKey: "animation")
            }
        }
        
    }
    
}
