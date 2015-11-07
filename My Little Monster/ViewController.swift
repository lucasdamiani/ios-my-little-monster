//
//  ViewController.swift
//  My Little Monster
//
//  Created by Lucas Damiani on 05/11/15.
//  Copyright © 2015 Lucas Damiani. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var monsterImageView: MonsterImageView!
    @IBOutlet weak var heartImageView: DragImageView!
    @IBOutlet weak var foodImageView: DragImageView!
    @IBOutlet weak var penalty1ImageView: UIImageView!
    @IBOutlet weak var penalty2ImageView: UIImageView!
    @IBOutlet weak var penalty3ImageView: UIImageView!
    
    private let DIM_ALPHA: CGFloat = 0.2
    private let OPAQUE: CGFloat = 1.0
    private let MAX_PENALTIES = 3
    private let PENALTY_INTERVAL = 3.0
    
    private var penalties = 0
    private var timer: NSTimer!
    private var monsterHappy = false
    private var currentItem: UInt32 = 0
    
    private lazy var musicPlayer: AVAudioPlayer? = {
        [unowned self] in return self.initAVAudioPlayer("cave-music", ofType: "mp3")
    }()
    
    private lazy var sfxBite: AVAudioPlayer? = {
        [unowned self] in return self.initAVAudioPlayer("bite", ofType: "wav")
    }()
    
    private lazy var sfxHeart: AVAudioPlayer? = {
        [unowned self] in return self.initAVAudioPlayer("heart", ofType: "wav")
    }()
    
    private lazy var sfxDeath: AVAudioPlayer? = {
        [unowned self] in return self.initAVAudioPlayer("death", ofType: "wav")
    }()
    
    private lazy var sfxSkull: AVAudioPlayer? = {
        [unowned self] in return self.initAVAudioPlayer("skull", ofType: "wav")
    }()
    
    private func initAVAudioPlayer(forResource: String?, ofType: String?) -> AVAudioPlayer? {
        do {
            if let path = NSBundle.mainBundle().pathForResource(forResource, ofType: ofType) {
                let player = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path))
                player.prepareToPlay()
                
                return player
            }
            
            return nil
        } catch let err as NSError {
            print(err.debugDescription)
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heartImageView.dropTarget = monsterImageView
        foodImageView.dropTarget = monsterImageView
        
        penalty1ImageView.alpha = DIM_ALPHA
        penalty2ImageView.alpha = DIM_ALPHA
        penalty3ImageView.alpha = DIM_ALPHA
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        startTimer()
        musicPlayer?.play()
    }
    
    func itemDroppedOnCharacter(notification: AnyObject) {
        monsterHappy = true
        startTimer()
        
        foodImageView.alpha = DIM_ALPHA
        foodImageView.userInteractionEnabled = false
        heartImageView.alpha = DIM_ALPHA
        heartImageView.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart?.play()
        } else {
            sfxBite?.play()
        }
    }
    
    private func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(PENALTY_INTERVAL, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        if !monsterHappy {
            penalties++
            sfxSkull?.play()
            
            if penalties == 1 {
                penalty1ImageView.alpha = OPAQUE
                penalty2ImageView.alpha = DIM_ALPHA
                penalty3ImageView.alpha = DIM_ALPHA
            } else if penalties == 2 {
                penalty1ImageView.alpha = OPAQUE
                penalty2ImageView.alpha = OPAQUE
                penalty3ImageView.alpha = DIM_ALPHA
            } else if penalties >= 3 {
                penalty1ImageView.alpha = OPAQUE
                penalty2ImageView.alpha = OPAQUE
                penalty3ImageView.alpha = OPAQUE
            } else {
                penalty1ImageView.alpha = DIM_ALPHA
                penalty2ImageView.alpha = DIM_ALPHA
                penalty3ImageView.alpha = DIM_ALPHA
            }
            
            if penalties >= MAX_PENALTIES {
                gameOver()
            }
        }
        
        let randomNumber = arc4random_uniform(2) // 0 or 1
        if randomNumber == 0 {
            foodImageView.alpha = DIM_ALPHA
            foodImageView.userInteractionEnabled = false
            heartImageView.alpha = OPAQUE
            heartImageView.userInteractionEnabled = true
        } else {
            
            foodImageView.alpha = OPAQUE
            foodImageView.userInteractionEnabled = true
            heartImageView.alpha = DIM_ALPHA
            heartImageView.userInteractionEnabled = false
        }
        
        currentItem = randomNumber
        monsterHappy = false
    }
    
    private func gameOver() {
        timer.invalidate()
        monsterImageView.playDeathAnimation()
        sfxDeath?.play()
    }
}

