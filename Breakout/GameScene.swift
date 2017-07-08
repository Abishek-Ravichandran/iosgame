//
//  GameScene.swift
//  Breakout
//
//  Created by roycetanjiashing on 14/10/16.
//  Copyright © 2016 examplecompany. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation
class GameScene: SKScene,SKPhysicsContactDelegate {
    var ball:SKSpriteNode!
    var paddle:SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var audioPlayer: AVAudioPlayer!
    
    override func didMove(to view: SKView) {
        ball = self.childNode(withName: "Ball") as! SKSpriteNode
        paddle = self.childNode(withName: "Paddle") as! SKSpriteNode
        scoreLabel = self.childNode(withName: "Score") as! SKLabelNode
        
        let urlPath = Bundle.main.url(forResource: "brick", withExtension: "wav")
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: urlPath!)
            audioPlayer.prepareToPlay()
        }catch{
        print("Erroe!")
        }
        
        ball.physicsBody?.applyImpulse(CGVector(dx: 50, dy: 50))
        
        let border = SKPhysicsBody(edgeLoopFrom: (view.scene?.frame)!)
        border.friction = 0
        self.physicsBody = border
        
        self.physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            paddle.position.x = touchLocation.x
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            paddle.position.x = touchLocation.x
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyAName = contact.bodyA.node?.name
        let bodyBName = contact.bodyB.node?.name
        
        if bodyAName == "Ball" && bodyBName == "Brick" || bodyAName == "Brick" && bodyBName == "Ball"{
            if bodyAName == "Brick" {
                contact.bodyA.node?.removeFromParent()
                audioPlayer.play()
                score += 1
            } else if bodyBName == "Brick" {
                contact.bodyB.node?.removeFromParent()
                audioPlayer.play()
                score += 1
            }
        }
        
        
    }
    override func update(_ currentTime: TimeInterval) {
       
        //set final score based on no of blocks
        if (score == 15) {
        
        scoreLabel.text = "You won!"
        self.view?.isPaused = true
            
        }
        if (ball.position.y < paddle.position.y){
            scoreLabel.text = "You lose!"
            self.view?.isPaused = true
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
