//
//  CoreDataBootcamp.swift
//  SwiftUIBootCamp
//
//  Created by Cihangir Tuncer on 6.11.2022.
//

import SwiftUI
import CoreData


class CoreDataViewModel: ObservableObject {
    
    let container : NSPersistentContainer
    @Published var savedEntities : [FruitEntity] = []
    
    init() {
        container = NSPersistentContainer(name: "CoreDataExample")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("ERROR LOADING CORE DATA. \(error)")
            }
        }
        fetchFruits()
    }
   func fetchFruits(){
        let request = NSFetchRequest<FruitEntity>(entityName: "FruitEntity")
       do{
          savedEntities =  try container.viewContext.fetch(request)
       }catch let error{
           print("Error fetching..\(error)")
       }
    }
 
    func addFruit(text : String) {
        let newFruit = FruitEntity(context: container.viewContext)
        newFruit.name = text
        saveData()
    }
    
    func deleteFruit(indexSet: IndexSet) {
        guard let index = indexSet.first else {return}
        let entity = savedEntities[index]
        container.viewContext.delete(entity)
        saveData()
    }
    
    func updateFruit(entity : FruitEntity, newNameFruit : String){
        entity.name = newNameFruit
        saveData()
    }
    
    func saveData() {
        do{
            try container.viewContext.save()
            fetchFruits()
        }catch let error{
            print("Error saving... \(error)")
        }
    }
    
}



struct CoreDataExample: View {
    @StateObject var vm = CoreDataViewModel()
    @State var textFieldText : String = ""
    @State var isPresent : Bool = false
    @State var textFieldTextAlertUpdate : String = ""

    var body: some View {
        NavigationStack{
            VStack {
                TextField("Add fruit here...", text: $textFieldText)
                    .font(.headline)
                    .padding(.leading)
                    .frame(height: 55)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Button {
                    guard !textFieldText.isEmpty else {return }
                    vm.addFruit(text: textFieldText)
                    textFieldText = ""
                } label: {
                    Text("Button")
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.cyan)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                    
                List {
                    ForEach(vm.savedEntities) { entity in
                        Text(entity.name ?? "NO NAME")
                            .onTapGesture {
                                isPresent.toggle()
                            }
                            .alert("Please add a fruit name", isPresented: $isPresent, actions: {
                                VStack {
                                    TextField("Write here..", text:$textFieldTextAlertUpdate)
                                    
                                }
                                Button {
                                    if textFieldTextAlertUpdate != ""{
                                        vm.updateFruit(entity: entity, newNameFruit: textFieldTextAlertUpdate )
                                        textFieldTextAlertUpdate = ""
                                    }
                                    
                                } label: {
                                    Text("Save")
                                                                    }
                                Button {
                                    
                                } label: {
                                    Text("Cancel")
                                }

                                



                                                            })
                    }
                    .onDelete(perform: vm.deleteFruit)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Fruits")
        }
        
    }
}

struct CoreDataBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataExample()
    }
}
