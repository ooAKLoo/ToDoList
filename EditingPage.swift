//
//  EditingPage.swift
//  ToDoListx
//
//  Created by 杨东举 on 2020/10/29.
//

import SwiftUI

struct EditingPage: View {
    
    @EnvironmentObject var UserData:ToDo
    @Environment(\.presentationMode) var presentation
    
    @State var title:String=""
    @State var dueDate:Date=Date()
    
    var id:Int?=nil
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("事项")){
                    TextField("事项内容", text: self.$title)
                    DatePicker(selection: self.$dueDate, label: { Text("截止时间") })
                }
                Section{
                    Button(action:{
                        if self.id==nil{
                            self.UserData.add(date:SingleToDo(title: self.title, dueDate: self.dueDate))
                        }
                        else{
                            self.UserData.edit(id: self.id!, data: SingleToDo(title: self.title, dueDate: self.dueDate))
                        }
                        self.presentation.wrappedValue.dismiss()
                    }){
                        Text("确认")
                    }
                    Button(action:{
                        self.presentation.wrappedValue.dismiss()
                    }){
                    Text("取消")
                    }
                }
                
            }
            .navigationTitle("添加")
        }
    }
}

struct EditingPage_Previews: PreviewProvider {
    static var previews: some View {
        EditingPage()
    }
}
