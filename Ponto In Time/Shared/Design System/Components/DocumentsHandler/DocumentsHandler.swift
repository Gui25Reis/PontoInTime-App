/* Gui Reis    -    gui.sreis25@gmail.com */

/* Bibliotecas necessárias: */
import UIKit
import PhotosUI
import PDFKit


/// Classe que lida com a seleção de arquivos
class DocumentsHandler: NSObject, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {
    
    /* MARK: - Atributos */
    
    /// Nome do arquivo (para salvar)
    private var fileName: String {
        var date = Date().getDateFormatted(with: .asset)
        let name = "PointInTime-\(date)"
        return name
    }
    
    
    
    /* MARK: - Construtor */
    
    override init() {}
    
    
    
    /* MARK: - Encapsulamento */
    
    /// Protocolo de comunicação com o objeto que instanciou a classe
    public weak var delegate: DocumentsHandlerDelegate?
    
    
    /// Cria a controller responsável pelo tipo da seleção
    /// - Parameter type: tipo de seleção
    /// - Returns: controller da tela (caso nào tenha erros)
    public func createPicker(for type: PickerType) -> UIViewController? {
        switch type {
        case .camera:
            return self.createCameraPicker()
        case .photos:
            return self.createPhotoPicker()
        case .files:
            return self.creatDocumentPicker()
        }
    }
    
    
    
    /* MARK: - Delegates */
    
    /* MARK: (Documentos) UIDocumentPickerDelegate */
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return self.dismissPicker(controller, isDataNil: true) }
        
        let image = self.getPDFThumbnail(for: url)
        self.sendData(with: image)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.dismissPicker(controller, isDataNil: true)
    }
    
    
    
    /* MARK: (Álbum de fotos) PHPickerViewControllerDelegate */
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard let asset = results.first?.itemProvider, asset.canLoadObject(ofClass: UIImage.self)
        else { return self.dismissPicker(picker, isDataNil: true) }
        
        var data: ManagedFiles? = nil
        var image: UIImage? = nil
        
        let group = DispatchGroup()
        group.enter()
        asset.loadObject(ofClass: UIImage.self) { image, _ in
            defer { group.leave() }
            guard let image = image as? UIImage else { return }
            
            let fileName = self.fileName
            data = ManagedFiles(link: fileName, name: fileName)
            UIImage.saveOnDisk(image: image, with: fileName)
        }
        
        group.notify(queue: .main) {
            image = UIImage.loadFromDisk(imageName: data!.link)
            self.delegate?.documentSelected(data, image: image)
        }
        self.dismissPicker(picker, delay: 0.3)
    }
    

    
    /* MARK: (Câmera) UIImagePickerControllerDelegate */
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as? UIImage
        self.sendData(with: image)
        
        self.dismissPicker(picker)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismissPicker(picker, isDataNil: true)
    }
    
    
    
    /* MARK: - Criações */
    
    /// Cria a tela da câmera
    /// - Returns: tela da câmera (se a câmera existir)
    private func createCameraPicker() -> UIImagePickerController? {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return nil }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.cameraDevice = .rear
        picker.cameraCaptureMode = .photo
        picker.allowsEditing = false
        
        return picker
    }
    
    
    /// Cria a tela de seleção pelo álbum de fotos
    /// - Returns: tela de seleção pelo álbum de fotos
    ///
    /// Os tipos de arquivos perimtidos são: imagens, livePhotos e capturas de tela (screenshots)
    private func createPhotoPicker() -> PHPickerViewController {
        var filesToChoose: [PHPickerFilter] = [.images, .livePhotos]
        if #available(iOS 15.0, *) {
            filesToChoose += [.screenshots]
        }
        
        var configs = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configs.selectionLimit = 1
        configs.filter = .any(of: filesToChoose)
        
        let picker = PHPickerViewController(configuration: configs)
        picker.delegate = self
        return picker
    }
    
    
    /// Cria a tela de seleção pela pasta de documentos
    /// - Returns: tela de seleção pela pasta de documentos
    ///
    /// Os únicos arquivos permitos são do tipo pdf.
    private func creatDocumentPicker() -> UIDocumentPickerViewController {
        var filesToChoose: [UTType] = []
        
        if let pdf = UTType(filenameExtension: "pdf") {
            filesToChoose.append(pdf)
        }
        
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: filesToChoose, asCopy: true)
        picker.delegate = self
        picker.shouldShowFileExtensions = true
        return picker
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Fecha a tela de seleção
    /// - Parameters:
    ///   - picker: tela
    ///   - delay: delay para fechar
    ///   - isDataNil: boleano que indica se o retono (pelo delegate) é nulo
    private func dismissPicker(_ picker: UIViewController, delay: TimeInterval = 0, isDataNil: Bool = false) {
        if isDataNil {
            self.delegate?.documentSelected(nil, image: nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            picker.dismiss(animated: true)
            picker.navigationController?.popViewController(animated: true)
        }
    }
    
    
    /// Pega uma imagem de preview do pdf usando uma das páginas
    /// - Parameters:
    ///   - documentUrl: link do documento (local)
    ///   - pageIndex: página de referência do PDF (por padrão é a primeira)
    /// - Returns: preview do pdf
    private func getPDFThumbnail(for documentUrl: URL, atPage pageIndex: Int = 0) -> UIImage? {
        guard let pdf = PDFDocument(url: documentUrl)?.page(at: pageIndex) else { return nil }
        let size = CGSize(width: 32*15, height: 45*15)
        let image = pdf.thumbnail(of: size, for: .trimBox)
        return image
    }
    
    
    /// Envia os dados para o delegate
    /// - Parameter image: imagem
    private func sendData(with image: UIImage?) {
        guard let image else { self.delegate?.documentSelected(nil, image: nil); return }
        let fileName = self.fileName
        UIImage.saveOnDisk(image: image, with: fileName)
        
        let data = ManagedFiles(link: fileName, name: fileName)
        self.delegate?.documentSelected(data, image: image)
    }
}
