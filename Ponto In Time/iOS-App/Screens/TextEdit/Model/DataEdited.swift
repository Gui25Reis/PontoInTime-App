/* Gui Reis    -    gui.reis25@gmail.com */


/// Modelo de dados usado para mostrar o que foi feito na tela de edição/alteração de
/// um texto (tela de textEdit)
struct DataEdited {
    
    /* MARK: - Atributos */
    
    /// Dado antigo
    var oldData: String?
    
    /// Novo dado (editado)
    var newData: String?
    
    /// Boleano que indica se o dado foi deletado
    var hasDeleted: Bool
    
    /// Boleano que indica se foi feita uma mudança
    var hasChanges: Bool {
        return self.oldData != self.newData
    }
    
    /// Boleano que indica se está adicionando um novo dado
    var isAdding: Bool {
        return self.oldData == nil
    }
    
    
    
    /* MARK: - Construtores */
    
    init() {
        self.oldData = nil
        self.newData = nil
        self.hasDeleted = false
    }
    
    
    init(oldData: String?, newData: String?) {
        self.oldData = oldData
        self.newData = newData
        self.hasDeleted = false
    }
    
    
    init(oldData: String?, hasDeleted: Bool) {
        self.oldData = oldData
        self.newData = nil
        self.hasDeleted = hasDeleted
    }
}
