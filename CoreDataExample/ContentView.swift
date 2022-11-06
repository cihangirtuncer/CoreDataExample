//
//  ContentView.swift
//  CoreDataExample
//
//  Created by Cihangir Tuncer on 6.11.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: FruitEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FruitEntity.name, ascending: true)])
    var fruits : FetchedResults<FruitEntity>
    @State var textFieldText : String = ""
    var body: some View {
        NavigationView {
            VStack(spacing:20) {
                
                TextField("Add fruits here...",text: $textFieldText)
                    .font(.headline)
                    .padding(.leading)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Button {
                    addItem()
                } label: {
                    Text("Button")
                        .font(.headline)
                        .foregroundColor(Color.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .padding()
                }
                .padding(.horizontal)

                List {
                    ForEach(fruits) { fruit in
                            Text(fruit.name ?? "")
                            .onTapGesture {
                                updateItem(fruit: fruit)
                            }
                        
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Fruits")
            .navigationBarItems(leading: EditButton())
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newFruit = FruitEntity(context: viewContext)
            newFruit.name = textFieldText
            saveItems()
            textFieldText = ""
        }
    }
    
    private func updateItem(fruit : FruitEntity){
        withAnimation {
            let currentName = fruit.name ?? ""
            let newName = currentName + "!"
            fruit.name = newName
            saveItems()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
        //    offsets.map { items[$0] }.forEach(viewContext.delete)
            guard let index = offsets.first else {return}
            let fruitEntity = fruits[index]
            viewContext.delete(fruitEntity)
            saveItems()
        }
    }
    
    private func saveItems(){
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
