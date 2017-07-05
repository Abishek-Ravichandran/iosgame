//
//  GameScene.swift
//  BreakOut
//
//  Created by R.M.K.CET on 05/07/17.
//  Copyright © 2017 RMKCET. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation
import AVKit
class GameScene: SKScene {
    
    let ballCategoryName = "name"
    let brickCategoryName = "brick"
    let paddleCategoryName = "paddle"
    var backgroundMusicPlayer = AVAudioPlayer()
    override init(size: CGSize){
        super.init(size: size)
        let bgMusicURL = Bundle.main.url(forResource: "bgMusic", withExtension: "mp3")
        
        do{ try backgroundMusicPlayer = AVAudioPlayer(contentsOf: bgMusicURL!)
        }catch{error;}
        
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
        
        let backgroundImage = SKSpriteNode(imageNamed: "bg")
        backgroundImage.position = CGPoint(x: self.frame.size.width / 2,y: self.frame.size.height / 2)
        self.addChild(backgroundImage)
        self.physicsWorld.gravity = CGVector(dx: 0,dy: 0)
        
        let worldBorder = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = worldBorder
        self.physicsBody?.friction = 0
        
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.name = ballCategoryName
        ball.position = CGPoint(x: self.frame.size.width / 4,y: self.frame.size.height / 4)
        self.addChild(ball)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.size.width/2)
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.applyImpulse(CGVector(dx: 205,dy: 205))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
