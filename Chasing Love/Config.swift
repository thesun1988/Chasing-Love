//
//  Config.swift
//  Chasing Love
//
//  Created by Nhat Tran on 1/22/16.
//  Copyright © 2016 Nhat Tran. All rights reserved.
//



import SpriteKit

class Config {
    
    // global
    static let gameName: String = "Chasing Love"
    static let debugModeEnabled: Bool = false
    // static let shadowsEnabled: Bool = false
    static let backgroundEmittersEnabled: Bool = true
    static let soundsEnabled: Bool = true
    
    // rate url
    static let rateUrl: String = "https://itunes.apple.com/us/app/id1077977188"
    
    //game center
    static let gameCenterEnabled: Bool = true
    // leaderboards
    static let remoteLeaderboardID = "001"
    
    // admob
    static let adMobEnabled: Bool = true
    static let adMobInterstitialEnabled: Bool = true
    
    static let admobBannerId: String = "ca-app-pub-1682180937307569/1019188045"
    static let admobInterstitialId: String = "ca-app-pub-1682180937307569/2495921245"
    
    // interstitial will be requested each games
    static let interstitialInterval = 3
    
    // game scene settings
    static let sceneSize: CGSize = CGSize(width: 1024, height: 768)
    static let sceneTransition = SKTransition.crossFade(withDuration: 1.0)
    static let backgroundColor = UIColor.cloudsColor()
    static let fontColor = UIColor.midnightBlueColor()
    
    
    // images
    static let playerImageName: String = "Heart"
    static let enemyImageName: String = "Arrow"
    static let collectableImageName: String = "Heart"
    static let replayButtonImageName: String = "ReplayButton"
    static let gameCenterButtonImageName: String = "GameCenterButton"
    static let rateUsButtonImageName: String = "RateUsButton"
    static let shareButtonImageName: String = "FB"
    
    // sounds
    static let backgroundMusicFileName: String = "Background"
    static let helloSoundFileName: String = "Hello.mp3"
    static let tapSoundFileName: String = "Tap.mp3"
    static let appearSoundFileName: String = "Appear.mp3"
    static let collectSoundFileName: String = "Collect.mp3"
    static let enemySoundFileName: String = "Enemy.mp3"
    static let gameOverSoundFileName: String = "GameOver.mp3"
    
    // entities
    static let playerName: String = "Player"
    static let enemyName: String = "Enemy"
    static let spamName: String = "Collectable"
    
    static let replayButtonName: String = "replay"
    static let gameCenterButtonName: String = "gamecenter"
    static let rateUsButtonName: String = "rateus"
    static let shareButtonName: String = "share"
    
    // game object settings
    static let playerSpeed: CGFloat = 500
    static let playerScale: CGFloat = 0.6
    static let tipLabelFadeSpeed: Double = 0.4
    static let tipLabelSize: CGFloat = 24
    static let tipLabelAlpha: CGFloat = 1
    
    static let scoreLabelFadeSpeed: Double = 0.8
    static let scoreLabelSize: CGFloat = 200
    static let scoreLabelAlpha: CGFloat = 0.1
    
    //   static let enemyRotationSpeed: Double = 16.0
    static let enemyMovementSpeed: Double = 8.0
    static let maxEnemyWaitingTime: Double = 2000
    static let minEnemyWaitingTime: Double = 1000
    static let initialNumberOfEnemiesToSpawn: Int = 1
    static let amountOfEnemiesIncreasesEachScore: Int = 10
    static let collectableRotateTime: Double = 1.0
    static let collectableScaleTime: Double = 0.6
    static let gameOverRotateSpeed: Double = 1
    static let gameOverFadeoutSpeed: Double = 1.0
    static let gameOverScaleSpeed: Double = 1.0
    
    // user defaults
    static let userDefaultsTutorialCompletedKey = "userDefaultsTutorialCompletedKey"
    static let userDefaultsHighScoreKey = "userDefaultsHighScoreKey"
    static let userDefaultsPlayCountKey = "userDefaultsPlayCountKey"
    
    // physics
    enum PhysicBodyType:UInt32 {
        case player = 1
        case collectable = 2
        case enemy = 4
    }
}
