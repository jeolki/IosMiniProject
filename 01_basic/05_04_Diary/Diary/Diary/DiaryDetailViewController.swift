//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by Jeonggi Hong on 2021/10/31.
//

import UIKit

// 지금 일기장 상세화면에서 삭제 또는 즐겨찾기 토글이 일어나게 되면 delegate를 통해 view컨트롤러 클래스 즉 일기장
// 화면의 인덱스패치와 즐겨찾기를 전달하고 있는데 이렇게 되면 1:1로만 데이터를 전달할수 있기 때문에 일기장화면에서
// 일기장 상세화면으로 이동했을때에는 일기장 화면에만 델리게이트가 전달할수있고 즐겨찾기 화면에서 일기장 상세화면으로 이동하였을때는
// 즐겨찾기 화면에만 델리게이트를 전달할 수 있습니다
// 그래서 이 델리게이터를 다 걷어내고 노티피 케이션 센터를 이용해서 일기장 상세화면에서 삭제또는 즐겨찾기 토글행위가 발생하면
// 일기장 화면과 즐겨찾기화면에 이벤트가 모두 전달되도록 로직을 변경해보겠습니다.
/*
protocol DiartDetailViewDelegate: AnyObject {
    
    // 일기장 상세화면에서 삭제가 일어날때 메서드를 통해 일기장리스트화면의 indexpath를 이용해서 삭제하기 위함
    func didSelectDelete(indexPath: IndexPath)
    
    // 즐겨찾기 여부 전달 -> notification 으로 변경되어 필요 없어짐
    //func didSelectStar(indexPath: IndexPath, isStar: Bool)
}
*/

class DiaryDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!

    // 즐겨찾기 버튼 생성
    var starButton: UIBarButtonItem?
    
    // 일기장을 전달받을 프로퍼티선언
    var diary: Diary?
    var indexPath: IndexPath?
    
    // notification 방식으로 변경
    //weak var delegate: DiartDetailViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(starDiaryNotification(_:)),
            name: NSNotification.Name("starDiary"),
            object: nil
        )
    }
    
    // 프로퍼티를 통해 전달받은 다이어리 객체를 뷰에 초기화
    private func configureView() {
        guard let diary = self.diary else { return }
        self.titleLabel.text = diary.title
        self.contentsTextView.text = diary.contents
        self.dateLabel.text = self.dateToString(date: diary.date)
        
        // 즐겨찾기 버튼
        self.starButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tapStarButton))
        self.starButton?.image = diary.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        self.starButton?.tintColor = .orange
        self.navigationItem.rightBarButtonItem = self.starButton
    }
    
    // 즐겨찾기 버튼을 눌렀을때
    @objc func tapStarButton() {
        guard let isStar = self.diary?.isStar else { return }
        //guard let indexPath = self.indexPath else { return }
        
        if isStar {
            self.starButton?.image = UIImage(systemName: "star")
        } else {
            self.starButton?.image = UIImage(systemName: "star.fill")
        }
        
        // true 이면 flase / flase 이면 true 토글
        self.diary?.isStar = !isStar
        
        // 즐겨찾기 상태 전달 (Notification 방식)
        NotificationCenter.default.post(
            name: NSNotification.Name("starDiary"),
            object: [
                "diary": self.diary,
                "isStar": self.diary?.isStar ?? false, // 즐겨찾기 상태값
                "uuidString": self.diary?.uuidString
            ],
            userInfo: nil
        )
        
        // 즐겨찾기 상태 전달 (delegate 방식) -> notification 방식으로 변경
        //self.delegate?.didSelectStar(indexPath: indexPath, isStar: self.diary?.isStar ?? false)
    }
    
    
    // date를 String으로 변환
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    @objc func starDiaryNotification(_ notification: Notification) {
        guard let starDiary = notification.object as? [String: Any] else { return }
        guard let isStar = starDiary["isStar"] as? Bool else { return }
        guard let uuidString = starDiary["uuidString"] as? String else { return }
        guard let diary = self.diary else { return }
        if diary.uuidString == uuidString {
            self.diary?.isStar = isStar
            self.configureView()
        }
    }
    
    @IBAction func tapEditButton(_ sender: UIButton) {
        // diary 객체 전달
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "WriteDiaryViewController") as? WriteDiaryViewController else { return }
        
        // 수정버튼 클릭시 객체 전달
        guard let indexPath = self.indexPath else { return }
        guard let diary = self.diary else { return }
        viewController.diaryEditorMode = .edit(indexPath, diary)
        
        
        // Notification을 옵저빙 하는 코드
        NotificationCenter.default.addObserver(
            self, // 어떤 인스턴스에서 옵져빙 할것인지
            selector: #selector(editDiaryNotification(_:)),
            // 이벤트가 발생하면 selector에 정의된 함수 실행
            name: NSNotification.Name("editDiary"), // 관찰 이름
            object: nil
        )
        
        // 수정버튼을 누르면 WriteDiaryViewController로 이동
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @objc func editDiaryNotification(_ notification: Notification) {
        
        // 수정된 다이어리 객체를 뷰에 업데이트
        guard let diary = notification.object as? Diary else { return }
        self.diary = diary
        self.configureView()
    }
    
    // 삭제버튼 클릭시
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        guard let uuidString = self.diary?.uuidString else { return }
        NotificationCenter.default.post(
            name: NSNotification.Name("deleteDiary"),
            object: uuidString,
            userInfo: nil
        )
        
        // delegate -> notification 으로 변경
        //self.delegate?.didSelectDelete(indexPath: indexPath)
        
        // 전화면으로 이동
        self.navigationController?.popViewController(animated: true)
    }
    
    
    deinit {
        // deinit시 모든 옵저버 삭제
        NotificationCenter.default.removeObserver(self)
    }


}
