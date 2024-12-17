import UIKit

extension UIView{
  @IBInspectable  var cornerRadius: CGFloat {
      get {
          return self.layer.cornerRadius
      }
        set{
            self.layer.cornerRadius = newValue
        }
    }
}
