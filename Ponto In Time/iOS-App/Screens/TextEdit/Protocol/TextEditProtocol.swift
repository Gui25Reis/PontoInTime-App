/* Gui Reis    -    gui.reis25@gmail.com */


/// Os tipos que estão de acordo com esse protocolo possuem uma célula na table da view
/// que abre uma tela para edição de uma informação
protocol TextEditProtocol {
    
    /// Salva o valor que foi editado
    /// - Parameter data: dado editado
    func dataEditHandler(data: DataEdited)
}
