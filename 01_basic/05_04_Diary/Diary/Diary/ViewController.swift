//
//  ViewController.swift
//  Diary
//
//  Created by Jeonggi Hong on 2021/10/31.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    // 일기가 추가되거나 변경이 일어날때마다 UserDefaults에 저장
    private var diaryList = [Diary]() {
        didSet {
            self.saveDiaryList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureCollectionView()
        
        self.loadDiaryList()
        
        // 수정된것 저장
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editDiaryNotification(_:)),
            name: NSNotification.Name("editDiary"),
            object: nil
        )
        
        // starDiary Notification observing
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(starDiaryNotification(_:)),
            name: NSNotification.Name("starDiary"),
            object: nil
        )
        
        // deleteDiary Notificarion observing
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deleteDiaryNotification(_:)),
            name: NSNotification.Name("deleteDiary"),
            object: nil
        )
        
    }
    
    @objc func editDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else { return }
        guard let index = self.diaryList.firstIndex(where: { $0.uuidString == diary.uuidString }) else { return }
        self.diaryList[index] = diary
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        self.collectionView.reloadData()
    }
    
    @objc func starDiaryNotification(_ notification: Notification) {
        guard let starDiary = notification.object as? [String: Any] else { return }
        guard let isStar = starDiary["isStar"] as? Bool else { return }
        guard let uuidString = starDiary["uuidString"] as? String else { return }
        guard let index = self.diaryList.firstIndex(where: { $0.uuidString == uuidString }) else { return }
        self.diaryList[index].isStar = isStar
    }
    
    @objc func deleteDiaryNotification(_ notification: Notification) {
        guard let uuidString = notification.object as? String else { return }
        guard let index = self.diaryList.firstIndex(where: { $0.uuidString == uuidString }) else { return }
        self.diaryList.remove(at: index)
        self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
    }
    
    // 다이어리 리스트에 추가된 다이어리를 CollectionView에 보이도록 구현
    // CollectionView의 속성을 설정하는 메서드 구현
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        // collectionview 의 표시되는 contents의 상하좌우 간격설정
        
        // 채택하고 필수 메서드 구현
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    // segue를 통한 이동 다이어리 객체를 받을 준비
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let writeDiaryViewController = segue.destination as? WriteDiaryViewController {
            writeDiaryViewController.delegate = self // 에러발생 writeDiartViewDelegate 채택
        }
    }
    
    // UserDefault를 이용해서 등록한 일기가 사라지지 않도록 설정
    private func saveDiaryList() {
        let data = self.diaryList.map {
            [
                "uuidString": $0.uuidString,
                "title": $0.title,
                "contents": $0.contents,
                "date": $0.date,
                "isStar": $0.isStar
            ]
        }
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "diaryList")
    }
    
    // 저장된 다이어리 가져오기
    private func loadDiaryList() {
        let userDefaults = UserDefaults.standard
        // 키값을 넘겨서 가져온다
        // 오브젝트 메서드는 에니타입으로 리턴이 되기 때문에 Dictionary 배열 형태로 타입 캐스팅을 해주겠습니다.
        // 타입캐스팅이 실패하면 nil이 될수 있으니 guard문으로 옵셔널 바인딩을 해주겠습니다.
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else { return }
        self.diaryList = data.compactMap {
            guard let uuidString = $0["uuidString"] as? String else { return nil }
            guard let title = $0["title"] as? String else { return nil }
            guard let contents = $0["contents"] as? String else { return nil }
            guard let date = $0["date"] as? Date else { return nil }
            guard let isStar = $0["isStar"] as? Bool else { return nil }
            return Diary(
                uuidString: uuidString,
                title: title,
                contents: contents,
                date: date,
                isStar: isStar
            )
        }
        
        // 일기를 최신순으로 정렬
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending // 느림차순
        })
    }
    
    // date를 String으로 변환
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}

extension ViewController: UICollectionViewDataSource {
    // 지정된 섹션에 표시할 셀의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count
    }
    
    // 컬렉션뷰에 지정된 위치에 표시할 셀을 요청
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 재활용할 셀 가져오기
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else { return UICollectionViewCell() }
        // 가져온 Cell에 diary 입력하기
        let diary = self.diaryList[indexPath.row]
        cell.titleLabel.text = diary.title // 제목입력
        cell.dateLabel.text = self.dateToString(date: diary.date) // 날짜표시 Diary에 있는 date를 문자열로 만들어야함
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    // cell의 size설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 200) // 행간 cell 2개
    }
}

extension ViewController: WriteDiaryViewDelegate {
    func didSelectReigster(diary: Diary) {
        self.diaryList.append(diary)
        
        // 일기를 최신순으로 정렬
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending // 느림차순
        })
        
        // 다이어리를 추가할때마다 리로드
        self.collectionView.reloadData()
    }
}

// 일기 상세화면 이동
// 스토리보드로 이동해서 다이어리 뷰 컨트롤러의 Identify를 DiaryDetailViewController로 설정 후
extension ViewController: UICollectionViewDelegate {
    // 특정 셀이 선택되었음을 알리는 메서드
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
        let diary = self.diaryList[indexPath.row]
        viewController.diary = diary
        viewController.indexPath = indexPath
        
        //viewController.delegate = self
        
        self.navigationController?.pushViewController(viewController, animated: true)
        // 일기장 리스트화면에서 일기를 선택했을때 상세화면으로 이동하고 상세내용을 볼 수 있습니다.
        
    }
}
