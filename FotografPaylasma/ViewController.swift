//
//  ViewController.swift
//  FotografPaylasma
//
//  Created by Selman Kaya on 26.12.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var sifreTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func girisYapTiklandi(_ sender: Any) {
        if emailTextField.text != "" && sifreTextField.text != "" {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: sifreTextField.text!) { (authDataResult , error) in
                if error != nil{
                    self.hataMesaji(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hata aldiniz,Tekrar deneyin")
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        }else{
            self.hataMesaji(titleInput: "Hata", messageInput: "Email ve parola giriniz")
        }
    }
    
    @IBAction func kayitOlTiklandi(_ sender: Any) {
        
        if let email = emailTextField.text, let password = sifreTextField.text, !email.isEmpty, !password.isEmpty {
                Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
                    if let error = error {
                        self.hataMesaji(titleInput: "Hata!", messageInput: error.localizedDescription)
                    } else if let userID = authDataResult?.user.uid {
                        // Firestore'a kullanıcı bilgilerini ekle
                        let db = Firestore.firestore()
                        db.collection("users").document(userID).setData([
                            "email": email,
                            "createdAt": Timestamp(date: Date())
                        ]) { error in
                            if let error = error {
                                self.hataMesaji(titleInput: "Hata!", messageInput: "Kullanıcı verileri kaydedilemedi: \(error.localizedDescription)")
                            } else {
                                self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                            }
                        }
                    }
                }
            } else {
                hataMesaji(titleInput: "Hata!", messageInput: "Kullanıcı adı ve şifre giriniz")
            }
    }
    func hataMesaji(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
    
}

