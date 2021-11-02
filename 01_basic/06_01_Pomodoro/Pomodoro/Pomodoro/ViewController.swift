//
//  ViewController.swift
//  Pomodoro
//
//  Created by Jeonggi Hong on 2021/11/02.
//

import UIKit

enum TimerStatus {
    case start
    case pause
    case end
}

class ViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    
    // 타이머에 설정된 시간을 초로 저장하는 변수: 기본으로 1이설정되어 있어 60으로 초기화
    var duration = 60
    
    // 타이머의 상태를 가지고 있는 변수
    var timerStatus: TimerStatus = .end
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureToggleButton()
    }
    
    // timeLabel 과 progressView 의 Hidden 변경 메서드
    func setTimerInfoViewVisible(isHidden: Bool) {
        self.timerLabel.isHidden = isHidden
        self.progressView.isHidden = isHidden
    }
    
    // toggleButton 의 상태에따라 title 변경 구현
    func configureToggleButton() {
        self.toggleButton.setTitle("시작", for: .normal)
        self.toggleButton.setTitle("일시정지", for: .selected)
    }
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        switch self.timerStatus {
        case .start, .pause:
            self.timerStatus = .end
            self.cancelButton.isEnabled = false
            self.setTimerInfoViewVisible(isHidden: true)
            self.datePicker.isHidden = false
            self.toggleButton.isSelected = false
        
        default:
            break
        }
    }
    
    @IBAction func tapToggleButton(_ sender: UIButton) {
        
        // datePicker의 설정한 타이머시간을 초로 가져올 수 있습니다
        self.duration = Int(self.datePicker.countDownDuration)
        //debugPrint(self.duration)
        
        // 타이머가 시작되면 TimerStatus 값 변경
        switch self.timerStatus {
        case .end:
            self.timerStatus = .start
            self.setTimerInfoViewVisible(isHidden: false)
            self.datePicker.isHidden = true
            self.toggleButton.isSelected = true
            self.cancelButton.isEnabled = true
            
        case .start:
            self.timerStatus = .pause
            self.toggleButton.isSelected = false
        
        case .pause:
            self.timerStatus = .start
            self.toggleButton.isSelected = true
            
        }
        
    }
    
    
}

