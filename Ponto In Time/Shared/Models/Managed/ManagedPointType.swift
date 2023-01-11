/* Gui Reis    -    gui.sreis25@gmail.com */


/// Informações sobre o tipo de ponto
struct ManagedPointType {
    let title: String
    let isDefault: Bool
    
    init(title: String, isDefault: Bool) {
        self.title = title
        self.isDefault = isDefault
    }
    
    init(title: String) {
        self.title = title
        self.isDefault = false
    }
}
