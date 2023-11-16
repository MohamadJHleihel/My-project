import SwiftUI
import UserNotifications

struct Medicine: Identifiable {
    let id = UUID()
    let name: String
    let timesPerDay: Int
}

struct ContentView: View {
    @State private var medicineName = ""
    @State private var timesPerDay = ""
    @State private var medicines: [Medicine] = []
    let notificationManager = NotificationManager()

    var body: some View {
        NavigationView {
            VStack {
                TextField("Medicine Name", text: $medicineName)
                                   .textFieldStyle(RoundedBorderTextFieldStyle())
                                   .padding()

                               TextField("Times per Day", text: $timesPerDay)
                                   .textFieldStyle(RoundedBorderTextFieldStyle())
                                   .keyboardType(.numberPad)
                                   .padding()

                               Button("Add Medicine") {
                                   if let times = Int(timesPerDay), !medicineName.isEmpty {
                                       let medicine = Medicine(name: medicineName, timesPerDay: times)
                                       medicines.append(medicine)
                                       medicineName = ""
                                       timesPerDay = ""
                                   }
                               }
                               .padding()

                NavigationLink(
                    destination: MedicineListView(medicines: medicines),
                    label: {
                        Text("View Medicine List")
                    }
                )
                .padding()
            }
            .navigationTitle("Medicine Tracker")
        }
        .onAppear {
            notificationManager.requestAuthorization()
        }
    }
}

struct MedicineListView: View {
    var medicines: [Medicine]
    let notificationManager = NotificationManager()

    var body: some View {
        List(medicines) { medicine in
            VStack(alignment: .leading) {
                            Text(medicine.name)
                            Text("\(medicine.timesPerDay) times per day")
                                .foregroundColor(.gray)
                                .font(.footnote)
                        }
                    }
        .navigationTitle("Medicine List")
        .onAppear {
            scheduleNotifications(for: medicines)
        }
    }

    private func scheduleNotifications(for medicines: [Medicine]) {
        for medicine in medicines {
            switch medicine.timesPerDay {
            case 2:
                notificationManager.scheduleNotification(title: "Take \(medicine.name)",
                                                         body: "It's time for your medication.",
                                                         hour: [8, 18])
            case 3:
                notificationManager.scheduleNotification(title: "Take \(medicine.name)",
                                                         body: "It's time for your medication.",
                                                         hour: [8, 13, 20])
            default:
                break
            }
        }
    }
}

class NotificationManager {
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            if success {
                print("Authorization granted")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func scheduleNotification(title: String, body: String, hour: [Int]) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                content.sound = UNNotificationSound.default

                for hourValue in hour {
                    var dateComponents = DateComponents()
                    dateComponents.hour = hourValue
                    dateComponents.minute = 0

                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                    center.add(request)
                }
            }
        }
    }
}

