//
//  item.swift
//  ToDoListx
//
//  Created by 杨东举 on 2020/10/29.
//

import Foundation

var encoder=JSONEncoder()
var decoder=JSONDecoder()

class ToDo:ObservableObject{
   @Published var ToDoList:[SingleToDo]
    var count:Int=0
    
    init() {
        self.ToDoList=[]
    }
    init(data:[SingleToDo]) {
        self.ToDoList=[]
        for item in data{
            self.ToDoList.append(SingleToDo(id:self.count, title:item.title,dueDate: item.dueDate,isChecked: item.isChecked))
            count+=1
        }
    }
    func add(date:SingleToDo){
        self.ToDoList.append(SingleToDo(id:self.count, title:date.title,dueDate: date.dueDate))
        self.count+=1
        self.sort()
        self.store()
    }
    func edit(id:Int,data:SingleToDo){
        self.ToDoList[id].title=data.title
        self.ToDoList[id].dueDate=data.dueDate
        self.ToDoList[id].isChecked=false
        self.sort()
        self.store()
    }
    func sort(){
        self.ToDoList.sort(by: { (data1, data2) -> Bool in
            return data1.dueDate.timeIntervalSince1970<data2.dueDate.timeIntervalSince1970
        })
        for i in 0..<self.ToDoList.count{
            self.ToDoList[i].id=i
        }
    }
    func delete(id:Int){
        self.ToDoList[id].deleted=true
        self.sort()
        self.store()
    }
    func finished(id:Int){
        self.ToDoList[id].isChecked.toggle()
        self.store()
    }
    func store(){
        let dataStored=try! encoder.encode(self.ToDoList)
        UserDefaults.standard.setValue(dataStored, forKey: "ToDoList")
    }
}

struct SingleToDo:Identifiable,Codable{
    var id:Int=0
    
    var title:String=""
    var dueDate:Date=Date()
    var isChecked:Bool=false
    var deleted:Bool=false
}

