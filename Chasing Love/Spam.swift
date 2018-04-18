
import SpriteKit

class Spam: SKSpriteNode {

    var isCollected: Bool = false

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init () {
        let texture = SKTexture(imageNamed: Config.collectableImageName)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        shadowCastBitMask = 1
        name = Config.spamName

        physicsBody = SKPhysicsBody(circleOfRadius: texture.size().width/2 - 2)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = Config.PhysicBodyType.collectable.rawValue
        physicsBody?.contactTestBitMask = Config.PhysicBodyType.player.rawValue
        physicsBody?.collisionBitMask = 0
    }

    func collect(completion block: @escaping () -> Void) {
        let deg: CGFloat = 360
        let actionSequence = SKAction.sequence([
            SKAction.group([
                SKAction.rotate(byAngle: deg.degreesToRadians(), duration: 0.3),
                SKAction.fadeOut(withDuration: 1)
                ]),
            SKAction.removeFromParent()
            ])

        run(actionSequence, completion: { () -> Void in
            block()
        }) 
    }
}
