import SwiftUI
import UserNotifications
import Observation

// MARK: - Models

struct NotificationTime: Identifiable, Equatable {
    let id = UUID()
    var time: Date
    var label: String
}

enum CheckInFrequency: Int, CaseIterable, Identifiable {
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    
    var id: Int { rawValue }
    
    var description: String {
        switch self {
        case .one: return "1 per day"
        case .two: return "2 per day (recommended)"
        case .three: return "3 per day"
        case .four: return "4 per day"
        }
    }
}

// Separate default times logic - easier to maintain
struct DefaultNotificationTimes {
    static func forFrequency(_ frequency: CheckInFrequency) -> [NotificationTime] {
        let defaultTimes = [
            (8, 15, "Morning"),
            (12, 0, "Lunchtime"),
            (18, 30, "Evening"),
            (21, 0, "Night")
        ]
        
        // Just take first N times based on frequency
        return Array(defaultTimes.prefix(frequency.rawValue))
            .map { hour, minute, label in
                let date = Calendar.current.date(
                    bySettingHour: hour,
                    minute: minute,
                    second: 0,
                    of: Date()
                ) ?? Date()
                return NotificationTime(time: date, label: label)
            }
    }
}

// MARK: - Setup State

// Unified state representation - much easier to follow flow
enum NotificationSetupState: Equatable {
    case needsPermission
    case selectingFrequency
    case configuringTimes(
        frequency: CheckInFrequency,
        times: [NotificationTime]
    )
    case completed
 

    static func == (lhs: NotificationSetupState, rhs: NotificationSetupState) -> Bool {
        switch (lhs, rhs) {
        case (.needsPermission, .needsPermission),
            (.selectingFrequency, .selectingFrequency),
            (.completed, .completed):
            return true
        case (
            .configuringTimes,
            .configuringTimes
        ): // ✅ Ignore associated values
            return true
        default:
            return false
        }
    }
    
    var isConfiguringTimes: Bool {
         if case .configuringTimes = self { return true }
         return false
     }

}

// MARK: - Manager

@Observable class NotificationManager {
    private(set) var setupState: NotificationSetupState = .selectingFrequency
    private(set) var permissionStatus: UNAuthorizationStatus = .notDetermined
    
    init() {
        checkPermissionStatus()
    }
    
    // Check if we have permission to show notifications
    func checkPermissionStatus() {
        Task {
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            await MainActor.run {
                self.permissionStatus = settings.authorizationStatus
                updateSetupStateBasedOnPermission()
            }
        }
    }
    

    
    // UI action: Frequency selected
    func selectFrequency(_ frequency: CheckInFrequency) {
        let times = DefaultNotificationTimes.forFrequency(frequency)
        setupState = .configuringTimes(frequency: frequency, times: times)
    }
    
    // UI action: Update a specific notification time
    func updateNotificationTime(for id: UUID, with newTime: Date) {
        guard case .configuringTimes(let frequency, var times) = setupState,
        let index = times.firstIndex(where: {$0.id == id}), index < times.count else { return }
        
        times[index].time = newTime
        setupState = .configuringTimes(frequency: frequency, times: times)
    }
    
    // UI action: Schedule notifications button tapped
    func scheduleNotifications() async {
        // First check if notifications are authorized
        if permissionStatus != .authorized {
            let granted = await requestPermission()
            if !granted { return }
        }
        
        // Safely extract times from state
        guard case .configuringTimes(_, let times) = setupState else { return }
        
        // Clear existing notifications
        UNUserNotificationCenter
            .current()
            .removeAllPendingNotificationRequests()
        
        // Schedule each notification
        var allSucceeded = true
        for (index, time) in times.enumerated() {
            do {
                try await scheduleNotification(time: time, index: index)
            } catch {
                print(
                    "Failed to schedule notification: \(error.localizedDescription)"
                )
                allSucceeded = false
            }
        }
        
        // Update UI state on main thread
        await MainActor.run { [allSucceeded] in
            if allSucceeded {
                setupState = .completed
            }
        }
    }
    
    // UI action: Skip notifications
    func skipNotifications() {
        setupState = .completed
    }
    
    // UI action: request permission 
    func requestPermission() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
            
            await MainActor.run {
                self.permissionStatus = granted ? .authorized : .denied
            }
            return granted
        } catch {
            print(
                "Error requesting notification permission: \(error.localizedDescription)"
            )
            return false
        }
    }
    
    private func updateSetupStateBasedOnPermission() {
        if permissionStatus == .notDetermined || permissionStatus == .denied {
            setupState = .needsPermission
        } else if case .configuringTimes = setupState {
            // Keep current state if configuring times
        } else {
            setupState = .selectingFrequency
        }
    }
    
    // Array of check-in messages
    private let checkInMessages: [(title: String, body: String)] = [
        (title: "Quick Check-In", body: "How's your energy today? Take a moment to reflect."),
        (title: "Moment of Clarity", body: "Step back from the daily grind. What's one thing you're proud of today?"),
        (title: "Just Breathe", body: "Athletes know recovery matters. Take 2 minutes to reset your mindset."),
        (title: "Time for You", body: "The strength that makes you great comes from knowing yourself."),
        (title: "Your Journey Continues", body: "Small moments of reflection build into major growth.")
    ]


    private func scheduleNotification(time: NotificationTime, index: Int) async throws {
        let content = UNMutableNotificationContent()
        
        // Randomly select a message from our array
        let randomMessage = checkInMessages[index]
        content.title = randomMessage.title
        content.body = randomMessage.body
        content.sound = .default
        
        let components = Calendar.current.dateComponents(
            [.hour, .minute],
            from: time.time
        )
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: components,
            repeats: true
        )
        let request = UNNotificationRequest(
            identifier: "journaiCheckInNotification\(index)",
            content: content,
            trigger: trigger
        )
        
        print("Requested \(request)")
        
        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print(error)
        }
    }
    
    // Helper to get current notification times
    var currentNotificationTimes: [NotificationTime] {
        if case .configuringTimes(_, let times) = setupState {
            return times
        }
        return []
    }
    
    // Helper to get current frequency
    var currentFrequency: CheckInFrequency? {
        if case .configuringTimes(let frequency, _) = setupState {
            return frequency
        }
        return nil
    }
}
