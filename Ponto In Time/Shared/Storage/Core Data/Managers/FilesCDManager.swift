/* Gui Reis    -    gui.sreis25@gmail.com */

import CoreData

/// Lida com os arquivos salvos no core data
class FilesCDManager {
    
    /* MARK: - Atributos */

    /// Protocolo do core data
    public weak var coreDataProperties: CoreDataProperties?


    
    /* MARK: - Métodos (Públicos) */
    
    /// Deleta um ponto
    /// - Parameter data: dado que vai ser deletado
    /// - Returns: possível erro
    public func deleteFiles(with data: [ManagedFiles]) -> ErrorCDHandler? {
        guard let file = self.check(data: data) else { return .dataNotFound }
        
        guard let coreDataProperties else { return .protocolNotSetted }
        coreDataProperties.mainContext.delete(file)
        
        let save = try? coreDataProperties.saveContext()
        return save
    }
    
    
    /// Cria um novo dado
    /// - Parameter data: dado que vai ser criado
    /// - Returns: retorna o modelo criado
    public func createIfNeeded(with data: ManagedFiles) -> DBFiles? {
        if let oldData = self.check(data: [data]) { return oldData }
        guard let coreDataProperties else { return nil }
        
        let newData = DBFiles(context: coreDataProperties.mainContext)
        newData.link = data.link
        newData.name = data.name
        
        return newData
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Cria um dado (caso não exista) a partir das informações passadas
    /// - Parameter data: informações do novo dado
    /// - Returns: modelo do dado
    private func check(data: [ManagedFiles]) -> DBFiles? {
        let fetch = DBFiles.fetchRequest()
        
        var filter = ""
        if data.count == 1 {
            filter = "%K == '\(data[0].link)'"
        } else {
            filter = self.createFilter(with: data)
        }
        
        fetch.predicate = NSPredicate(format: filter, #keyPath(DBFiles.link))
        fetch.fetchLimit = 1
        
        return try? self.coreDataProperties?.mainContext.fetch(fetch).first
    }
    
    
    /// Cria o filtro a partir de uma quantidade de dados
    /// - Parameter datas: conjunto dados
    /// - Returns: string para o filtro
    private func createFilter(with datas: [ManagedFiles]) -> String {
        var filter = ""
        datas.forEach() {
            if filter != "" { filter += " || " }
            filter += "%K == '\($0.link)'"
        }
        
        return filter
    }
    
    
    
    /* MARK: - Singleton */
    
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
