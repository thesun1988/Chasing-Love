
import SpriteKit

class GameOverScene: SKBaseScene {

    let currentScore: Int
    let highScore: Int

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(currentScore: Int, highScore: Int) {
        self.currentScore = currentScore
        self.highScore = highScore
        super.init(size: CGSize.zero)
    }

    override func didMove(to view: SKView) {
        setupBackground()
        setupEmitters()
        setupRoundedArea()
        setupTitle()
        setupScoreLabels()
        setupButtons()
    }

    func setupRoundedArea() {
        let shape = SKShapeNode()
        shape.path = UIBezierPath(roundedRect: CGRect(x: -190, y: -190, width: 380, height: 380), cornerRadius: 16).cgPath
        shape.position = CGPoint(x: frame.midX, y: frame.midY + 20)
        shape.fillColor = UIColor.concreteColor()
        shape.strokeColor = UIColor.white
        shape.lineWidth = 4
        shape.alpha = 0
        addChild(shape)

        let appearAction = SKAction.fadeAlpha(to: 1, duration: 1.0)
        appearAction.timingMode = .easeInEaseOut

        let moveToPositionAction = SKAction.moveTo(y: size.height/2, duration: 1.0)
        moveToPositionAction.timingMode = .easeInEaseOut

        shape.run(SKAction.group([appearAction, moveToPositionAction]))

    }

    func setupTitle() {
        let label = SKLabelNode(text: "It's Over")
        label.fontColor = Config.backgroundColor
        label.position = CGPoint(x: size.width/2, y: size.height/2 + 400)
        label.fontSize = 60
        addChild(label)
        label.alpha = 0

        let appearAction = SKAction.fadeAlpha(to: 1, duration: 1.0)
        appearAction.timingMode = .easeInEaseOut

        let moveToPositionAction = SKAction.moveTo(y: size.height/2 + 100, duration: 1.0)
        moveToPositionAction.timingMode = .easeInEaseOut

        label.run(SKAction.group([appearAction, moveToPositionAction]))

    }

    func setupScoreLabels() {
        var label = SKLabelNode(text: "Score")
        let offset: CGFloat = 60

        label.fontColor = Config.backgroundColor
        label.position = CGPoint(x: size.width/2 - offset, y: size.height/2 + 70)
        label.verticalAlignmentMode = .center
        label.fontSize = 36
        addChild(label)
        label.alpha = 0

        var appearAction = SKAction.fadeAlpha(to: 1, duration: 1.0)
        appearAction.timingMode = .easeInEaseOut

        var moveToPositionAction = SKAction.moveTo(y: size.height/2 + 20, duration: 1.0)
        moveToPositionAction.timingMode = .easeInEaseOut

        label.run(SKAction.group([appearAction, moveToPositionAction]))


        label = SKLabelNode(text: "\(currentScore)")
        label.fontColor = Config.backgroundColor
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: size.width/2 - offset, y: size.height/2 + 20)
        label.fontSize = 42
        addChild(label)
        label.alpha = 0

        appearAction = SKAction.fadeAlpha(to: 1, duration: 1.0)
        appearAction.timingMode = .easeInEaseOut

        moveToPositionAction = SKAction.moveTo(y: size.height/2 - 30, duration: 1.0)
        moveToPositionAction.timingMode = .easeInEaseOut

        label.run(SKAction.group([appearAction, moveToPositionAction]))

        label = SKLabelNode(text: "Best")
        label.fontColor = Config.backgroundColor
        label.position = CGPoint(x: size.width/2 + offset, y: size.height/2 + 70)
        label.verticalAlignmentMode = .center
        label.fontSize = 36
        addChild(label)
        label.alpha = 0

        appearAction = SKAction.fadeAlpha(to: 1, duration: 1.0)
        appearAction.timingMode = .easeInEaseOut

        moveToPositionAction = SKAction.moveTo(y: size.height/2 + 20, duration: 1.0)
        moveToPositionAction.timingMode = .easeInEaseOut

        label.run(SKAction.group([appearAction, moveToPositionAction]))

