//
//  ViewController.swift
//  Pomodoro
//
//  Created by Jeonggi Hong on 2021/11/02.
//

import UIKit
import AudioToolbox

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
    @IBOutlet weak var imageView: UIImageView!
    
    // 타이머에 설정된 시간을 초로 저장하는 변수: 기본으로 1이설정되어 있어 60으로 초기화
    var duration = 60
    
    // 타이머의 상태를 가지고 있는 변수
    var timerStatus: TimerStatus = .end
    
    // 타이머 기능을 위한 변수
    var timer: DispatchSourceTimer?
    
    // 카운트 다운 초로 저장
    var currentSeconds = 0
    
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
    
    func startTimer() {
        if self.timer == nil {
            /*
                Timer가 돌때마다 UI작업을 해줘야합니다.
                그렇기 때문에 main 스레드에서 반복작업을 할수 있도록 설정합니다
                main 스레드는 IOS에서 오직 한개만 존재하는 스레드 인데요 일반적으로 작성하는 대부분의 코드는 main에서 실행되게 됩니다
                우리가 작성한 대부분의 Cocoa에서 실행되는데 이 Cocoa가 코드를 main 스레드에서 호출하기 때문입니다
                main 스레드에서 중요한것 중 하나는 main 스레드가 인터페이스 스레드라고 불리는 점인데요.
                유저가 인터페이스에 접근하면 이벤트는 main 스레드에 전달되고 우리가 작성한 코드는 이에 반응을 합니다.
                이말은 곳 인터페이스와 관련된 코드는 반드시 main 스레드에서 작성되어야 함을 의미합니다.
                쉽게 말해 UI와 관련된 코드는 반드시 main 스레드에서 구현되어야 한다고 생각하면 좋습니다.
            */
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            // 바로 시작 now, 3초뒤는 now() + 3 / 1초마다
            self.timer?.schedule(deadline: .now(), repeating: 1)
            self.timer?.setEventHandler(handler: { [weak self] in
                // 1초 한번식 handler closer의 코드 실행 된다: 1식 감소
                guard let self = self else { return }
                self.currentSeconds -= 1
                let hour = self.currentSeconds / 3600
                let minutes = (self.currentSeconds % 3600 ) / 60
                let seconds = (self.currentSeconds % 3600 ) % 60
                
                self.timerLabel.text = String(format: "%02d:%02d:%02d", hour, minutes, seconds)
                
                self.progressView.progress = Float(self.currentSeconds) / Float(self.duration)
                //debugPrint(self.progressView.progress)
                
                // imageView 애니메이션
                UIView.animate(withDuration: 0.5, delay: 0, animations: {
                    // CGAffineTransform 은 뷰를이동하거나 스케일을조정 등등
                    self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
                })
                
                UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
                    self.imageView.transform = CGAffineTransform(rotationAngle: .pi * 2)
                })
                
                if self.currentSeconds <= 0 {
                    // 타이머가 종료
                    self.stopTimer()
                    
                    // 종료소리 https://iphonedev.wiki/index.php/AudioServices
                    AudioServicesPlaySystemSound(1005)
                }
            })
            self.timer?.resume()
        }
    }
    
    // 타이머 종료
    func stopTimer() {
        if self.timerStatus == .pause {
            // 일시정지 후 취소 버튼 클릭시 에러발생 -> resume() 으로 해결
            self.timer?.resume()
        }
        self.timerStatus = .end
        
        // 사라짐 나타남 애니메이션 효과
        UIView.animate(withDuration: 0.5, animations: {
            self.timerLabel.alpha = 0
            self.progressView.alpha = 0
            self.datePicker.alpha = 1
            self.imageView.transform = .identity // 원상태로
        })
        self.toggleButton.isSelected = false
        self.timer?.cancel()
        self.timer = nil // 타이머를 종료하기 위해서는 nil을 입력
    }
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        switch self.timerStatus {
        case .start, .pause:
            self.stopTimer()
            
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
            self.currentSeconds = self.duration
            self.timerStatus = .start
            // 사라짐 효과 애니메이션
            UIView.animate(withDuration: 0.5, animations: {
                self.timerLabel.alpha = 1
                self.progressView.alpha = 1
                self.datePicker.alpha = 0
            })
            self.toggleButton.isSelected = true
            self.cancelButton.isEnabled = true
            
            self.startTimer()
            
        case .start:
            self.timerStatus = .pause
            self.toggleButton.isSelected = false
            
            self.timer?.suspend() // 타이머 일시정지
            
        case .pause:
            self.timerStatus = .start
            self.toggleButton.isSelected = true
            
            self.timer?.resume() // 타이머 재개
        }
        
    }
    
    
}

