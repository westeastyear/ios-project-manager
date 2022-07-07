//
//  ProjectManager - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    
    private var todos: [Task] = [] {
        didSet {
            mainView.setTaskCount(to: todos.count, taskType: .todo)
        }
    }
    private var doings: [Task] = [] {
        didSet {
            mainView.setTaskCount(to: doings.count, taskType: .doing)
        }
    }
    private var dones: [Task] = [] {
        didSet {
            mainView.setTaskCount(to: dones.count, taskType: .done)
        }
    }
    
    private let mainView = MainView()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItems()
        registerTableViewInfo()
        fetchData()
        mainView.setupSubViews()
        mainView.setupUILayout()
    }
    
    private func configureNavigationItems() {
        title = "Project Manager"
        let plusButton = UIBarButtonItem(
            image: UIImage(
                systemName: "plus"
            ),
            style: .plain,
            target: self,
            action: #selector(showNewFormSheetView)
        )
        navigationItem.rightBarButtonItem = plusButton
    }
    
    private func registerTableViewInfo() {
        mainView.todoTableView.delegate = self
        mainView.todoTableView.dataSource = self
        mainView.todoTableView.register(
            TaskTableViewCell.self,
            forCellReuseIdentifier: TaskTableViewCell.identifier
        )
        mainView.doingTableView.delegate = self
        mainView.doingTableView.dataSource = self
        mainView.doingTableView.register(
            TaskTableViewCell.self,
            forCellReuseIdentifier: TaskTableViewCell.identifier
        )
        mainView.doneTableView.delegate = self
        mainView.doneTableView.dataSource = self
        mainView.doneTableView.register(
            TaskTableViewCell.self,
            forCellReuseIdentifier: TaskTableViewCell.identifier
        )
    }
    
    private func fetchData() {
        fetchToDo()
        fetchDoing()
        fetchDone()
    }
    
    let temp: Double = 1600000000
    
    private func fetchToDo() {
        todos = [
            Task(
                title: "책상정리",
                description: "집중이 안될떄 역시나 책상정리",
                date: 1600000000
            ),
            Task(
                title: "라자냐 재료사러 가기",
                description: "프로젝트 회고를 작성하면 내가 이번 프로젝트에서 무엇을 놓쳤는지 명확히 알 수 있어요.",
                date: 1600000000
            ),
            Task(
                title: "일기쓰기",
                description: "난... ㄱㅏ 끔... 일ㄱㅣ를 쓴 ㄷㅏ...",
                date: 1600000000
            ),
            Task(
                title: "설거지하기",
                description: "밥을 먹었으면 응당 해야할 일",
                date: 1800000000
            ),
            Task(
                title: "빨래하기",
                description: "그만 쌓아두고...\n근데...\n여전히 하기 싫다.",
                date: 1800000000
            )
        ]
    }
    
    private func fetchDoing() {
        doings = [
            Task(
                title: "TIL 작성하기",
                description: "TIL을 작성하면\n오늘의 상큼한 마무리도 되고\n나중에 포프폴리오 용으로도 좋죠!",
                date: 1800000000,
                taskType: .doing
            ),
            Task(
                title: "프로젝트 회고 작성",
                description: "프로젝트 회고를 작성하면 내가 이번 프로젝트에서 무엇을 놓쳤는지 명확히 알 수 있어요.",
                date: 1900000000,
                taskType: .doing
            )
        ]
    }
    
    private func fetchDone() {
        dones = [
            Task(
                title: "오늘의 할일 찾기",
                description: "내가 가는 이길이 어디로 가는지 어디로 날 데려가는지 그 곳은 알 수 없지만 알 수 없지만 알 수 없지만 오늘도 난 걸어가고 있네 사람들은 길이 다 정해져있을까?",
                date: 1500000000,
                taskType: .done
            ),
            Task(
                title: "프로젝트 회고 작성",
                description: "노는 게 제일 좋아 친구들 모여라\n언제나 즐거워 개구쟁이 뽀로로\n눈 덮인 숲속 마을 꼬마 펭귄 나가신다.",
                date: 1500000000,
                taskType: .done
            ),
            Task(
                title: "방정리",
                description: "눈감고 그댈 그려요 맘속 그댈 찾았죠 나를 밝혀주는 빛이 보여 영원한 행복을 놓칠 순 없죠 그대 나 보이나요 나를 불러줘요 그대 곁에 있을 거야 너를 사랑해 함께해요.",
                date: 1800000000,
                taskType: .done
            )
        ]
    }
    
    @objc private func showNewFormSheetView() {
        let newTodoFormSheet = UINavigationController(
            rootViewController: NewFormSheetViewController()
        )
        newTodoFormSheet.modalPresentationStyle = .formSheet
        present(newTodoFormSheet, animated: true)
    }
}

// MARK: - TableView Method

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        
        if tableView == mainView.todoTableView {
            return todos.count
        } else if tableView == mainView.doingTableView {
            return doings.count
        } else {
            return dones.count
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        if tableView == mainView.todoTableView {
            return generateCell(
                tableView: mainView.todoTableView,
                indexPath: indexPath,
                task: todos
            )
        } else if tableView == mainView.doingTableView {
            return generateCell(
                tableView: mainView.doingTableView,
                indexPath: indexPath,
                task: doings
            )
        } else {
            return generateCell(
                tableView: mainView.doneTableView,
                indexPath: indexPath,
                task: dones
            )
        }
    }
    
    private func generateCell(
        tableView: UITableView,
        indexPath: IndexPath,
        task: [Task]
    ) -> TaskTableViewCell {
        
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: TaskTableViewCell.identifier
        ) as? TaskTableViewCell {
            cell.setupContents(task: task[indexPath.row])
            return cell
        }
        return TaskTableViewCell()
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        if tableView == mainView.todoTableView {
            showEditFormSheetView(task: todos, indexPath: indexPath)
        } else if tableView == mainView.doingTableView {
            showEditFormSheetView(task: doings, indexPath: indexPath)
        } else {
            showEditFormSheetView(task: dones, indexPath: indexPath)
        }
    }
    
    private func showEditFormSheetView(
        task: [Task],
        indexPath: IndexPath
    ) {
        let editViewController = EditFormSheetViewController()
        editViewController.task = task[indexPath.row]
        let editFormSheet = UINavigationController(
            rootViewController: editViewController
        )
        editFormSheet.modalPresentationStyle = .formSheet
        present(editFormSheet, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            if tableView == mainView.todoTableView {
                todos.remove(at: indexPath.row)
                deleteCell(
                    indexPath: indexPath,
                    at: mainView.todoTableView
                )
            } else if tableView == mainView.doingTableView {
                doings.remove(at: indexPath.row)
                deleteCell(
                    indexPath: indexPath,
                    at: mainView.doingTableView
                )
            } else {
                dones.remove(at: indexPath.row)
                deleteCell(
                    indexPath: indexPath,
                    at: mainView.doneTableView
                )
            }
        }
    }
    
    private func deleteCell(
        indexPath: IndexPath,
        at tableView: UITableView
    ) {
        tableView.deleteRows(
            at: [indexPath],
            with: .fade
        )
    }
}
