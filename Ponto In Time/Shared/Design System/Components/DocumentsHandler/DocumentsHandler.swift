/* Macro - Grupo 05 */

/* Bibliotecas necessárias: */
import UIKit
import Photos
import PhotosUI



enum PickerType {
    case camera
    case photos
    case files
}


class DocumentsHandler {
    
    public var pickerType: PickerType
    
    
    init(pickerType: PickerType) {
        self.pickerType = pickerType
    }
    
    
    func createPicker() -> UIViewController? {
        switch pickerType {
        case .camera:
            return self.createCameraPicker()
        case .photos:
            return self.createPhotoPicker()
        case .files:
            return self.creatDocumentPicker()
        }
    }
    
    
    private func createCameraPicker() -> UIImagePickerController? {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return nil }
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraDevice = .front
        picker.cameraCaptureMode = .photo
        picker.allowsEditing = true
        // picker.mediaTypes = []
        
        return picker
    }
    
    
    private func createPhotoPicker() -> PHPickerViewController {
        var filesToChoose: [PHPickerFilter] = [.images, .livePhotos]
        if #available(iOS 15.0, *) {
            filesToChoose += [.screenshots]
        }
        
        var configs = PHPickerConfiguration()
        configs.selectionLimit = 1
        configs.filter = .any(of: filesToChoose)
        
        let picker = PHPickerViewController(configuration: configs)
        return picker
    }
    
    
    private func creatDocumentPicker() -> UIDocumentPickerViewController {
        var filesToChoose: [UTType] = []
        
        if let pdf = UTType(filenameExtension: "pdf") {
            filesToChoose.append(pdf)
        } else {
            print("O tipo PDF não rolou")
        }
        
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: filesToChoose)
        return picker
        
    }
}
