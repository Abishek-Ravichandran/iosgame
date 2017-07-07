//
//  GameOverScene.swift
//  BreakOut
//
//  Created by R.M.K.CET on 07/07/17.
//  Copyright © 2017 RMKCET. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    init(size: CGSize, playerWon:Bool) {
    super.init(size: size)
      let background = SKSpriteNode(imageNamed: "bg")
        background.position = CGPoint(x: self.frame.midX, y:self.frame.midY)
        self.addChild(background)
        
        let gameOverLabel = SKLabelNode(fontNamed: "Avenir-Black")
        gameOverLabel.fontSize = 46
        gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        if playerWon{
            gameOverLabel.text = "You Win "
        }
        else{
            gameOverLabel.text = "Game Over"
        }
        self.addChild(gameOverLabel)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let breakoutGameScene = GameScene(size: self.size)
    self.view?.presentScene(breakoutGameScene)
        
        
    }
    
    
    
    
    
   required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        

    }
    
    
    

}
