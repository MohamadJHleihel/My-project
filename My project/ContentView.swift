





import SwiftUI
import UserNotifications

struct Medicine: Identifiable, Codable {
    let id = UUID()
    let name: String
    let timesPerDay: Int
}

struct ContentView: View {
    @State private var medicineName = ""
    @State private var timesPerDay = ""
    @State private var medicines: [Medicine] = []
    let notificationManager = NotificationManager()
    
    private func saveMedicines() {
            if let encodedData = try? JSONEncoder().encode(medicines) {
                UserDefaults.standard.set(encodedData, forKey: "savedMedicines")
            }
        }

        // Function to load medicines from UserDefaults
        private func loadMedicines() {
            if let savedData = UserDefaults.standard.data(forKey: "savedMedicines"),
               let loadedMedicines = try? JSONDecoder().decode([Medicine].self, from: savedData) {
                medicines = loadedMedicines
            }
        }

    var body: some View {
        VStack{
        
            //NavigationView {
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
                            saveMedicines()
                        }
                    }
                    .padding()
                    
                    NavigationLink(
                        destination: MedicineListView(medicines: $medicines),
                        label: {
                            Text("View Medicine List")
                        }
                    )
                    .padding()
                }
                .background(Color.mint)
                .navigationTitle("Medicine Tracker")
                
          //  }
        //.onAppear {
         //   loadMedicines()
           // notificationManager.requestAuthorization()
       // }
        
        
    }
        .onAppear {
            loadMedicines()
            notificationManager.requestAuthorization()
        }
        
    }
    
}


