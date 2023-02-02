/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import class Foundation.FileManager
import class Foundation.NSURL
import struct Foundation.URL

import class UIKit.UIImage


extension UIImage {
    
    /// Salva uma imagem no dispositivo
    /// - Parameters:
    ///   - image: image
    ///   - name: nome do arquivo
    static func saveOnDisk(image: UIImage?, with name: String) {
        let directory = try? FileManager.default.url(
            for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false
        ) as NSURL
        
        let fileUrl = directory?.appendingPathComponent(name)
        
        let data = image?.jpegData(compressionQuality: 1)
        
        if let data, let fileUrl {
            let _ = try? data.write(to: fileUrl)
        }
    }


    /// Carrega uma imagem salva no disco que foi baixada (não são considerados os assets)
    /// - Parameter imageName: nome da imagem
    /// - Returns: imagem
    static func loadFromDisk(imageName: String) -> UIImage? {
        let dir = try? FileManager.default.url(
            for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false
        )
        
        let urlFile = dir?.absoluteString ?? ""
        let url = URL(fileURLWithPath: urlFile)
        let file = url.appendingPathComponent(imageName).path
        
        let image = UIImage(contentsOfFile: file)
        return image
    }
    
    
    /// Deleta uma imagem que foi salva no disco
    /// - Parameter imageName: nome da imagem
    /// - Returns: boleano que indica se foi apagado de fato
    static func deleteFromDisk(imageName: String) -> Bool {
        let fileUrl = try? FileManager.default.url(
            for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false
        ).deletingPathExtension()
        
        let filePath = fileUrl?.appendingPathComponent(imageName, isDirectory: false).path
        
        guard let filePath, FileManager.default.fileExists(atPath: filePath) else { return false }
        
        let delete: ()? = try? FileManager.default.removeItem(atPath: filePath)
        print("\nDeletando: \(delete != nil)")
        return delete != nil
    }
}
