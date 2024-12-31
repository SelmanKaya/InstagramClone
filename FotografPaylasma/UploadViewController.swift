//
//  UploadViewController.swift
//  FotografPaylasma
//
//  Created by Selman Kaya on 26.12.2024.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class UploadViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageView.addGestureRecognizer(gestureRecognizer)

        // Do any additional setup after loading the view.
    }
    
    @objc func imageViewTapped() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.dismiss(animated: true)
    }

    @IBAction func yukleButton(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data){(storagemetadata,error) in
            if error != nil{
                self.hataMesajiGoster(title: "Hata!", message: error?.localizedDescription ?? "Hata Aldiniz tekrar deneyin")
                
             }else{
                imageReference.downloadURL { url , error in
                    if error == nil{
                        let imageURL = url?.absoluteString
                        
                        if let imageURL = imageURL{
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            
                            let firestorePost = ["gorselurl": imageURL , "yorum": self.textField.text!, "email" : Auth.auth().currentUser!.email as Any,"tarih": FieldValue.serverTimestamp()] as [String : Any]
                            
                            
                            firestoreDatabase.collection("Post").addDocument(data: firestorePost){
                                (error) in
                                if error != nil {
                                    self.hataMesajiGoster(title: "Hata", message: error?.localizedDescription ?? "Hata aldiniz tekrar deneyin")
                                }else{
                                    self.imageView.image = UIImage(named: "izmir")
                                    self.textField.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            }
                            
                            
                        }
                        
                        
                        
                    }                }
            }
            }
            
        }
        
    }
    
    
    func hataMesajiGoster(title: String , message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okButton)
        self.present(alert , animated: true)
    }
    
}
