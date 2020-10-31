# ToDoList
提醒事件app
ios作业二实验报告
——提醒事项App
一.构思
作品的背景：对于日常的诸多学习、生活事项，没有一款符合我自己个性化、简约的相关app实现日常备忘录的需求，基于此目的设计并完成了该app。
创意：
（1）元素：HStack、VStack、ZStack、BUtton、Image。
（2）交互：基础但符合大众电子产品使用习惯的点击交互方式。
（3）色彩：丰富但颜色协调的多色彩显示，并相应配置了其暗夜模式的色彩。自定义设计创建了Appicon。

二.设计

界面

交互
（1）.添加：由“plus.circle.fill”UI实现，通过点击该图标交互。
（2）.删除：由“trash”UI实现，通过点击该图标交互。
（3）.确认与取消：通过在Button（action）内调用相关类函数实现。
（4）.时间选择：通过DatePicker函数实现相应交互。

三.实现



运行类图


相关功能代码
（1）.存储
 func store(){
        let dataStored=try! encoder.encode(self.ToDoList)
        UserDefaults.standard.setValue(dataStored, forKey: "ToDoList")
    }
（2）.删除
 func delete(id:Int){
        self.ToDoList[id].deleted=true
        self.sort()
        self.store()
    }

（3）.添加
 func add(date:SingleToDo){
        self.ToDoList.append(SingleToDo(id:self.count, title:date.title,dueDate: date.dueDate))
        self.count+=1
        self.sort()
        self.store()
    }

（4）.编辑
  func edit(id:Int,data:SingleToDo){
        self.ToDoList[id].title=data.title
        self.ToDoList[id].dueDate=data.dueDate
        self.ToDoList[id].isChecked=false
        self.sort()
        self.store()
    }

(5).数据类
struct SingleToDo:Identifiable,Codable{
    var id:Int=0
    
    var title:String=""
    var dueDate:Date=Date()
    var isChecked:Bool=false
    var deleted:Bool=false
}

（6）.单个事项卡片
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
                    self.UserDate.check(id: self.index)
                }
        }
        .frame(height:80)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius:10,x:0,y:10)
    }
}

（7）.编辑页
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

四.运营
运维情况
模拟器情况：提醒备忘app在xcode调用simulator模拟运行后，数据持久化功能实现正常，色彩显示各项正常，并支持自动布局能够随着手机的屏幕变化自动调整，各项交互也与预期效果相符合。
真机测试情况：提醒备忘app在装在到手机之后，数据持久化功能实现正常，色彩显示各项正常，并支持自动布局能够随着手机的屏幕变化自动调整，各项交互也与预期效果相符合。

github情况：整体项目源代码以及所有涉及的资源（icon以及在暗夜模式下相关色彩的调整）都已在我个人的github仓库中添加。

测试计划：先推荐给周围的ios系统用户体验，根据用户提出的反馈改进建议，进行斟酌修改，之后在项目调配到一个理想的情况下购买Apple开发者证书并在AppStore上架。

上架：在测试计划完成，并在相应用户反馈下调整优化了软件之后，申请Apple开发者证书上架“DoIt”app。
