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
    @State private var filterType = ["Personal", "Business"]
    @State private var sortOrder = [
        SortDescriptor(\ExpenseItem.name),
        SortDescriptor(\ExpenseItem.amount)
    ]
    
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            ExpensesView(filterType: filterType, sortOrder: sortOrder)
            .navigationTitle("iExpense")
            .toolbar {
                NavigationLink("Add Expense") {
                    AddView()
                }
                
                Menu("Sort", systemImage: "line.3.horizontal.decrease.circle") {
                    Picker("Filter", selection: $filterType) {
                        Text("All")
                            .tag(["Personal", "Business"])
                        
                        Text("Personal")
                            .tag(["Personal"])
                        
                        Text("Business")
                            .tag(["Business"])
                    }
                }
                
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort", selection: $sortOrder) {
                        Text("Sort by Name")
                            .tag([
                                SortDescriptor(\ExpenseItem.name),
                                SortDescriptor(\ExpenseItem.amount)
                            ])
                        
                        Text("Sort by Amount")
                            .tag([
                                SortDescriptor(\ExpenseItem.amount),
                                SortDescriptor(\ExpenseItem.name)
                            ])
                    }
                }
            }
        }
    }
    
    
}

#Preview {
    ContentView()
}
