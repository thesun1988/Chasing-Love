

import SpriteKit

class Player: SKSpriteNode {

    var isDead: Bool = false

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init () {
        let texture = SKTexture(imageNamed: Config.playerImageName)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        shadowCastBitMask = 1
        name = Config.playerName

        physicsBody = SKPhysicsBody(circleOfRadius: texture.size().width/2 - 2)
        physicsBody?.affectedByGravity = false

        physicsBody?.categoryBitMask = Config.PhysicBodyType.player.rawValue
        physicsBody?.contactTestBitMask = Config.PhysicBodyType.collectable.rawValue | Config.PhysicBodyType.enemy.rawValue
        physicsBody?.collisionBitMask = 0
    }
}

