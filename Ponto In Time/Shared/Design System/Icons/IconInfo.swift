/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import struct CoreGraphics.CGFloat
import class UIKit.UIImage


/// Configurações do ícone de um botão (UIButton)
struct IconInfo{
    let icon: AppIcons
    let size: CGFloat
    let weight: UIImage.SymbolWeight
    let scale: UIImage.SymbolScale
}
