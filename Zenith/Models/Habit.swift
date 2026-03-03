import Foundation
import SwiftData

@Model
final class Habit {
    var id: UUID
    var title: String
    var icon: String // SF Symbols name
    var color: String // Hex string
    var frequency: Int // Daily goal (e.g., 1 time per day)
    var completedDays: [Date] // Dates when habit was completed
    var createdAt: Date
    
    init(title: String, icon: String = "circle", color: String = "#007AFF", frequency: Int = 1) {
        self.id = UUID()
        self.title = title
        self.icon = icon
        self.color = color
        self.frequency = frequency
        self.completedDays = []
        self.createdAt = Date()
    }
    
    var isCompletedToday: Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return completedDays.contains { Calendar.current.isDate($0, inSameDayAs: today) }
    }
}
