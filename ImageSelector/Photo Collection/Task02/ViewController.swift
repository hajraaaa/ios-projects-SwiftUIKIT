import UIKit
import Photos

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CustomCellDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "CustomCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        layout.itemSize = CGSize(width: 100, height: 100)
        
        collectionView.collectionViewLayout = layout
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        if indexPath.item < images.count {
            cell.imageView.image = images[indexPath.item]
            cell.plusButton.isHidden = true
        } else {
            cell.imageView.image = nil
            cell.plusButton.isHidden = false
            cell.delegate = self
        }
        return cell
    }
    
    // MARK: - CustomCellDelegate
    func didTapPlusButton(in cell: CustomCell) {
        showMenu()
    }
    
    // MARK: - Menu Handling
        func showMenu() {
        let actionSheet = UIAlertController(title: nil, message: "Choose Photo", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Select from Gallery", style: .default, handler: { _ in
            self.selectImageFromGallery()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Select from Camera", style: .default, handler: { _ in
            self.selectImageFromCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    func selectImageFromGallery() {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            openGallery()
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self.openGallery()
                    } else {
                        self.showAccessDeniedAlert()
                    }
                }
            }
        } else {
            self.showAccessDeniedAlert()
        }
    }
    
    func selectImageFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        } else {
            showAlert(title: "Camera Not Available", message: "The camera is not available on this device.")
        }
    }
    
    func openGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func showAccessDeniedAlert() {
        let alert = UIAlertController(title: "Access Denied", message: "Please grant access to your photo library in Settings.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            images.append(image)
            collectionView.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil) 
    }
}
