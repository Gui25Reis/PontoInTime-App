/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import protocol UIKit.UITableViewDelegate


/// Os tipos que estão de acordo com esse protocolo são view que possuem ao menos
/// uma tableview.
protocol ViewWithTable {
    
    /// Configura o delegate na tabela
    /// - Parameter delegate: delegate
    func setDelegate(with delegate: UITableViewDelegate)
    
    
    /// Configura o data source da tabela
    /// - Parameter dataSource: data source
    func setDataSource(with dataSource: TableDataCount)
    
    
    /// Atualiza os dados da tabela
    func reloadTableData()
}
