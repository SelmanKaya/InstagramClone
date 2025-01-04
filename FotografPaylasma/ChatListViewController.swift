//
//  ChatListViewController.swift
//  FotografPaylasma
//
//  Created by Selman Kaya on 31.12.2024.
//

import UIKit
import FirebaseFirestore


class ChatListViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{

    
    
    @IBOutlet weak var tableView: UITableView!
    
    var users: [User] = [] // User modeline sahip bir liste
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        fetchUsers()
        
        
        // Do any additional setup after loading the view.
    }
    func fetchUsers() {
        let db = Firestore.firestore()
        db.collection("Users").getDocuments { (snapshot, error) in
            if let error = error {
                print("Kullanıcılar alınamadı: \(error.localizedDescription)")
            } else if let snapshot = snapshot {
                self.users = snapshot.documents.compactMap { document -> User? in
                    let data = document.data()
                    guard let email = data["email"] as? String else { return nil }
                    return User(id: document.documentID, email: email)
                }
                self.tableView.reloadData()
            }
        }
        
        
        
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].email
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showChat", sender: users[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "showChat",
           let destinationVC = segue.destination as? ChatViewController,
           let selectedUser = sender as? User {
            destinationVC.user = selectedUser
        }
    }
}
