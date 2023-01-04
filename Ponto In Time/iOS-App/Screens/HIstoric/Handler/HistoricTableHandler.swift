/* Macro - Grupo 05 */

/* Bibliotecas necessárias: */
import UIKit


class HistoricTableHandler: NSObject, TableHandler {
    
    /* MARK: - Atributos */

    /// Dados usados no data source referente as informações do histórico
    private lazy var data: [TableCellData] = []
    
    
        
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoricCell.identifier, for: indexPath) as? HistoricCell
        else { return UITableViewCell() }
        
        let data = self.data[indexPath.row]
        cell.setupCellData(with: data)
        
        return cell
    }
    
    
    
    /* MARK: - Delegate */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadInputViews()
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Configura os dados da tabela
    private func setupDatas() {
        // if let data = self.mainData {
            self.data = [
                TableCellData(primaryText: "16.10.2022", secondaryText: "7h 57min", rightIcon: .chevron),
                TableCellData(primaryText: "16.10.2022", secondaryText: "7h 57min", rightIcon: .chevron),
                TableCellData(primaryText: "16.10.2022", secondaryText: "7h 57min", rightIcon: .chevron)
            ]
        // }
    }
}
