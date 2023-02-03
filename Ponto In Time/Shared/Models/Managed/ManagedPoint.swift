/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import struct Foundation.UUID


/// Informações de um ponto
struct ManagedPoint: Equatable {
    
    /* MARK: - Atributos */
    
    let uuid: UUID
    var status: String
    var time: String
    var files: [ManagedFiles]
    var pointType: ManagedPointType
    
    
    
    /* MARK: - Construtores */
    
    init(uuid: UUID, status: String, time: String, files: [ManagedFiles], pointType: ManagedPointType) {
        self.uuid = uuid
        self.status = status
        self.time = time
        self.files = files
        self.pointType = pointType
    }
    
    
    init(status: String, time: String, files: [ManagedFiles], pointType: ManagedPointType) {
        self.uuid = UUID()
        self.status = status
        self.time = time
        self.files = files
        self.pointType = pointType
    }
    
    
    
    /* MARK: - Métodos */
    
    static func == (lhs: ManagedPoint, rhs: ManagedPoint) -> Bool {
        return (
            lhs.status == rhs.status &&
            lhs.time == rhs.time &&
            lhs.pointType.title == rhs.pointType.title
        )
    }
}
