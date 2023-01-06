/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import protocol UIKit.UITableViewDelegate
import protocol UIKit.UITableViewDataSource
import UIKit

/// Os tipos que estão de acordo com esse protocolo lidam com o funcionamento de uma table,
/// tanto o delegate quanto o data source dela
///
/// Esse protocolo adiciona o controle de quantidade de dados que uma tabela possui.
protocol TableHandler: UITableViewDataSource, UITableViewDelegate {
    
    /// Pega a quantidade de dados da tabela
    /// - Parameter dataType: tipo do dado
    /// - Returns: quantidade de dados da tabela
    ///
    /// O parâmetro `dataType` é em relação as tabelas que possuem mais de uma seção
    /// e possivelmente outra lista de dados.
    func getDataCount(for dataType: Int) -> Int
    
    
    /// Registra uma célula
    /// - Parameter table: tabela que vai ser registrada
    func registerCell(in table: CustomTable)
}

extension TableHandler {
    
    /// Linka o data source e delegate com a tabela
    /// - Parameter view: view que possui uma tabela
    ///
    /// Essa função também faz o registro da célula
    func link(with view: ViewHasTable) {
        self.registerCell(in: view.mainTable)
        view.mainTable.setupTableHadler(with: self)
    }
}
