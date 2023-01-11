/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UIImage
import class UIKit.UIViewController


extension UIViewController {
    
    /// Configura o item da tab bar da controller
    /// - Parameters:
    ///   - text: título na tab bar
    ///   - icon: icone na tab bar
    internal func setupTab(text: String, icon: AppIcons) {
        self.title = text
        self.tabBarItem.title = text
        self.tabBarItem.image = UIImage(icon)
    }
}
