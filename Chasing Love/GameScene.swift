

import SpriteKit

enum GameState {
    case initial, intro, tutorial, running, over
}

class GameScene: SKBaseScene, SKPhysicsContactDelegate {

    var player: Player = Player()
    var gameState: GameState = .initial

    var lastArrowTime: TimeInterval = 0

    var background: SKSpriteNode = SKSpriteNode()

    var tipLabel: SKLabelNode = SKLabelNode()
    var scoreLabel: SKLabelNode = SKLabelNode()

    var tapCount: Int = 0
    var score: Int = 0

    var numbersOfEnemyToSpawn = Config.initialNumberOfEnemiesToSpawn

    
    func setupPlayer(completion block: @escaping () -> Void) {
        player.xScale = Config.playerScale
        player.yScale = Config.playerScale
        player.position = CGPoint(x:frame.midX, y:frame.minY)
        player.shadowCastBitMask = 1
        addChild(player)

       

        let appearAction = SKAction.moveTo(y: player.size.height * 2, duration: 0.8)
        appearAction.timingMode = .easeInEaseOut

        let waitAction = SKAction.wait(forDuration: 0.2)

        let moveToCenterAction = SKAction.moveTo(y: frame.midY, duration: 0.8)
        moveToCenterAction.timingMode = .easeInEaseOut

        let jumpAction = SKAction.jumpToHeight(100, duration: 0.8, originalPosition: CGPoint(x: frame.midX, y: player.size.height * 2))

        let pulsateAction = SKAction.repeatForever(SKAction.sequence([
            SKAction.scale(to: 0.65, duration: 0.3),
            SKAction.scale(to: 0.5, duration: 0.1)
            ]))
        pulsateAction.timingMode = .easeInEaseOut


        let actionsSequence = SKAction.sequence([appearAction, waitAction, jumpAction, waitAction, moveToCenterAction])
        player.run(actionsSequence, completion: { () -> Void in
            self.player.run(pulsateAction)
            self.playHelloSound()
            block()
        }) 

    }


    func setupScoreLabel() {
        scoreLabel.text = "\(score)"
        scoreLabel.fontColor = Config.fontColor
        scoreLabel.fontSize = Config.scoreLabelSize
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height/2 - player.size.height * 2)
        scoreLabel.zPosition = -1
        scoreLabel.alpha = 0
        addChild(scoreLabel)

        let appearAction = SKAction.fadeAlpha(to: Config.scoreLabelAlpha, duration: Config.scoreLabelFadeSpeed)
        appearAction.timingMode = .easeInEaseOut

        let moveToPositionAction = SKAction.moveTo(y: size.height/2, duration: Config.scoreLabelFadeSpeed)
        moveToPositionAction.timingMode = .easeInEaseOut

