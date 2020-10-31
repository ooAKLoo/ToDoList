//
//  ContentList.swift
//  ToDoListx
//
//  Created by 杨东举 on 2020/10/29.
//

import SwiftUI

func initList() -> [SingleToDo]{
    var output:[SingleToDo]=[]
    if let dataStore=UserDefaults.standard.object(forKey: "ToDoList") as? Data{
        let data=try! decoder.decode([SingleToDo].self,from:dataStore)
        for item in data{
            if !item.deleted{
                output.append(SingleToDo(id: output.count, title: item.title, dueDate: item.dueDate, isChecked: item.isChecked))
            }
        }
    }
    return output
}

struct ContentList: View {
    

    @ObservedObject var UserData: ToDo = ToDo(data: initList())
  
    @State var showEditingPage=false
    var body: some View {
        ZStack {
         NavigationView{
                ScrollView{
                    VStack{
                        ForEach(self.UserData.ToDoList){item in
                            if !item.deleted{
                                SingleView(index: item.id)
                                    .environmentObject(self.UserData)
                                    .padding(.top)
                                    // .padding(.horizontal)
                            }
                        }
                    }
                }
                .navigationTitle("提醒事项")
            }
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Button(action:{
                        self.showEditingPage=true
                    }){ Image(systemName: "plus.circle.fill")
                        .resizable()//调整矢量图大小
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80)
                        .foregroundColor(.blue)
                        .padding(.trailing)
                    }
                    .sheet(isPresented: self.$showEditingPage, content: {
                        EditingPage()
                            .environmentObject(self.UserData)
                    })
                }
            }
        }
    }
}

struct SingleView: View {

    @EnvironmentObject var UserDate:ToDo
    var index:Int//定义该SingleView的两个函数参数
    
    @State var showEditingPage=false
    
    var body: some View{
        HStack{
            Rectangle()
                .frame(width:6)
                .foregroundColor(Color("Color"+String(self.index%5)))
                .padding(.leading)//_________________
            Button(action:{
                self.UserDate.delete(id: self.index)
            }){
                Image(systemName: "trash")
                    .imageScale(/*@START_MENU_TOKEN@*/.medium/*@END_MENU_TOKEN@*/)
                    .padding(.leading)
            }
            Button(action:{
                self.showEditingPage=true
            }){
                Group {
                            VStack(alignment:.leading,spacing:6.0){
                        Text(self.UserDate.ToDoList[index].title)
                            .font(.headline)
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                        Text(self.UserDate.ToDoList[index].dueDate.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        }
                        .padding(.leading)
                        Spacer()
                    }
            }
            .sheet(isPresented: self.$showEditingPage, content: {
                EditingPage(title:self.UserDate.ToDoList[self.index].title,dueDate: self.UserDate.ToDoList[self.index].dueDate,id:self.index)
                    .environmentObject(self.UserDate)
            })
           
            Image(systemName: self.UserDate.ToDoList[index].isChecked ? "checkmark.square.fill" : "square")
                .imageScale(.large)
                .padding(.trailing)
                .onTapGesture{
//                    self.UserDate.ToDoList[index].isChecked.toggle()
                    self.UserDate.finished(id: self.index)
                }
        }
        .frame(height:80)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius:10,x:0,y:10)
    }
}

struct ContentList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentList()
            ContentList()
        }
    }
}

