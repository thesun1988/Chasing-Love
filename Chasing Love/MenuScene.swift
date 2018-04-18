

import SpriteKit

class MenuScene: SKBaseScene {

    override func didMove(to view: SKView) {
        
        setupBackground()
        setupTitle()
        setupSubtitle()
        setupEmitters()
    }

    func setupTitle() {
        let label = SKLabelNode(text: Config.gameName)
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        label.fontColor = Config.fontColor
        label.fontSize = 45
        addChild(label)
        label.alpha = 0
        label.run(SKAction.fadeIn(withDuration: 0.5))
    }

    func setupSubtitle() {
        let label = SKLabelNode(text: "")
        label.fontColor = Config.fontColor
        label.position = CGPoint(x: size.width/2, y: size.height/2 - 45)
        label.fontSize = 24
        addChild(label)

        label.alpha = 0
        label.run(SKAction.repeatForever(SKAction.sequence([SKAction.fadeIn(withDuration: 0.5), SKAction.fadeOut(withDuration: 0.5)])))
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        playTapSound()
        presentScene(GameScene())
    }

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
}

