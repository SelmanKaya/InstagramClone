//
//  FeedViewController.swift
//  FotografPaylasma
//
//  Created by Selman Kaya on 26.12.2024.
//

import UIKit
import FirebaseFirestore
import SDWebImage


class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var postDizisi = [Post]()
    
    
    /*
    var emailDizisi = [String]()
    var yorumDizisi = [String]()
    var gorselDizisi = [String]()
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        firebaseVeriAl()
    }
    
    func firebaseVeriAl() {
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Post").order(by: "tarih", descending: true)
            .addSnapshotListener { (snapshot,  error) in
            
            if error != nil {
                print(error?.localizedDescription)
            }else{
                if snapshot?.isEmpty != true && snapshot != nil{
                    //self.emailDizisi.removeAll(keepingCapacity: false)
                    //self.gorselDizisi.removeAll(keepingCapacity: false)
                    //self.yorumDizisi.removeAll(keepingCapacity: false)
                    
                    self.postDizisi.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents{
                        //let documentID = document.documentID
                        if let gorselUrl = document.get("gorselurl") as? String{
                            if let email = document.get("email") as? String{
                                if let yorum = document.get("yorum") as? String{
                                    let post = Post(email: email , yorum: yorum , gorselUrl: gorselUrl)
                                    self.postDizisi.append(post)
                                }
                                
                            }
                        }
                        
                        
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postDizisi.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell" , for: indexPath) as! FeedCell
        cell.emailText.text = postDizisi[indexPath.row].email
        cell.yorumText.text = postDizisi[indexPath.row].yorum
        cell.postImageView.sd_setImage(with: URL(string: self.postDizisi[indexPath.row].gorselUrl))
        
        return cell
    }

}
