/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.UIImage
import class Foundation.NSObject


/// Os tipos que estão de acordo com esse protocolo são instâncias que lida com o resultado
/// obtido de algum tipo de seleção feita pelo `DocumentsHandler`
protocol DocumentsHandlerDelegate: NSObject {
    
    /// Lida com o documento que foi selecionado
    /// - Parameters:
    ///   - document: documento selecionado
    ///   - image: imagem do documento
    func documentSelected(_ document: ManagedFiles?, image: UIImage?)
}
