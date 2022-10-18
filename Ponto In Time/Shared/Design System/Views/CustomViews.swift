/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Componentes de UI já padronizados de acordo com o projeto.
struct CustomViews {
    
    /// Cria uma nova label de acordo com a padronização do projeto
    static func newLabel(align: NSTextAlignment = .center) -> UILabel {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor = .clear
        
        lbl.textAlignment = align
        return lbl
    }
    
    
    /// Cria uma nova view de acordo com a padronização do projeto
    static func newView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }
    
    
    /// Cria um botão de acordo com a padronização do projeto
    static func newButton() -> UIButton {
        let but = UIButton()
        but.translatesAutoresizingMaskIntoConstraints = false
        
        return but
    }
    
    
    /// Cria uma imagem (view) de acordo com a padronização do projeto
    static func newImage() -> UIImageView {
        let imgV = UIImageView()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        imgV.clipsToBounds = true
        
        return imgV
    }
    
    /// Cria uma table de acordo com a padronização do projeto
    static func newTable() -> UITableView {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.backgroundColor = .systemGroupedBackground
        table.isScrollEnabled = false
        
        table.clipsToBounds = true
        table.layer.masksToBounds = true
//        table.layer.cornerRadius = 7
        
//        table.rowHeight = 45
        
        // Tirando o espaço do topo
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        
        let view = UIView(frame: frame)
        table.tableHeaderView = view
        table.tableFooterView = view
        
        // Tirando o espaço entre as seções
        table.sectionHeaderHeight = .leastNormalMagnitude
        table.sectionFooterHeight = 20
        
        table.contentInset = .zero
        
        return table
    }
 }
