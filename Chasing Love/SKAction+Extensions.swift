

import SpriteKit

public extension SKAction {

    public class func afterDelay(_ delay: TimeInterval, performAction action: SKAction) -> SKAction {
        return SKAction.sequence([SKAction.wait(forDuration: delay), action])
    }

    public class func afterDelay(_ delay: TimeInterval, runBlock block: @escaping ()->()) -> SKAction {
        return SKAction.afterDelay(delay, performAction: SKAction.run(block))
    }

    public class func removeFromParentAfterDelay(_ delay: TimeInterval) -> SKAction {
        return SKAction.afterDelay(delay, performAction: SKAction.removeFromParent())
    }

    public class func jumpToHeight(_ height: CGFloat, duration: TimeInterval, originalPosition: CGPoint) -> SKAction {
        return SKAction.customAction(withDuration: duration) {(node, elapsedTime) in
            let fraction = elapsedTime / CGFloat(duration)
            let yOffset = height * 4 * fraction * (1 - fraction)
            node.position = CGPoint(x: originalPosition.x, y: originalPosition.y + yOffset)
        }
    }
}

