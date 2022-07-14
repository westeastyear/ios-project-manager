//
//  RealmManager.swift
//  ProjectManager
//
//  Created by Donnie, Grumpy on 2022/07/08.
//

import RealmSwift

struct RealmManager {
    private let realm = try? Realm()
    
    func create(task: Task) {
        do {
            try realm?.write {
                realm?.add(task)
            }
        } catch {
            print("중복된 내용입니다.")
        }
    }
    
    func fetchTasks(type: TaskType) -> [Task] {
        let result = realm?.objects(Task.self).where {
            $0.taskType == type
        }
        guard let tasks = result else { return [] }
        return tasks.filter { $0 == $0 }
    }
    
    func update(task: Task) {
        do {
            try realm?.write {
                realm?.add(task, update: .modified)
            }
        } catch {
            print("업데이트를 실패하였습니다")
        }
    }
    
    func delete(task: Task) {
        do {
            try realm?.write {
                realm?.delete(task)
            }
        } catch {
            print("삭제에 실패했어요")
        }
    }
    
    func change(task: Task, targetType: TaskType) {
        do {
            try realm?.write {
                task.taskType = targetType
                realm?.add(task, update: .modified)
            }
        } catch {
            print("타입변환을 실패하였습니다")
        }
    }
}
