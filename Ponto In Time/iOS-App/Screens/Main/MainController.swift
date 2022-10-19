/* Gui Reis    -    guis.reis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit


/// Controller principal usada para a criação da tab bar
class MainController: UITabBarController {
    
    /* MARK: - Atributos */
    
    /// Controller da tela 01: Ver o dia
    private let menuController = MenuController()
    
    /// Controller da tela 02: Ver o histórico
    private let historicController = HistoricController()
        
    
    
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
        self.tabBar.backgroundColor = UIColor(.safeAreaColor)?.withAlphaComponent(0.95)
    }
    
    
    /// Define as controllers que vão aparecer na Tab Bar
    private func setupControllers() {
        self.viewControllers = [
            self.getNavigation(for: self.menuController),
            self.getNavigation(for: self.historicController),
        ]
    }
    
    
    /// Configura os ícones e títulos de cada item da tab bar
    private func setupTabBarItens() {
        self.menuController.setupTab(text: "Seu dia", icon: .menuPage)
        self.historicController.setupTab(text: "Histórico", icon: .historicPage)
    }
    
    
    private func getNavigation(for controller: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: controller)
        nav.navigationBar.prefersLargeTitles = true
//        nav.navigationBar.backgroundColor = UIColor(.safeAreaColor)
//        nav.navigationBar.tintColor = UIColor(.safeAreaColor)
        return nav
    }
}
