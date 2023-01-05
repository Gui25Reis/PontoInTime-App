/* Gui Reis    -    gui.sreis25@gmail.com */


/// Os tipos que estão de acordo com esse protocolo lidam com erros que podem ocorrer
/// durante a aplicação. Esse protocolo define esses possíveis erros
protocol ErrorWarnings {
    
    /// Warnings para o usuário
    var userWarning: String { get }
    
    /// Warnings para o desenvolvedor
    var developerWarning: String { get }
}
