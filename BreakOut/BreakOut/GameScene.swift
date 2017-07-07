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
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var fingerIsOnPaddle = false
    
    let ballCategoryName = "name"
    let brickCategoryName = "brick"
    let paddleCategoryName = "paddle"
    var backgroundMusicPlayer = AVAudioPlayer()
    let ballCategory:UInt32 = 0x1 << 0
    let bottomCategory:UInt32 = 0x1 << 1
    let brickCategory:UInt32 = 0x1 << 2
    let paddleCategory:UInt32 = 0x1 << 3
    override init(size: CGSize){
        super.init(size: size)
        
        self.physicsWorld.contactDelegate = self
        
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
        ball.position = CGPoint(x: self.frame.size.width / 3,y: self.frame.size.height / 3)
        self.addChild(ball)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.size.width/2)
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.applyImpulse(CGVector(dx: 20,dy: 20))
        
        let paddle = SKSpriteNode(imageNamed: "paddle")
        paddle.name = paddleCategoryName
        paddle.position = CGPoint(x: self.frame.midX ,y: paddle.frame.size.height * 2)
        self.addChild(paddle)
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.frame.size)
        paddle.physicsBody?.friction = 0.4
        paddle.physicsBody?.restitution = 0.1
        paddle.physicsBody?.isDynamic = false
        
        let bottomRect = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        self.addChild(bottom)
        
        bottom.physicsBody?.categoryBitMask = bottomCategory
        ball.physicsBody?.categoryBitMask = ballCategory
        paddle.physicsBody?.categoryBitMask = paddleCategory
        
        ball.physicsBody?.contactTestBitMask = bottomCategory | brickCategory
        
        let numberOfRows = 2
        let numberOfBricks = 7
        let brickWidth = SKSpriteNode(imageNamed: "brick").size.width
        let padding:Float = 20
        let offset: Float = (Float(self.frame.size.width) - (Float(brickWidth) * Float(numberOfBricks) + padding * (Float(numberOfBricks) - 1))) / 2
        
        for index in 1 ... numberOfRows{
            
            var yOffset:Float{
                switch index {
                case 1:
                    return Float(self.frame.size.height) * 0.8
                case 2:
                    return Float(self.frame.size.height) * 0.6
                case 3:
                    return Float(self.frame.size.height) * 0.4
                default:
                    return 0
                    
                }
            }
            
            for index in 1 ... numberOfBricks {
                let brick = SKSpriteNode(imageNamed: "brick")
                let calc1:Float = Float(index) - 0.5
                let calc2:Float = Float(index) - 1
                brick.position = CGPoint(x: CGFloat(calc1 * Float(brick.frame.size.width) + calc2 * padding + offset), y: CGFloat(yOffset))
                
                brick.physicsBody = SKPhysicsBody(rectangleOf: brick.frame.size)
                brick.physicsBody?.allowsRotation = false
                brick.physicsBody?.friction = 0
                brick.name = brickCategoryName
                brick.physicsBody?.categoryBitMask = brickCategory
                self.addChild(brick)
                
                
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        let body:SKPhysicsBody? = self.physicsWorld.body(at: touchLocation)
        if body?.node?.name == paddleCategoryName{
            print("paddle touched")
            fingerIsOnPaddle = true
            
        }
     }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if fingerIsOnPaddle{
            let touch = touches.first!
            let touchLoc = touch.location(in: self)
            let prevTouchLoc = touch.previousLocation(in: self)
            let paddle = self.childNode(withName: paddleCategoryName) as! SKSpriteNode
            var newXPos = paddle.position.x + (touchLoc.x - prevTouchLoc.x)
            
            newXPos = max(newXPos, paddle.position.y)
            newXPos = min(newXPos, self.size.width - paddle.size.width / 2)
            paddle.position = CGPoint(x: newXPos,y: paddle.position.y)
            
            
            
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
     
       fingerIsOnPaddle = false
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
        {
        firstBody = contact.bodyA
        secondBody = contact.bodyB
        }
        else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
            
        }
        
        if firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == bottomCategory{
            let gameOverScene = GameOverScene(size: self.frame.size,playerWon: false)
            self.view?.presentScene(gameOverScene)
            
        }
        
        if firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == brickCategory{
            secondBody.node?.removeFromParent()
            
            if isGameWon() {
                let youWinScene = GameOverScene(size: self.frame.size,playerWon: true)
                self.view?.presentScene(youWinScene)
            }
            
            
        }
    }
    func isGameWon() -> Bool{
        var numberOfBricks = 0
        for nodeObject in self.children{
        let node = nodeObject as SKNode
            if node.name == brickCategoryName{
            numberOfBricks += 1
            }
            
        
        }
        return numberOfBricks <= 0
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