        label = SKLabelNode(text: "\(highScore)")
        label.fontColor = Config.backgroundColor
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: size.width/2 + offset, y: size.height/2 + 30)
        label.fontSize = 42
        addChild(label)
        label.alpha = 0

        appearAction = SKAction.fadeAlpha(to: 1, duration: 1.0)
        appearAction.timingMode = .easeInEaseOut

        moveToPositionAction = SKAction.moveTo(y: size.height/2 - 30, duration: 1.0)
        moveToPositionAction.timingMode = .easeInEaseOut

        label.run(SKAction.group([appearAction, moveToPositionAction]))
    }

    func setupButtons() {
        let offset: CGFloat = 130

        var button = SKSpriteNode(imageNamed: Config.replayButtonImageName)
        button.position = CGPoint(x: size.width/2 - 120, y: size.height/2 - 80)
        button.xScale = 0.4
        button.yScale = 0.4
        addChild(button)
        button.alpha = 0
        button.name = Config.replayButtonName

        var appearAction = SKAction.fadeAlpha(to: 0.9, duration: 1.0)
        appearAction.timingMode = .easeInEaseOut

        var moveToPositionAction = SKAction.moveTo(y: size.height/2 - offset, duration: 1.0)
        moveToPositionAction.timingMode = .easeInEaseOut

        button.run(SKAction.group([appearAction, moveToPositionAction]))


        button = SKSpriteNode(imageNamed: Config.rateUsButtonImageName)
        button.position = CGPoint(x: size.width/2 + 120, y: size.height/2 - 80)
        button.xScale = 0.4
        button.yScale = 0.4
        addChild(button)
        button.alpha = 0
        button.name = Config.rateUsButtonName

        appearAction = SKAction.fadeAlpha(to: 0.9, duration: 1.0)
        appearAction.timingMode = .easeInEaseOut

        moveToPositionAction = SKAction.moveTo(y: size.height/2 - offset, duration: 1.0)
        moveToPositionAction.timingMode = .easeInEaseOut

        button.run(SKAction.group([appearAction, moveToPositionAction]))

        button = SKSpriteNode(imageNamed: Config.gameCenterButtonImageName)
        button.position = CGPoint(x: size.width/2 - 40, y: size.height/2 - 80)
        button.xScale = 0.4
        button.yScale = 0.4
        addChild(button)
        button.alpha = 0
        button.name = Config.gameCenterButtonName

        appearAction = SKAction.fadeAlpha(to: 0.9, duration: 1.0)
        appearAction.timingMode = .easeInEaseOut

        moveToPositionAction = SKAction.moveTo(y: size.height/2 - offset, duration: 1.0)
        moveToPositionAction.timingMode = .easeInEaseOut

        button.run(SKAction.group([appearAction, moveToPositionAction]))

        button = SKSpriteNode(imageNamed: Config.shareButtonImageName)
        button.position = CGPoint(x: size.width/2 + 40, y: size.height/2 - 80)
        button.xScale = 0.4
        button.yScale = 0.4
        addChild(button)
        button.alpha = 0
        button.name = Config.shareButtonName

        appearAction = SKAction.fadeAlpha(to: 0.9, duration: 1.0)
        appearAction.timingMode = .easeInEaseOut

        moveToPositionAction = SKAction.moveTo(y: size.height/2 - offset, duration: 1.0)
        moveToPositionAction.timingMode = .easeInEaseOut

        button.run(SKAction.group([appearAction, moveToPositionAction]))

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let touch: UITouch = touches.first else {
            return
        }

        let location = touch.location(in: self)

        if let replayNode: SKSpriteNode = childNode(withName: Config.replayButtonName) as? SKSpriteNode {
            if replayNode.contains(location) {
                presentScene(GameScene())
            }
        }

        if let rateNode: SKSpriteNode = childNode(withName: Config.rateUsButtonName) as? SKSpriteNode {
            if rateNode.contains(location) {
                if let url = URL(string: Config.rateUrl) {
                    UIApplication.shared.openURL(url)
                }
            }
        }

        if let gameCenterNode: SKSpriteNode = childNode(withName: Config.gameCenterButtonName) as? SKSpriteNode {
            if gameCenterNode.contains(location) {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "showLeaderboard"), object: nil)
            }
        }

        if let shareNode: SKSpriteNode = childNode(withName: Config.shareButtonName) as? SKSpriteNode {
            if shareNode.contains(location) {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "shareScore"), object: nil)
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
}
