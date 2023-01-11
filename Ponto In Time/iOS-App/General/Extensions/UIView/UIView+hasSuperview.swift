/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UIView


extension UIView {
    
    /// Boleano que indica se possui uma superview
    public var hasSuperview: Bool {
        return self.superview != nil
    }
}
