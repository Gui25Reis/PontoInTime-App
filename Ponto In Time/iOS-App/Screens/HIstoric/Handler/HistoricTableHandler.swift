/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Lida (handler) com a tabela da tela de histórico
class HistoricTableHandler: NSObject, TableHandler {
    
    /* MARK: - Atributos */

    /// Dados usados no data source referente as informações do histórico
    private lazy var data: [TableData] = []
    
    
        
    /* MARK: - Protocolo */
    
    func getDataCount(for dataType: Int) -> Int {
        return self.data.count
    }
    
    
    func registerCell(in table: CustomTable) {
        table.registerCell(for: HistoricCell.self)
    }
    
    
    
    /* MARK: - Encapsulamento */
        
    /* Variáveis computáveis */
    
    /// Dado que a tabela vai consumir
    public var mainData: ManagedDayWork? {
        didSet { self.setupDatas() }
    }
    
    
    
    /* MARK: - Data Source */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoricCell.identifier, for: indexPath) as? HistoricCell
        
        let data = self.data[indexPath.row]
        cell?.tableData = data
        
        return cell ?? UITableViewCell()
    }
    
    
    
    /* MARK: - Delegate */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadInputViews()
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Configura os dados da tabela
    private func setupDatas() {
//        guard let data = self.mainData else { return }
        self.data = [
            TableData(primaryText: "16.10.2022", secondaryText: "7h 57min", rightIcon: .chevron),
            TableData(primaryText: "16.10.2022", secondaryText: "7h 57min", rightIcon: .chevron),
            TableData(primaryText: "16.10.2022", secondaryText: "7h 57min", rightIcon: .chevron)
        ]
    }
}
