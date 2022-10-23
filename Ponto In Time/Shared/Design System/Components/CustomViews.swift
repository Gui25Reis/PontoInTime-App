/* Gui Reis    -    gui.sreis25@gmail.com */

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

        
    /// Cria uma imagem (view) de acordo com a padronização do projeto
    static func newImage() -> UIImageView {
        let imgV = UIImageView()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        imgV.clipsToBounds = true
        
        return imgV
    }
    
    
    /// Cria uma imagem (view) de acordo com a padronização do projeto
    static func newSwitch() -> UISwitch {
        let swit = UISwitch()
        swit.translatesAutoresizingMaskIntoConstraints = false
        
        return swit
    }
    
    
    /// Cria um picker de data de acordo com a padronização do projeto
    static func newDataPicker(mode: UIDatePicker.Mode) -> UIDatePicker {
        let date = UIDatePicker()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.preferredDatePickerStyle = .compact
        date.datePickerMode = mode
        date.minuteInterval = 1
        date.locale = .current
        
        return date
    }
 }
