/* Gui Reis    -    gui.sreis25@gmail.com */


/// Informações de um ponto
struct ManagedPoint: Equatable {
    var status: String
    var time: String
    var files: [ManagedFiles]
    var pointType: ManagedPointType
    
    static func == (lhs: ManagedPoint, rhs: ManagedPoint) -> Bool {
        return (
            lhs.status == rhs.status &&
            lhs.time == rhs.time &&
            lhs.pointType.title == rhs.pointType.title
        )
    }
}
