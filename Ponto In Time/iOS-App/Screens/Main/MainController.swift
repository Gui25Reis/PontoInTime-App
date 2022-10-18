/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Controller \principal usada para a criação da tab bar
class MainController: UITabBarController {
    
    /* MARK: - Atributos */
    
    /// Controller da tela 01: Ver o dia
    private let menuController = MenuController()
    
    /// Controller da tela 02: Ver o hitórico
    private let historyicController = HistoricController()
        
    
    
    /* MARK: - Ciclo de Vida */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTab()
        self.setupTabBarItens()
        self.setupControllers()
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Configurações iniciais da Tab Bar
    private func setupTab() {
//        self.tabBar.backgroundColor = UIColor(.viewBack)
//        self.tabBar.tintColor = UIColor(.tabSelected)
//        self.tabBar.unselectedItemTintColor = UIColor(.tabNotSelected)
    }
    
    
    /// Define as controllers que vão aparecer na Tab Bar
    private func setupControllers() {
        self.viewControllers = [
            self.menuController,
            self.historyicController,
        ]
    }
    
    
    /// Configura os ícones e títulos de cada item da tab bar
    private func setupTabBarItens() {
        self.menuController.setupTab(text: "Seu dia", icon: .menuPage)
        self.historyicController.setupTab(text: "Histórico", icon: .historicPage)
    }
}


class MenuController: UIViewController {
    
}

class HistoricController: UIViewController {
    
}
