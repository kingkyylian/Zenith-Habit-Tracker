import SwiftUI
import SwiftData

@main
struct ZenithApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: Habit.self)
    }
}
