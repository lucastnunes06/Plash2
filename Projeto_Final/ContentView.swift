import SwiftUI

struct ContentView: View {
    
    @State var fontSize: CGFloat = 33
    
    var body: some View {
        TabView {

            NavigationStack {
                MonitorView(fontSize: $fontSize)
            }
            .tabItem {
                Label("Monitor", systemImage: "drop.circle.fill")
            }

            NavigationStack {
                HistoricoView(viewModel: ViewModel(), fontSize: $fontSize)
            }
            .tabItem {
                Label("Histórico", systemImage: "chart.bar.fill")
            }

            NavigationStack {
                CalculoView(fontSize: $fontSize)
            }
            .tabItem {
                Label("Calculo", systemImage: "note.text")
            }

            NavigationStack {
                DicasView(fontSize: $fontSize)
            }
            .tabItem {
                Label("Dicas", systemImage: "lightbulb.fill")
            }
        }
        .tint(Color.black)
    }
}

#Preview {
    ContentView()
}
