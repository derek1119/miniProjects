//
//  DataManager.swift
//  Memo
//
//  Created by Sh Hong on 2021/05/25.
//

import Foundation
import CoreData

class DataManager {
    //DataManager class를 싱글톤으로 구현한다?
    //Singleton은 iOS에서 자주 활용하는 패턴이다.
    
    static let shared = DataManager()
    //공유 인스턴스를 저장할 타입 프로퍼티 추가
    private init() {
        
    }
    //기본 생성자를 추가하고 프라이빗으로 선언
    //위처럼 하면 앱 전체에서 하나의 인스턴스를 공유할 수 있다.
    
    var mainContext : NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    //Core Data에서 실행하는 대부분의 작업은 context객체가 담당한다.
    
    //메모를 데이터베이스에서 읽어오는 코드 구현
    var memoList = [Memo]()
    //우선 메모를 저장할 배열 선언하고 빈 배열로 초기화
    
    func fetchMemo() {
        let request: NSFetchRequest<Memo> = Memo.fetchRequest()
        
        let sortByDateDesc = NSSortDescriptor(key: "insertDate", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        //코어 데이터가 리턴해주는 데이터는 기본적으로 정렬되어있지 않다. 그래서 sortDescriptor를 만들고 원하는 방식으로 정렬하기 위한 상수
        //최근 메모가 먼저 표시되도록 날짜를 내림차순으로 정렬(ascending : false)
        
        //위에서 만든 fetch request를 실행하고 데이터를 가져오는 코드
        do {
           memoList = try mainContext.fetch(request)
            //fetch 메소드가 리턴하는 결과는 memoList 배열에 저장
        } catch {
            print(error)
        }
        //fetch메소드를 사용할때는 context객체(어떤 행위가 일어나게 하기 위한 정보의 통칭)가 제공하는 fetch메소드를 사용한다. 그런데 fetch메소드의 자동완성을 살펴보면 throws 키워드가 있다. 이런 메소드는 실행했을 때 예외 상황이 발생할 수도 있다는 뜻이다. 그래서 일반 메소드처럼 사용해서는 안되고 do - catch 블럭을 사용해서 호출해야한다.
        
    }
    // 데이터를 데이터 베이스에서 읽어오는 것을 표현하는 다양한 용어가 있는데 iOS에서는 이것을 fetch라고 한다.
    // 데이터 베이스에서 데이터를 읽어올때는 먼저 fetch Request를 만들어야한다.
    
    func addNewMemo(_ memo : String) {
        let newMemo = Memo(context: mainContext)
        //여기서 Memo는 Core Data가 만들어준 클래스이다. 따라서 새로운 인스턴스를 만들 때, 생성자로 context를 전달해야한다.
        //이 방법으로 데이터 베이스에 메모를 저장하는데 필요한 비어있는 인스턴스 생성
        //아래는 비어있는 메모 채우기
        newMemo.content = memo
        newMemo.insertDate = Date()
        //이렇게만 한다고 메모가 데이터 베이스에 저장되는 것은 아니다. 이를 하기 위해서는 context를 저장해야하는데
        //context를 저장하는 메소드는 아래 메소드이다.
        
        memoList.insert(newMemo, at: 0)
        //메모리스트에 추가하여 업데이트까지 
        
        saveContext()
    }
    
    
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Memo")
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
