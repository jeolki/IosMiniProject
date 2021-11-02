//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by Jeonggi Hong on 2021/10/31.
//

import UIKit

// 수정을 클릭하여 전달받은 다이어리 객체를 전달받는 프로퍼티
enum DiaryEditorMode {
    case new
    case edit(IndexPath, Diary)
}

// 델리게이트를 통해서 일기장 리스트 화면에 일기가 작성된 다이어리 객체를 전달하고자 한다
protocol WriteDiaryViewDelegate: AnyObject {
    func didSelectReigster(diary: Diary)
}

class WriteDiaryViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    // 날짜의 TextField 선택시 날짜선택이 나오도록 하기위해 필요한 상수와 변수
    private let datePicker = UIDatePicker()
    private var diaryDate: Date?
    
    // 델리게이트 프로퍼티 정의
    weak var delegate: WriteDiaryViewDelegate?
    
    // 다이어리에디터 저장
    var diaryEditorMode: DiaryEditorMode = .new
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 내용 textView의 설정 함수 호출
        self.configureContentsTextView()
        // 날짜 textFielf의 변형 함수 호출
        self.configureDatePicker()
        
        // 등록버튼 활성화 판단을 위한 메서드 호출
        self.configureInputField()
        
        // 수정시 일기가 표시되도록
        self.configureEditMode()
        
        // 초기에 등록버튼 비활성화
        self.confirmButton.isEnabled = false
        
    }
    
    // 수정시 내용들 표시되도록
    private func configureEditMode() {
        switch self.diaryEditorMode {
        case let .edit(_, diary):
            self.titleTextField.text = diary.title
            self.contentsTextView.text = diary.contents
            self.dateTextField.text = self.dateToString(date: diary.date)
            self.diaryDate = diary.date
            self.confirmButton.title = "수정"
        
        default:
            break
        }
    }
    
    // date를 String으로 변환
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    private func configureContentsTextView() {
        // 글 내용의 textView의 테두리 설정
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        self.contentsTextView.layer.borderColor = borderColor.cgColor
        // layer 관련된 색상을 설정하기 위해서는 cgColor로 구현 하여야 한다.
        self.contentsTextView.layer.borderWidth = 0.5 // border 넓이
        self.contentsTextView.layer.cornerRadius = 5.0 // border 둥근정도
    }
    
    // 날짜 textField
    private func configureDatePicker() {
        self.datePicker.datePickerMode = .date // 날짜만 나오도록 설정
        self.datePicker.preferredDatePickerStyle = .wheels
        
        // UIcontroller 객체가 이벤트에 응답하는 방식을 설정해주는 메서드
        // target, action: 시작될 메서드, for: 어떤것이 발생 되었을때 메서드를 호출할 것인지
        // 값이 바뀔때마다 datePickerValueDidChange메서드를 호출하고 메서드 파라미터를 통해 변경된 datePicker상태를 UIDatePicker에 전달한다.
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        
        // 한국어로 표시
        self.datePicker.locale = Locale(identifier: "ko_KR")
        
        self.dateTextField.inputView = self.datePicker // textField 선택시 키보드가 아닌 datePicker가 선택됨
        
    }
    
    // 등록버튼 활성화를 위한 입력판단
    private func configureInputField() {
        self.contentsTextView.delegate = self
        
        // titleTextField의 텍스트가 입력될때 마다 호출되는 메서드를 정의
        self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
        
        // 날짜가 변경될때마다 호출되는 메서드
        self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
        // 다이어리 객체를 생성하고 델리게이터에 정의한 didSelectReigster 메소드를 호출해서 파라미터에 생성된 다이어리 객체 전달
        guard let title = self.titleTextField.text else { return }
        guard let contents = self.contentsTextView.text else { return }
        guard let date = self.diaryDate else { return }
        
        // 수정된 내용을 전달하는 NotificationCenter를 구현할것이다
        // NotificationCenter를 이용해서 수정이 일어나면 수정된 다이어리 객체를 전달하고
        // NotificationCenter를 구독하고 있는
        // 화면에서 수정된 다이어리 객체를 전달받고 뷰에도 수정된 내용이 전달되도록 구현
        // NotificationCenter 등록된 이벤트가 발생하면 해당 이벤트들에 대한 행동을 취하는것
        // 앱내에서 아무데서나 메세지를 던지면 아무대서나 이 메세지를 받을 수있도록 하는 역할
        // 이벤트버스라고 생각하면된다 이벤트는 post라는 메서드를 이용해서 이벤트를 전송하고
        // 이벤트를 받으려면 옵저버를 등록해서 포스트이벤트를 전달받을수 있습니다.
        
        // 수정버튼을 누르면 포스트함수 호출
        switch self.diaryEditorMode {
        case .new:
            // 다이어리 객체 생성
            let diary = Diary(
                uuidString: UUID().uuidString,
                title: title,
                contents: contents,
                date: date,
                isStar: false
            )
            self.delegate?.didSelectReigster(diary: diary)
            
        case let .edit(indexPath, diary):
            // 다이어리 객체 생성
            let diary = Diary(
                uuidString: UUID().uuidString,
                title: title,
                contents: contents,
                date: date,
                isStar: diary.isStar
            )
            NotificationCenter.default.post(
                name: NSNotification.Name("editDiary"),
                object: diary,
                userInfo: nil
            )
        }
        // 전 화면으로 이동 되도록
        self.navigationController?.popViewController(animated: true)
    }
    
    // datePicker에 관한 메서드
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
        // 날짜와 텍스트 반환해주는 역할 : 데이트 타입을 사람이읽을 수 있는 형태 반환, 반대로 변환 역할
        let formater = DateFormatter()
        formater.dateFormat = "yyyy년 MM월 dd일(EEEEE)" // 요일을 한글자만 표현
        formater.locale = Locale(identifier: "ko_KR") // 한국어 설정
        self.diaryDate = datePicker.date
        self.dateTextField.text = formater.string(from: datePicker.date) // 데이트를 formmater에 지정한 문자열로 변경
        
        // dateTextField는 날짜를 키보드로 입력받는것이 아니기 때문에 datePicker로 변경해도 dateTextFieldDidChagne메서드가 호출되지 않는다
        // 이를 해결하기 위해서 날짜가 변경될때 마다 editingChanged를 보내주도록 한다.
        self.dateTextField.sendActions(for: .editingChanged)
        
    }
    
    // 제목이 입력될때마다 등록버튼 활성화 판단
    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    // 날짜가 입력될때마다 등록버튼 활성화 판단
    @objc private func dateTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }

    // 빈화면을 눌렀을떄 키보드나 datePicker가 닫히도록하는 메서드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 등록버튼의 활성화를 판단하는 메서드
    private func validateInputField() {
        self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true) && !self.contentsTextView.text.isEmpty
    }
}

extension WriteDiaryViewController: UITextViewDelegate {
    
    // 텍스트뷰의 텍스트가 입력될 때마다 호출되는 메서드
    func textViewDidChange(_ textView: UITextView) {
        self.validateInputField()
    }
}
