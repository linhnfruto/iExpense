//
//  ContentView.swift
//  iExpense
//
//  Created by Linh Nguyen on 7/3/25.
//
import SwiftUI
import SwiftData

struct StyledAmount: View {
    var amount: Double
    
    var body: some View {
        if amount >= 500_000 {
            Text(amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .redAmountStyle()
        } else if amount >= 100_000 {
            Text(amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .greenAmountStyle()
        } else {
            Text(amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .blueAmountStyle()
        }
    }
}
        
struct blueAmount: ViewModifier {
    func body(content: Content) -> some View {
        content
            .italic()
            .foregroundStyle(.blue)
    }
}

struct greenAmount: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.green)
    }
}

struct redAmount: ViewModifier {
    func body(content: Content) -> some View {
        content
            .bold()
            .foregroundStyle(.red)
    }
}

extension View {
    func blueAmountStyle() -> some View {
        modifier(blueAmount())
    }
    
    func greenAmountStyle() -> some View {
        modifier(greenAmount())
    }
    
    func redAmountStyle() -> some View {
        modifier(redAmount())
    }
}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query() var expenses: [ExpenseItem]
    
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            List {
                let typeList = getTypeList()
                
                ForEach(typeList, id: \.self) { type in
                    Section(type) {
                        ForEach(expenses) { item in
                            if item.type == type {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                            .font(.headline)
                                    }
                                    Spacer()
                                    StyledAmount(amount: item.amount)
                                }
                            }
                        }
                        .onDelete(perform: removeItems)
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                NavigationLink("Add Expense") {
                    AddView()
                }
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        for offset in offsets {
            let expenseItem = expenses[offset]
            modelContext.delete(expenseItem)
        }
    }
    
    func getTypeList() -> [String] {
        Array(Set(expenses.map(\.type))).sorted()
        
    }
}

#Preview {
    ContentView()
}
