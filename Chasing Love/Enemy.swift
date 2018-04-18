

import SpriteKit

class Enemy: SKSpriteNode {

    var isDead: Bool = false

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init () {
        let texture = SKTexture(imageNamed: Config.enemyImageName)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        shadowCastBitMask = 1
        name = Config.enemyName

        physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        //physicsBody = SKPhysicsBody(circleOfRadius: texture.size().width/2 - 2)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = Config.PhysicBodyType.enemy.rawValue
        physicsBody?.contactTestBitMask = Config.PhysicBodyType.player.rawValue
        physicsBody?.collisionBitMask = 0
    }
}
