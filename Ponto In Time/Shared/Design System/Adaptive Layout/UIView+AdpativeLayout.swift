/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UIView
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGSize


extension UIView: AdaptiveLayout {
    
    internal func getEquivalent(_ space: CGFloat, dimension: Dimension = .width) -> CGFloat {
        return self.getEquivalent(space, sizeProporsion: SizeInfo(screen: .view, dimension: dimension))
    }
    
        
    internal func getEquivalent(_ space: CGFloat, sizeProporsion: SizeInfo? = nil, screenReference: SizeInfo? = nil) -> CGFloat {
        let reference: SizeInfo = {
            if let screenReference = screenReference {
                return screenReference
            }
            if let sizeProporsion = sizeProporsion {
                return SizeInfo(screen: .iPhone12, dimension: sizeProporsion.dimension)
            }
            return SizeInfo(screen: .iPhone12, dimension: .width)
        }()
        
        let proportion: SizeInfo = {
            if let sizeProporsion = sizeProporsion {
                return sizeProporsion
            }
            if let screenReference = screenReference {
                return SizeInfo(screen: .view, dimension: screenReference.dimension)
            }
            return SizeInfo(screen: .view, dimension: .width)
        }()
        
        let screenValue: CGFloat = self.getScreenDimension(for: reference)
        let proportionValue: CGFloat = self.getScreenDimension(for: proportion)
        
        // self.bounds.height * 0.1
        return proportionValue * (space / screenValue)
    }
    
    
    internal func getScreenSize(from screen: Screens) -> CGSize {
        return screen == .view ? self.bounds.size : screen.size
    }
    
    
    
    internal func getScreenDimension(for info: SizeInfo) -> CGFloat {
        let screenSize: CGSize = {
            switch info.screenType == .custom {
            case true: return info.screenSize
            case false: return self.getScreenSize(from: info.screenType)
            }
        }()
        
        switch info.dimension {
        case .width: return screenSize.width
        case .height: return screenSize.height
        }
    }
}
