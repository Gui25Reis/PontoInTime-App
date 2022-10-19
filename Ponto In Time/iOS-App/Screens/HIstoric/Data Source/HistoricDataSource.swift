/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit



/// Data source das collections da página de menu
class HistoricDataSource: NSObject, TableDataCount {
    
    /* MARK: - Atributos */

    /// Dados usados no data source referente as informações do histórico
    public lazy var data: [CellData] = [
        CellData(primaryText: "16.10.2022", secondaryText: "7h 57min"),
        CellData(primaryText: "16.10.2022", secondaryText: "7h 57min"),
        CellData(primaryText: "16.10.2022", secondaryText: "7h 57min")
    ]
    
        
    
    /* MARK: - Protocolo */
    
    func getDataCount(for dataType: Int) -> Int {
        return self.data.count
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
        cell.setupCell(with: data)
        
        return cell
    }
}
