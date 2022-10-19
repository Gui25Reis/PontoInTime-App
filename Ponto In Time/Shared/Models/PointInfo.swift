/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Informações do ponto
struct PointInfo {
    let status: StatusViewStyle?
    let title: String
    let description: String
    
    init(status: StatusViewStyle? = nil, title: String, description: String) {
        self.status = status
        self.title = title
        self.description = description
    }
}
