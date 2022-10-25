/* Gui Reis    -    gui.sreis25@gmail.com */


/// Lida com os arquivos salvos no core data
class FilesCDManager {
    
    /* MARK: - Atributos */

    /// Protocolo do core data
    public weak var coreDataProperties: CoreDataProperties?


    
    /* MARK: - Métodos (Públicos) */
    
    /// Cria um novo dado
    /// - Parameter data: dado que vai ser criado
    /// - Returns: retorna o modelo criado
    public func createIfNeeded(with data: ManagedFiles) -> DBFiles? {
        guard let coreDataProperties else { return nil }
        
        let newData = DBFiles(context: coreDataProperties.mainContext)
        newData.link = data.link
        newData.name = data.name
        
        return newData
    }
    
    
    /// Transforma a entidade do core date para o modelo (struct)
    /// - Parameter entity: a entidade
    /// - Returns: modelo
    static func transformToModel(entity: DBFiles) -> ManagedFiles {
        return ManagedFiles(
            link: entity.link,
            name: entity.name
        )
    }
}
