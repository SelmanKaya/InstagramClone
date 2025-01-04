//
//  ChatViewController.swift
//  FotografPaylasma
//
//  Created by Selman Kaya on 31.12.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class ChatViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{

    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
        var user: User? // Sohbet edilen kullanıcı
        var messages: [Message] = [] // Mesaj listesi

        let db = Firestore.firestore()

        override func viewDidLoad() {
            super.viewDidLoad()
            self.title = user?.email

            chatTableView.delegate = self
            chatTableView.dataSource = self

            fetchMessages()
        }

    @IBAction func sendMessage(_ sender: Any) {
        guard let currentUser = Auth.auth().currentUser else { return }
                guard let messageText = messageTextField.text, !messageText.isEmpty else { return }
                guard let recipientID = user?.id else { return }
        


                // Mesajı Firestore'a ekle
                let messageData: [String: Any] = [
                    "senderID": currentUser.uid,
                    "recipientID": recipientID,
                    "text": messageText,
                    "timestamp": FieldValue.serverTimestamp()
                ]

                db.collection("messages").addDocument(data: messageData) { error in
                    if let error = error {
                        print("Mesaj gönderilemedi: \(error.localizedDescription)")
                    } else {
                        self.messageTextField.text = ""
                        self.fetchMessages() // Yeni mesajları güncelle
                    }
                }
    }
    func fetchMessages() {
            guard let currentUser = Auth.auth().currentUser else { return }
            guard let recipientID = user?.id else { return }

            db.collection("messages")
                .whereField("senderID", in: [currentUser.uid, recipientID])
                .whereField("recipientID", in: [currentUser.uid, recipientID])
                .order(by: "timestamp", descending: false)
                .addSnapshotListener { (snapshot, error) in
                    if let error = error {
                        print("Mesajlar alınamadı: \(error.localizedDescription)")
                    } else {
                        self.messages.removeAll()

                        if let snapshot = snapshot {
                            for document in snapshot.documents {
                                let data = document.data()
                                if let senderID = data["senderID"] as? String,
                                   let text = data["text"] as? String,
                                   let timestamp = data["timestamp"] as? Timestamp {
                                    let message = Message(senderID: senderID, text: text, timestamp: timestamp.dateValue())
                                    self.messages.append(message)
                                }
                            }
                            self.chatTableView.reloadData()
                            if !self.messages.isEmpty {
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                            }
                        }
                    }
                }
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return messages.count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageBlockCell", for: indexPath)
            let message = messages[indexPath.row]
            cell.textLabel?.text = message.text
            cell.textLabel?.textAlignment = message.senderID == Auth.auth().currentUser?.uid ? .right : .left
            return cell
        }
    
}
