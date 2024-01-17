//
//  MedicineListView.swift
//  My project
//
//  Created by Mohamad Hleihel on 2023-12-08.
//

import SwiftUI
import UserNotifications


struct MedicineListView: View {
    @Binding var medicines: [Medicine]
    let notificationManager = NotificationManager()
   

    var body: some View {
        List{
            ForEach(medicines) { medicine in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(medicine.name)
                                    Spacer()
                                    Button(action: {
                                        if let index = medicines.firstIndex(where: { $0.id == medicine.id }) {
                                            medicines.remove(at: index)
                                            scheduleNotifications(for: medicines)
                                            saveMedicines()
                                        }
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                                Text("\(medicine.timesPerDay) times per day")
                                    .foregroundColor(.gray)
                                    .font(.footnote)
                            }
                        }
                        .onDelete(perform: deleteMedicine)
                
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
                                                         hour: [8, 16])
            case 3:
                notificationManager.scheduleNotification(title: "Take \(medicine.name)",
                                                         body: "It's time for your medication.(3)",
                                                         hour: [8, 14, 20])
            default:
                break
            }
        }
    }
    private func deleteMedicine(at offsets: IndexSet) {
            //medicines.remove(atOffsets: offsets)
            let defaults = UserDefaults.standard
            let key = "savedMedicines"
            defaults.removeObject(forKey: key)
            defaults.synchronize()
            scheduleNotifications(for: medicines)
            saveMedicines()
        }
    private func saveMedicines() {
            if let encodedData = try? JSONEncoder().encode(medicines) {
                UserDefaults.standard.set(encodedData, forKey: "savedMedicines")
            }
        }
}

