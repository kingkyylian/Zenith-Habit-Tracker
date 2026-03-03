import SwiftUI
import SwiftData

struct AddHabitView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var selectedIcon = "bolt.fill"
    @State private var selectedColor = "#007AFF"
    @State private var frequency = 1
    
    let icons = ["bolt.fill", "leaf.fill", "drop.fill", "heart.fill", "star.fill", "figure.walk", "book.fill", "moon.fill"]
    let colors = ["#007AFF", "#34C759", "#FF9500", "#FF3B30", "#AF52DE", "#5856D6"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Genel Bilgiler") {
                    TextField("Alışkanlık İsmi", text: $title)
                    Stepper("Günlük Hedef: \(frequency)", value: $frequency, in: 1...10)
                }
                
                Section("Görünüm") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(icons, id: \.self) { icon in
                                Image(systemName: icon)
                                    .padding()
                                    .background(selectedIcon == icon ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        selectedIcon = icon
                                    }
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(colors, id: \.self) { color in
                                Circle()
                                    .fill(Color(hex: color))
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: selectedColor == color ? 4 : 0)
                                    )
                                    .onTapGesture {
                                        selectedColor = color
                                    }
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Yeni Alışkanlık")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Kaydet") {
                        saveHabit()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveHabit() {
        let newHabit = Habit(title: title, icon: selectedIcon, color: selectedColor, frequency: frequency)
        modelContext.insert(newHabit)
        dismiss()
    }
}
