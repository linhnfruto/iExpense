//
//  iExpenseApp.swift
//  iExpense
//
//  Created by Linh Nguyen on 7/3/25.
//

import SwiftUI
import SwiftData

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ExpenseItem.self)
    }
}
