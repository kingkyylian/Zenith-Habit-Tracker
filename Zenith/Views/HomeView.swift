import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.createdAt, order: .reverse) private var habits: [Habit]
    @State private var showingAddHabit = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        headerSection
                        
                        if habits.isEmpty {
                            emptyStateSection
                        } else {
                            ForEach(habits) { habit in
                                HabitCard(habit: habit)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Zenith")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddHabit = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                AddHabitView()
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Merhaba,")
                    .font(.title2.bold())
                Text("Bugün kendini nasıl hissetmek istersin?")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
    
    private var emptyStateSection: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundStyle(.blue.opacity(0.3))
            
            Text("Henüz bir alışkanlığın yok.")
                .font(.headline)
            
            Button("İlk Alışkanlığını Ekle") {
                showingAddHabit = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            .clipShape(Capsule())
        }
        .padding(.top, 100)
    }
}

struct HabitCard: View {
    let habit: Habit
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Label {
                    Text(habit.title)
                        .font(.headline)
                } icon: {
                    Image(systemName: habit.icon)
                        .foregroundStyle(Color(hex: habit.color))
                }
                
                Text("Her gün \(habit.frequency) kez")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button {
                toggleCompletion()
            } label: {
                Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 28))
                    .foregroundStyle(habit.isCompletedToday ? .green : .secondary.opacity(0.5))
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private func toggleCompletion() {
        let today = Calendar.current.startOfDay(for: Date())
        if habit.isCompletedToday {
            habit.completedDays.removeAll { Calendar.current.isDate($0, inSameDayAs: today) }
        } else {
            habit.completedDays.append(Date())
            // Haptic Feedback
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        }
    }
}

// SwiftUI Color extension for Hex Support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
