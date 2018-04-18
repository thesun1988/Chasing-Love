

import SpriteKit
import GameKit

class SKBaseScene: SKScene {

    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
    }

    func heartEmitter(_ color: SKColor, heartSpeedY: CGFloat, heartPerSecond: CGFloat, heartScaleFactor: CGFloat) -> SKEmitterNode {

        // Determine the time a heart is visible on screen
        let lifetime =  frame.size.height * UIScreen.main.scale / heartSpeedY

        // Create the emitter node
        let emitterNode = SKEmitterNode()
        emitterNode.particleTexture = SKTexture(imageNamed: "Balloon")
        emitterNode.particleBirthRate = heartPerSecond * 0.4
        emitterNode.particleColor = color
        emitterNode.particleSpeed = heartSpeedY * 0.6
        emitterNode.particleScale = heartScaleFactor * 1.4
        emitterNode.particleColorBlendFactor = 1
        emitterNode.particleLifetime = lifetime

        // Position in the middle at top of the screen
        emitterNode.position = CGPoint(x: frame.size.width/2, y: frame.size.height)
        emitterNode.particlePositionRange = CGVector(dx: frame.size.width, dy: 0)

        // Fast forward the effect to start with a filled screen
        emitterNode.advanceSimulationTime(TimeInterval(lifetime))

        return emitterNode
    }

    func setupBackground() {
        let background = SKSpriteNode(color: Config.backgroundColor, size: size)
        background.texture = SKTexture(imageNamed: "BG")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -13
        addChild(background)
    }

    func setupEmitters() {
        if !Config.backgroundEmittersEnabled {
            return
        }

        var emitterNode = heartEmitter(SKColor.lightGray, heartSpeedY: 80, heartPerSecond: 0.4, heartScaleFactor: 0.07)
        emitterNode.zPosition = -10
        emitterNode.position = CGPoint(x: size.width/2,y: 0)
        addChild(emitterNode)

        emitterNode = heartEmitter(SKColor.gray, heartSpeedY: 50, heartPerSecond: 1.4, heartScaleFactor: 0.05)
        emitterNode.zPosition = -11
        emitterNode.position = CGPoint(x: size.width/2,y: 0)
        addChild(emitterNode)
        emitterNode = heartEmitter(SKColor.darkGray, heartSpeedY: 30, heartPerSecond: 2.3, heartScaleFactor: 0.03)
        emitterNode.zPosition = -12
        emitterNode.position = CGPoint(x: size.width/2,y: 0)
        addChild(emitterNode)
    }

    func presentScene(_ scene: SKScene) {
        scene.size = Config.sceneSize
        scene.scaleMode = .aspectFill
        view?.presentScene(scene, transition: Config.sceneTransition)
    }

    func showInterstitialAd() {
        var notificationName = String()
        if Config.adMobInterstitialEnabled{
        notificationName = "showAdMobInterstitialAd"
        }

        if !notificationName.isEmpty {
            if getLocalPlayCount() % Config.interstitialInterval == 0 {
                print("will request \(notificationName)")
                NotificationCenter.default.post(name: Notification.Name(rawValue: notificationName), object: self)
            }
        }
    }

    func saveRemoteHighScore(_ updatedScore: Int) {
        if GKLocalPlayer.localPlayer().isAuthenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: Config.remoteLeaderboardID)
            scoreReporter.value = Int64(updatedScore)
           // scoreReporter.value = updatedScore
            GKScore.report([scoreReporter], withCompletionHandler: ({(error: Error?) -> Void in
                if (error != nil){
                    print("Error:" + error!.localizedDescription)
                   // NSLog("unable")
                } else {
                    print("Score reported: \(scoreReporter.value)")
                   // NSLog("ok")
                }
            }))
            
            
//                        let scoreArray: [GKScore] = [scoreReporter]
//                        print("report score \(scoreReporter)")
//                        GKScore.reportScores(scoreArray, withCompletionHandler: {(error : NSError?) -> Void in
//                            if error != nil {
//                                print("error")
//                                NSLog(error!.localizedDescription)
//                            }
//                        })
        }
    }

    func saveLocalHighScore(_ score: Int) {
        let prevScore = getLocalHighScore()
        if score > prevScore {
            self.saveRemoteHighScore(score)
            let userDefaults = UserDefaults.standard
            userDefaults.set(score, forKey: Config.userDefaultsHighScoreKey)
            userDefaults.synchronize()
        }
    }

    func getLocalHighScore() -> Int {
        let userDefaults = UserDefaults.standard
        return userDefaults.integer(forKey: Config.userDefaultsHighScoreKey)
    }

    func saveLocalPlayCount(_ score: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(score, forKey: Config.userDefaultsPlayCountKey)
        userDefaults.synchronize()
    }

    func getLocalPlayCount() -> Int {
        let userDefaults = UserDefaults.standard
        return userDefaults.integer(forKey: Config.userDefaultsPlayCountKey)
    }


    func playHelloSound() {
        if Config.soundsEnabled {
            let sound:SKAction = SKAction.playSoundFileNamed(Config.helloSoundFileName, waitForCompletion: false)
            run(sound)
        }
    }

    func playTapSound() {
        if Config.soundsEnabled {
            let sound:SKAction = SKAction.playSoundFileNamed(Config.tapSoundFileName, waitForCompletion: false)
            run(sound)
        }
    }

    func playAppearSound() {
        if Config.soundsEnabled {
            let sound:SKAction = SKAction.playSoundFileNamed(Config.appearSoundFileName, waitForCompletion: false)
            run(sound)
        }
    }

    func playCollectSound() {
        if Config.soundsEnabled {
            let sound:SKAction = SKAction.playSoundFileNamed(Config.collectSoundFileName, waitForCompletion: false)
            run(sound)
        }
    }

    func playEnemySound() {
        if Config.soundsEnabled {
            let sound:SKAction = SKAction.playSoundFileNamed(Config.enemySoundFileName, waitForCompletion: false)
            run(sound)
        }
    }

    func playGameOverSound() {
        if Config.soundsEnabled {
            let sound:SKAction = SKAction.playSoundFileNamed(Config.gameOverSoundFileName, waitForCompletion: false)
            run(sound)
        }
    }

}
