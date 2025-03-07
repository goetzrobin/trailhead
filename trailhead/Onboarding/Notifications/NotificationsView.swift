//
//  NotificationsView.swift
//  trailhead
//
//  Created by Robin Götz on 3/4/25.
//

import SwiftUI

struct NotificationsView: View {
    let onDone: () -> Void
    @State var manager = NotificationManager()
    var body: some View {
        if manager.setupState == .selectingFrequency || manager.setupState == .needsPermission {
            NotificationFrequencySelectView(
                manager: manager,
                onSkip: self.onDone
            )
        } else if manager.setupState.isConfiguringTimes {
            NotificationTimeSelectView(manager: manager, onSkip: self.onDone)
        } else if manager.setupState == .completed {
            NotificaitonsSuccessView {
                self.onDone()
            }
        }
    }
}

struct NotificationTimeSelectView: View {
    let manager: NotificationManager
    let title = "What time do you want to be reminded?"
    let onSkip: () -> Void
    
    @State var notificationTimeToEdit: NotificationTime?
    @State var savingPermissions = false

    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 5)
            VStack {
                ForEach(
                    self.manager.currentNotificationTimes,
                    id: \.id
                ) { time in
                    Button(action: {
                        self.notificationTimeToEdit = time
                    }, label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(time.label)
                                    .font(.title)
                                    .bold()
                                Text(time.time, style: .time)
                                    .foregroundStyle(.secondary)
                                    .font(.title3)
                            }
                            Spacer()
                            Image(systemName: "pencil")
                                .font(.system(size: 20))
                        }
                        .contentShape(Rectangle())
                    })
                    .buttonStyle(.plain)
                }
            }
            Spacer()
            ContinueButtons(
                isContinueEnabled: true,
                onContinue: {
                    Task {
                        savingPermissions = true
                        let isSuccess = await self.manager.requestPermission()
                        await self.manager.scheduleNotifications()
                        savingPermissions = false
                    }
                },
                onSkip: self.onSkip,
                customContinueLabel: savingPermissions ? "Saving" : nil
            )
        }.padding()
            .sheet(item: self.$notificationTimeToEdit) { item in
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.label)
                                .font(.title)
                                .bold()
                            Text(item.time, style: .time)
                                .foregroundStyle(.secondary)
                                .font(.title3)
                        }
                        Spacer()
                        Button(action: {
                            self.notificationTimeToEdit = nil
                        }, label: {
                            Image(systemName: "xmark")
                        })
                    }
                    
                    
                    DatePicker(
                        "Time",
                        selection: Binding(get: {item.time}, set: {
                            self.notificationTimeToEdit?.time = $0
                        }),
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .padding(.horizontal)
                    
                    Spacer()
                    Button(
action: {
                        if let time = self.notificationTimeToEdit?.time {
                            self.manager
                                .updateNotificationTime(
                                    for: item.id,
                                    with: time
                                )
                            self.notificationTimeToEdit = nil
                        }
},
label: {
    Text("Save").frame(maxWidth: .infinity)
})
                    .buttonStyle(.jPrimary)
                }
                .padding()
                .tint(.jAccent)
                .presentationDetents([.medium])
            }
    }
}
    
struct NotificationFrequencySelectView: View {
    let manager: NotificationManager
    let title = "How often do you want to check in?"
    let subtitle = "By creating repetition with your check-ins you can uncover more about your emotional self."
    let onSkip: () -> Void

    @State var selectedFrequency: CheckInFrequency? = nil
    
    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 5)
            
            Text(subtitle)
                .opacity(0.7)
                .padding(.bottom, 20)
            
            VStack(alignment: .center) {
                HStack(spacing: 20) {
                    frequencyToggle(for: .one)
                    frequencyToggle(for: .two)
                }
                HStack(spacing: 20) {
                    frequencyToggle(for: .three)
                    frequencyToggle(for: .four)
                }
            }
            .padding()
            
            Spacer()
            
            ContinueButtons(
                isContinueEnabled: self.selectedFrequency != nil,
                onContinue: {
                    if let selectedFrequency = self.selectedFrequency {
                        self.manager.selectFrequency(selectedFrequency)
                    }
                },
                onSkip: self.onSkip
            )
            
        }
        .padding(.horizontal)
    }
    
    // MARK: - Toggle Builder
    private func frequencyToggle(for frequency: CheckInFrequency) -> some View {
        Toggle(isOn: Binding(
            get: { selectedFrequency == frequency },
            set: { isSelected in
                selectedFrequency = isSelected ? frequency : nil
            }
        )) {
            Text(frequency.description)
        }
        .toggleStyle(JournaiCircularToggleStyle())
    }
}

struct ContinueButtons: View {
    let customContinueLabel: String?
    let isContinueEnabled: Bool
    let onContinue: () -> Void
    let onSkip: () -> Void
    
    init(
        isContinueEnabled: Bool,
        onContinue: @escaping () -> Void,
        onSkip: @escaping () -> Void,
        customContinueLabel: String? = nil
    ) {
        self.isContinueEnabled = isContinueEnabled
        self.onContinue = onContinue
        self.onSkip = onSkip
        self.customContinueLabel = customContinueLabel
    }
    
    var body: some View {
        Button(action: self.onContinue) {
            Text(customContinueLabel ?? "Continue")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.jPrimary)
        .disabled(!isContinueEnabled)
        .padding(.bottom, 10)
        
        Button("Not right now") {
            self.onSkip()
        }
        .buttonStyle(.plain)
        .opacity(0.8)
        .padding(.bottom)
    }
}

#Preview {
    NotificationsView {
        print("Done")
    }
}

