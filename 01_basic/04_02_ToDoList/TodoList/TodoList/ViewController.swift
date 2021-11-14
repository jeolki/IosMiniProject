//
//  ViewController.swift
//  TodoList
//
//  Created by Jeonggi Hong on 2021/10/30.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // strong로 한다 weak가 되어버리면 done으로 바꾸면 메모리에서 해제가 되어버려서 더이상 사용할수 없기때문에
    @IBOutlet var editButton: UIBarButtonItem!
    
    var doneButton: UIBarButtonItem?
    
    // tasks 저장
    var tasks = [Task]() {
        didSet {
            self.saveTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTap))
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadTasks() // Task 로드
    }
    
    // selector로 보낼 메서드에는 @objc가 필요하다
    @objc func doneButtonTap() {
        self.navigationItem.leftBarButtonItem = self.editButton
        self.tableView.setEditing(false, animated: true) // 편집모드에서 나오기
    }
    
    @IBAction func tapEditButton(_ sender: UIBarButtonItem) { // 편집모드 전환
        guard !self.tasks.isEmpty else { return }
        self.navigationItem.leftBarButtonItem = self.doneButton // donebutton 나오도록
        self.tableView.setEditing(true, animated: true) // 편집모드로 전환
    }
    
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        //alert 표시
        let alert = UIAlertController(title: "할 일 등록", message: nil, preferredStyle: .alert)
        let registerButton = UIAlertAction(title: "등록", style: .default, handler: { [weak self] _ in
            guard let title = alert.textFields?[0].text else { return }
            let task = Task(title: title, done: false)
            self?.tasks.append(task)
            self?.tableView.reloadData() // 갱신을 통해 추가된 것을 확인
        })
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelButton)
        alert.addAction(registerButton)
        alert.addTextField(configurationHandler: {
            textField in textField.placeholder = "할 일을 입력해주세요."
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    // UserDefaults 이용하여 앱이 종료되어도 데이터 저장
    func saveTasks() {
        let data = self.tasks.map {
            [
                "title": $0.title,
                "done": $0.done
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "tasks") // 할일 저장
    }
    
    func loadTasks() {
        let userDefults = UserDefaults.standard
        guard let data = userDefults.object(forKey: "tasks") as? [[String: Any]] else { return }
        self.tasks = data.compactMap {
            guard let title = $0["title"] as? String else { return nil }
            guard let done = $0["done"] as? Bool else { return nil }
            return Task(title: title, done: done)
        }
    }
    
    
    
}

extension ViewController: UITableViewDataSource {
    // 두개는 필수
    // 각 세션에 표시할 행의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    // 스토리보드에서 구현된 셀이 테이블뷰에 표시된다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 재사용 가능한 테이블 뷰 셀객체를 반환하고 이를 테이블뷰에 추가하는 역할
        // 큐를 이용한 재사용 불필요한 메모리 낭비 방지
        // 어떻게 셀을 재사용하는가? 스크롤이용
        // "Cell"을 이용해서 재사용 할 셀을 가져온다.
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = self.tasks[indexPath.row]
        cell.textLabel?.text = task.title
        if task.done {
            cell.accessoryType = .checkmark // 선택시 체크
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    // 삭제버튼이 눌린 행이 어떤행인지 알려준다
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic) // 편집모드에서 삭제와 스와이프로 삭제 가능하다
        if self.tasks.isEmpty {
            self.doneButtonTap() // 모든 셀이 삭제되면 편집모드를 나오도록 한다.
        }
    }
    
    // 행의 이동
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 재정렬 된순서되로 배열도 재정렬 저장
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var tasks = self.tasks
        let task = tasks[sourceIndexPath.row]
        tasks.remove(at: sourceIndexPath.row)
        tasks.insert(task, at: destinationIndexPath.row)
        self.tasks = tasks
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var task = self.tasks[indexPath.row]
        task.done = !task.done
        self.tasks[indexPath.row] = task
        self.tableView.reloadRows(at: [indexPath], with: .automatic) // 애니메이션
    }
}
