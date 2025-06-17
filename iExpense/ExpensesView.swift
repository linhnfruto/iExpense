//
//  ExpensesView.swift
//  iExpense
//
//  Created by Linh Nguyen on 18/6/25.
//

import SwiftUI
import SwiftData

struct ExpensesView: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [ExpenseItem]
    
    var body: some View {
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
    }
    
    init(filterType: [String], sortOrder: [SortDescriptor<ExpenseItem>]) {
        _expenses = Query(filter: #Predicate<ExpenseItem> { user in
            filterType.contains(user.type)
        }, sort: sortOrder)
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
    ExpensesView(filterType: ["Personal", "Business"], sortOrder: [
        SortDescriptor(\ExpenseItem.name),
        SortDescriptor(\ExpenseItem.amount)
    ])
}
