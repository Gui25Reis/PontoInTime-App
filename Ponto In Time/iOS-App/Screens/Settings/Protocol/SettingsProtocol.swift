/* Gui Reis    -    gui.reis25@gmail.com */

/* Bibliotecas necessárias: */
import class Foundation.NSObject


/// Os tipo que está de acordo com esse protocol a controller da tela de configurações
protocol SettingsProtocol: NSObject {
    
    /// Ação de copiar um texto
    /// - Parameter text: texto que vai ser copiado
    func copyAction(with text: String)
    
    
    /// Abre a páginad e edição para célula
    /// - Parameter data: dado que vao ser editado
    func openTextEditPage(for data: TextEditData)
}
