//
//  SettingsViewController.swift
//  FotografPaylasma
//
//  Created by Selman Kaya on 26.12.2024.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func cikisYapTiklandi(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toViewController", sender: nil)


        }catch{
            print("Hata")
        }
    }
}
