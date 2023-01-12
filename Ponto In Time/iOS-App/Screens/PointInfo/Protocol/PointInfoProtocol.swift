/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import struct Foundation.IndexPath
import class Foundation.NSObject
import class UIKit.UIMenu
import class UIKit.UIActivityViewController


/// Os tipos que estão de acordo com esse protocolo são controllers da tela de infomações de um ponto
protocol PointInfoProtocol: NSObject {
    
    /// Atualiza a hora que o picker foi definido
    /// - Parameter time: hora do picker
    func updateTimeFromPicker(for time: String)
    
    
    /// Abre o menu de seleção para escolher a imagem
    func openFilePickerSelection()
    
    
    /// Ação de deletar um arquivo
    func deleteFileAction()
    
    
    /// Ação de mostrar a tela de compartilhar
    func openShareMenu(_ menu: UIActivityViewController)
    
    
    /// Ação de mostrar a tela de compartilhar
    func updateMenuData(at index: Int, data: String)
}
