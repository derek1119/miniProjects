//
//  DataManager.swift
//  SHMemo
//
//  Created by Sh Hong on 2021/06/08.
//

import Foundation
import CoreData

class DataManager {
    static let shared = DataManager()
    private init() {
        //싱글톤
    }
    
    var mainContext : NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    //메모 저장을 위한 배열 생성
    var memoList = [Memo]()
    
    //데이터 베이스에서 데이터 읽어오기
    func fetchMemo() {
        let request: NSFetchRequest<Memo> = Memo.fetchRequest()
        
        let sortedByDateDesc = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortedByDateDesc]
        
        do {
            memoList = try mainContext.fetch(request)
        } catch {
            print(error)
        }
    }
    
    func addNewMemo(_ memo: String?, _ title: String?) {
        let newMemo = Memo(context: mainContext)
        newMemo.content = memo
        newMemo.title = title
        newMemo.date = Date()
        
        saveContext()
    }
    
    func deleteMemo(_ memo: Memo?) {
        if let memo = memo {
            mainContext.delete(memo)
            saveContext()
        }
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
  
        let container = NSPersistentContainer(name: "SHMemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
