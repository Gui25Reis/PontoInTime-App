/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class UIKit.NSObject
import protocol UIKit.UITableViewDataSource


/// Os tipos que ficam de acordo com esse protocolo fazem parte do protocolo do data source
/// de uma tabela.
///
/// Esse protocolo adiciona o controle de quantidade de dados que uma tabela possui.
protocol TableDataCount: NSObject, UITableViewDataSource {
    
    /// Pega a quantidade de dados da tabela
    /// - Parameter dataType: tipo do dado
    /// - Returns: quantidade de dados da table
    ///
    /// O parâmetro `dataType` é em relação as tabelas que possuem mais de uma seção
    /// e possivelmente outra lista de dados.
    func getDataCount(for dataType: Int) -> Int
}