        scoreLabel.run(SKAction.group([appearAction, moveToPositionAction]))
    }


    override func didMove(to view: SKView) {

        physicsWorld.contactDelegate = self

        setupBackground()
        setupEmitters()

        gameState = .intro

        setupPlayer() {
                self.score = 0
                self.setupScoreLabel()
                self.createCollectable()
                self.gameState = .running
            //}
        }

        saveLocalPlayCount(getLocalPlayCount() + 1)
    }

    func movePlayerToPosition(_ position: CGPoint) {
        player.removeAction(forKey: "moveActionKey")
        let distance = player.position.distanceTo(position)
        let duration = TimeInterval(distance / Config.playerSpeed)
        let moveAction = SKAction.move(to: position, duration: duration)
        moveAction.timingMode = .easeInEaseOut
        player.run(moveAction)

    }


    func createCollectable() {

        let collectable = Spam()
        let x = CGFloat.random(min: size.width/2 + 10 - view!.frame.width/2, max: size.width/2 - 10 + view!.frame.width/2)
        let y = CGFloat.random(min: size.height/2 + 50 - view!.frame.height/2, max: size.height/2 - 10 + view!.frame.height/2)

        collectable.position = CGPoint(x: x, y: y)
        collectable.xScale = 0
        collectable.yScale = 0

        addChild(collectable)

        let deg: CGFloat = 360
        let scale = CGFloat.random(min: 0.2, max: 0.3)


        collectable.run(SKAction.scale(to: scale, duration: Config.collectableScaleTime))
        collectable.run(SKAction.repeatForever(SKAction.rotate(byAngle: deg.degreesToRadians(), duration: Config.collectableRotateTime)))
        playAppearSound()
    }

    func createEnemyStartingPoint() -> CGPoint {
        let side = Int.random(min: 1, max: 4)

        var x: CGFloat,
        y: CGFloat

        if side == 1 { // top
            y = frame.maxY
            x = CGFloat.random(min: frame.minX, max: frame.maxX)
            return CGPoint(x: x, y: y)
        } else if side == 2 { // bottom
            y = frame.minY
            x = CGFloat.random(min: frame.minX, max: frame.maxX)
            return CGPoint(x: x, y: y)
        } else if side == 3 { // left
            y = CGFloat.random(min: frame.minY, max: frame.maxY)
            x = frame.minX
            return CGPoint(x: x, y: y)
        } else { // right
            y = CGFloat.random(min: frame.minY, max: frame.maxY)
            x = frame.maxX
            return CGPoint(x: x, y: y)
        }
    }

    func spawnEnemies() {
        for _ in 0...numbersOfEnemyToSpawn - 1 {
            let enemy = Enemy()
            enemy.position = createEnemyStartingPoint()

            let offset = player.position - enemy.position
            let direction = offset.normalized()
            let factor = direction * 2000
            let destination = factor + enemy.position

            let scale = CGFloat.random(min: 0.3, max: 0.6)
            enemy.xScale = scale
            enemy.yScale = scale
            enemy.shadowCastBitMask = 1
            addChild(enemy)

            
            let deg:CGFloat = atan2(direction.y,direction.x)
            
            
            enemy.zRotation = deg
          
            
            enemy.run(SKAction.sequence([
                SKAction.move(to: destination, duration: Config.enemyMovementSpeed),
                SKAction.removeFromParent()
                ]))
        }
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch: UITouch = touches.first else {
            return
        }

        if gameState == .running || gameState == .tutorial {
            tapCount += 1
            playTapSound()
            let location = touch.location(in: self)
            movePlayerToPosition(location)

      }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch: UITouch = touches.first else {
            return
        }

        if gameState == .running || gameState == .tutorial {
            let location = touch.location(in: self)
            movePlayerToPosition(location)
        }

    }

    func didBegin(_ contact: SKPhysicsContact) {

        var body: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body = contact.bodyB
        } else {
            body = contact.bodyA
        }

        if gameState == .running && body.categoryBitMask == Config.PhysicBodyType.collectable.rawValue {
            if let collectable: Spam = body.node as? Spam {
                if !collectable.isCollected {
                    collectable.isCollected = true
                    self.playCollectSound()
                    self.score += 1
                    self.scoreLabel.text = "\(self.score)"
                    if self.score % Config.amountOfEnemiesIncreasesEachScore == 0 {
                        self.numbersOfEnemyToSpawn += 1
                    }
                    collectable.collect() {
                        self.createCollectable()
                    }
                }
            }
        } else if gameState == .running && body.categoryBitMask == Config.PhysicBodyType.enemy.rawValue {
            if let enemy: Enemy = body.node as? Enemy {
                if self.player.intersects(enemy) && !self.player.isDead {
                    self.player.isDead = true
                    self.gameState = .over
                    self.playGameOverSound()
                    self.setupGameOverScene()
                }
            }
        }
    }

    func setupGameOverScene() {

        let deg: CGFloat = 360
        let rotateAction = SKAction.rotate(byAngle: deg.degreesToRadians(), duration: Config.gameOverRotateSpeed)
        let fadeOutAction = SKAction.fadeOut(withDuration: Config.gameOverFadeoutSpeed)
        let scaleOutAction = SKAction.scale(to: 2.0, duration: Config.gameOverScaleSpeed)
        let actionGroup = SKAction.group([rotateAction, fadeOutAction, scaleOutAction])

        saveLocalHighScore(score)
        showInterstitialAd()

        player.run(actionGroup, completion: { () -> Void in
            self.presentScene(GameOverScene(currentScore: self.score, highScore: self.getLocalHighScore()))
        }) 
    }

    func updateEnemiesState() {
        lastArrowTime += dt
 
        if lastArrowTime * 1000 > Config.maxEnemyWaitingTime {
            spawnEnemies()
            lastArrowTime = 0
        } else if lastArrowTime * 1000 > Config.minEnemyWaitingTime {
            let r = Int.random(min: 1, max: 2)
            if r == 1 {
                spawnEnemies()
            }
            lastArrowTime = 0
        }

        enumerateChildNodes(withName: Config.enemyName) {
            node, stop in
        }
    }


    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if gameState == .running {
            updateEnemiesState()
        }
    }
}
