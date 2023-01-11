/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UIView


extension UIView {
    
    /// Remove todas as subviews ligadas à view
    public func removeAllChildren() {
        self.subviews.forEach() { $0.removeFromSuperview() }
    }
}
