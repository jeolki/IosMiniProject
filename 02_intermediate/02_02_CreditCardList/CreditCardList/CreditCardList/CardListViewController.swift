//
//  CardListViewController.swift
//  CreditCardList
//
//  Created by Jeonggi Hong on 2021/11/07.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseDatabase
import FirebaseFirestoreSwift

class CardListViewController: UITableViewController {
    
//    var ref: DatabaseReference! // Firebase Realtime Database
    
    var db = Firestore.firestore()
    
    var creditCardList: [CreditCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UITabelView Cell Register
        let nibName = UINib(nibName: "CardListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "CardListCell")
        
        // 실시간 데이터베이스 읽기
        // 데이터베이스의 흐름을 주고받음
//        ref = Database.database().reference()
//
//        ref.observe(.value) { snapshot in
//            guard let value = snapshot.value as? [String: [String: Any]] else { return }
//
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: value)
//                let cardData = try JSONDecoder().decode([String: CreditCard].self, from: jsonData)
//                let cardList = Array(cardData.values)
//                self.creditCardList = cardList.sorted { $0.rank < $1.rank }
//
//                // 유아이설정 메인스레드에서 작동해야한다.
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//
//            } catch let error {
//                print("ERROR JSON parsing \(error.localizedDescription)")
//            }
//        }
        
        // Firestore 읽기
        db.collection("creditCardList").addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("ERROR Firestore fetching document \(String(describing: error))")
                return
            }
            
            // compatMap 을 쓴 이유 nil값을 반환시 배열안에 넣지 않기 위해서
            self.creditCardList = documents.compactMap { doc -> CreditCard? in
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: doc.data(), options: [])
                    let creditCard = try JSONDecoder().decode(CreditCard.self, from: jsonData)
                    return creditCard
                } catch let error {
                    print("ERROR JSON Parsing \(error)")
                    return nil
                }
            }.sorted{ $0.rank < $1.rank }
            
            // 메인 스레드에서 돌아가도록 처리
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditCardList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCell", for: indexPath) as? CardListCell else { return UITableViewCell() }
        cell.rankLabel.text = "\(creditCardList[indexPath.row].rank)위"
        cell.promotionLabel.text = "\(creditCardList[indexPath.row].promotionDetail.amount)만원 증정"
        cell.cardNameLabel.text = "\(creditCardList[indexPath.row].name)"
        
        let imageURL = URL(string: creditCardList[indexPath.row].cardImageURL)
        cell.cardImageView.kf.setImage(with: imageURL)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // 셀을 탭했을때 제어
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 상세화면 전달
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailViewController = storyboard.instantiateViewController(withIdentifier: "CardDetailViewController") as? CardDetailViewController else { return }
        
        detailViewController.promotionDetail = creditCardList[indexPath.row].promotionDetail
        self.show(detailViewController, sender: nil)
        
        // 실시간 데이터베이스 쓰기
        // Option1 선택시 실시간으로 값을 넣는 방법 경로를 알때.
//        let cardID = creditCardList[indexPath.row].id
//        ref.child("Item\(cardID)/isSelected").setValue(true)
        
        // Option2 경로를 모를때
        /*
        ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) { [weak self] snapshot in
            guard let self = self,
                  let value = snapshot.value as? [String: [String: Any]],
                  let key = value.keys.first else { return }
            
            self.ref.child("\(key)/isSelected").setValue(true)
        }
        */
        
        // setValue 에 nil을 넣으면 삭제와 같다.
        
        // Firestore 쓰기
        // Option1 경로를 알고 있을 때
        let cardID = creditCardList[indexPath.row].id
//        db.collection("creditCardList").document("card\(cardID)").updateData(["isSelected": true])
        
        // Option2 경로를 모를 때 : id와 같은 고유값으로 문서를 검색후 결과로 업데이트
        db.collection("creditCardList").whereField("id", isEqualTo: cardID).getDocuments { snapshot, _ in
            guard let document = snapshot?.documents.first else {
                print("ERROR Firestore fetch document")
                return
            }
            
            document.reference.updateData(["isSelected": true])
            
        }
    }
    
    // 스와이프 삭제
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // 실시간 데이터베이스 삭제
            // Option1
//            let cardID = creditCardList[indexPath.row].id
//            ref.child("Item\(cardID)").removeValue()
            
            // Option2 경로를 모를때 검색 후 삭제
            /*
            ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) {
                [weak self] snapshot in
                guard let self = self,
                      let value = snapshot.value as? [String: [String: Any]],
                      let key = value.keys.first else { return }
                
                self.ref.child(key).removeValue()
            }
             */
            
            // Firestore 삭제
            // Option1 경로를 알때
            let cardID = creditCardList[indexPath.row].id
//            db.collection("creditCardList").document("card\(cardID)").delete()
            
            // Option2 경로를 모를때
            db.collection("creditCardList").whereField("id", isEqualTo: cardID).getDocuments{ snapshot, _ in
                guard let document = snapshot?.documents.first else {
                    print("ERROR")
                    return
                }
                
                document.reference.delete()
            }
            
        }
    }
    
}
