<<<<<<< HEAD
//
//  ContentView.swift
//  Zing
//
//  Created by Nathan Drake on 7/26/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
=======
import SwiftUI

struct ContentView: View {
    @State private var habits: [Habit] = [
        Habit(name: "Drink Water", icon: "💧"),
        Habit(name: "Exercise", icon: "🏃‍♂️"),
        Habit(name: "Read", icon: "📚"),
        Habit(name: "Meditate", icon: "🧘‍♀️")
    ]
    @State private var showingAddHabit = false
    @State private var newHabitName = ""
    @State private var newHabitIcon = "⭐"
    
    let icons = ["⭐", "💧", "🏃‍♂️", "📚", "🧘‍♀️", "🎯", "💪", "🎨", "🍎", "😴", "☀️", "🌱"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ], spacing: 16) {
                    ForEach(habits.indices, id: \.self) { index in
                        HabitCard(habit: $habits[index])
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .navigationTitle("My Habits")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("+") {
                        showingAddHabit = true
                    }
                    .font(.title2)
                    .fontWeight(.bold)
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                NavigationView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Habit Name")
                                .font(.headline)
                            TextField("Enter habit name", text: $newHabitName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Choose Icon")
                                .font(.headline)
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 6), spacing: 12) {
                                ForEach(icons, id: \.self) { icon in
                                    Button(action: {
                                        newHabitIcon = icon
                                    }) {
                                        Text(icon)
                                            .font(.title2)
                                            .frame(width: 44, height: 44)
                                            .background(newHabitIcon == icon ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .navigationTitle("Add Habit")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                showingAddHabit = false
                                newHabitName = ""
                                newHabitIcon = "⭐"
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Add") {
                                if !newHabitName.isEmpty {
                                    habits.append(Habit(name: newHabitName, icon: newHabitIcon))
                                    showingAddHabit = false
                                    newHabitName = ""
                                    newHabitIcon = "⭐"
                                }
                            }
                            .disabled(newHabitName.isEmpty)
                        }
                    }
                }
            }
        }
    }
}

struct HabitCard: View {
    @Binding var habit: Habit
    
    var body: some View {
        VStack(spacing: 12) {
            Text(habit.icon)
                .font(.system(size: 40))
            
            Text(habit.name)
                .font(.headline)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Text("\(habit.currentStreak) day streak")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Button(action: {
                if habit.isCompletedToday {
                    habit.markIncomplete()
                } else {
                    habit.markComplete()
                }
            }) {
                HStack(spacing: 4) {
                    Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(habit.isCompletedToday ? .green : .gray)
                        .font(.system(size: 16))
                    Text(habit.isCompletedToday ? "Done!" : "Mark Done")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(habit.isCompletedToday ? Color.green.opacity(0.1) : Color.gray.opacity(0.1))
                .cornerRadius(16)
            }
        }
        .padding(16)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 180)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct Habit {
    let id = UUID()
    var name: String
    var icon: String
    private var completedDates: Set<String> = []
    var currentStreak: Int = 0
    private var lastCompletedDate: String?
    
    init(name: String, icon: String) {
        self.name = name
        self.icon = icon
    }
    
    var isCompletedToday: Bool {
        let today = DateFormatter.dateKey.string(from: Date())
        return completedDates.contains(today)
    }
    
    mutating func markComplete() {
        let today = DateFormatter.dateKey.string(from: Date())
        completedDates.insert(today)
        updateStreak()
    }
    
    mutating func markIncomplete() {
        let today = DateFormatter.dateKey.string(from: Date())
        completedDates.remove(today)
        updateStreak()
    }
    
    private mutating func updateStreak() {
        let today = Date()
        var streak = 0
        let calendar = Calendar.current
        
        for i in 0..<365 { // Check up to a year back
            let date = calendar.date(byAdding: .day, value: -i, to: today)!
            let dateKey = DateFormatter.dateKey.string(from: date)
            
            if completedDates.contains(dateKey) {
                streak += 1
            } else {
                break
            }
        }
        
        currentStreak = streak
    }
}

extension DateFormatter {
    static let dateKey: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
>>>>>>> 1b9ec69 (Initial Commit)
}
