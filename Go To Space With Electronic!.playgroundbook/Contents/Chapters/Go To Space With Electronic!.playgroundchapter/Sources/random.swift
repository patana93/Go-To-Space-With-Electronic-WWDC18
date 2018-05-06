import UIKit

public func random(min: CGFloat, max: CGFloat) -> CGFloat {
  return CGFloat(Float(arc4random()) / Float(0xFFFFFFFF))
    * (max - min) + min
}
