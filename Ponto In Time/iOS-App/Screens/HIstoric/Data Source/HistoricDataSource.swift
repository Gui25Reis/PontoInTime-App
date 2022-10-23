/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Data source das tabelas da tela de histórico
class HistoricDataSource: NSObject, TableDataCount {
    
    /* MARK: - Atributos */

    /// Dados usados no data source referente as informações do histórico
    private lazy var data: [CellData] = []
    
    
        
    /* MARK: - Protocolo */
    
    func getDataCount(for dataType: Int) -> Int {
        return self.data.count
    }
    
    
    
    /* MARK: - Encapsulamento */
        
    /* Variáveis computáveis */
    
    /// Dado que a tabela vai consumir
    public var mainData: ManagedDayWork? {
        didSet {
            self.setupDatas()
        }
    }
    
    
    
    /* MARK: - Data Source */
    
    /// Mostra quantas células vão ser mostradas
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    
    /// Configura uma célula
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoricCell.identifier, for: indexPath) as? HistoricCell else {
            return UITableViewCell()
        }
        
        let data = self.data[indexPath.row]
        cell.setupCellData(with: data)
        
        return cell
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Configura os dados da tabela
    private func setupDatas() {
        // if let data = self.mainData {
            self.data = [
                CellData(primaryText: "16.10.2022", secondaryText: "7h 57min", rightIcon: .chevron),
                CellData(primaryText: "16.10.2022", secondaryText: "7h 57min", rightIcon: .chevron),
                CellData(primaryText: "16.10.2022", secondaryText: "7h 57min", rightIcon: .chevron)
            ]
        // }
    }
}
