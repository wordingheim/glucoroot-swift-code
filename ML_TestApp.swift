import SwiftUI

@main
struct ML_TestApp: App {
    
    @State private var isLoading = true
    
    var body: some Scene {
        WindowGroup {
            if isLoading {
                LoadingScreen()
                    .onAppear(perform: loadData)
            } else {
                CV()
            }
        }
    }
    
    // Simulate a delay for loading data or performing setup tasks
    func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isLoading = false
        }
    }
}


