/* Gui Reis    -    gui.sreis25@gmail.com */


/// Os tipos que estão de acordo com esse protocolo são views que possuem uma tabela
protocol ViewHasTable {
    
    /// Tabela princiapal
    var mainTable: CustomTable { get set }
}


extension ViewHasTable {
    
    /// Define o delegate e data source da collection
    internal func reloadTableData() {
        self.mainTable.reloadData()
        self.mainTable.reloadInputViews()
    }
    
    
    /// Configura quem vai lidar com o delegate e data source da table
    /// - Parameter handler: handler da table
    internal func setTableHandler(with handler: TableHandler) {
        self.mainTable.delegate = handler
        self.mainTable.dataSource = handler
    }
}