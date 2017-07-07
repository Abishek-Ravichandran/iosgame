//
//  GameViewController.swift
//  BreakOut
//
//  Created by R.M.K.CET on 05/07/17.
//  Copyright © 2017 RMKCET. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
            }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let skView = self.view as! SKView
        if skView.scene == nil {
        
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            let gameScene = GameScene(size: skView.bounds.size)
            gameScene.scaleMode = .aspectFill
            skView.presentScene(gameScene)
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
