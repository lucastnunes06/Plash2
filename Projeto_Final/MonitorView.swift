import SwiftUI

struct MonitorView: View {
    
    @Binding var fontSize: CGFloat
    @State private var valorLitrosMinuto: Float = 2.3
    @State private var valorLitrosTotais: Int = 245
    @State private var status: String = "Normal"
    @State private var statusColor: Color = .black
    @State private var mostrarAlertaVazamento = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.mint, Color(red:208/255,green:255/255,blue:254/255), Color(red:208/255,green:255/255,blue:254/255),Color(red:208/255,green:255/255,blue:254/255),Color(red:208/255,green:255/255,blue:254/255),Color(red:208/255,green:255/255,blue:254/255),Color.mint]),
                                               startPoint: .topTrailing,
                                               endPoint: .bottomLeading)
                                    .ignoresSafeArea()
                
                LinearGradient(gradient: Gradient(colors: [Color("AzulClaro"), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(alignment: .center) {
                    HStack {
                        Menu {
                            Text("Tamanho da fonte: ")
                            Button("Pequeno") {fontSize = 20 }
                            Button("Médio") {fontSize = 33 }
                            Button("Grande") {fontSize = 38 }
                            Divider()
                            Button("Simular Vazamento"){
                                simularVazamento()
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                                .padding(.leading, 15)
                        }
                        
                        Spacer()
                        
                        Text("Plash")
                            .font(.system(size: 33, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(colors: [.blue, .green],
                                               startPoint: .leading,
                                               endPoint: .trailing)
                            )
                            .padding(.trailing, 150)
                    }
                    .padding(.top, 20)
                    
                    Divider()
                        .padding(.vertical, 10)
                    
                    Text("Monitor de Água")
                        .font(.system(size: fontSize, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.top, 30)
                    
                    Spacer().frame(height: 30)
                    
                    TimelineView(.animation) { context in
                        let scale = 1.0 + 0.1 * sin(context.date.timeIntervalSinceReferenceDate * 2.0)
                        
                        HStack {
                            Spacer()
                            Image("Image")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 170)
                                .scaleEffect(scale)
                            Spacer()
                        }
                        .padding(.vertical, 10)
                    }
                    
                    Text(String(format: "%.1f L/min", valorLitrosMinuto))
                        .font(.system(size: fontSize))
                        .foregroundColor(.black)
                    
                    VStack(spacing: 15) {
                        Text("Total do dia \t\t\t \(valorLitrosTotais) L")
                            .font(.system(size: fontSize))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 13)
                            .overlay(
                                Rectangle()
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .padding(.bottom, 8)
                            .onChange(of: valorLitrosTotais) { _, _ in
                                atualizarStatus()
                            }
                        
                        Text("Status \t\t\t\t \(status)")
                            .font(.system(size: fontSize))
                            .foregroundColor(statusColor)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 13)
                            .overlay(
                                Rectangle()
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
                    .padding(.top, 15)
                    
                    Spacer()
                }
            }
            .alert("Vazamento Detectado!", isPresented: $mostrarAlertaVazamento) {
                Button("OK", role: .cancel) { }
            }
        }
    }
    
    func atualizarStatus(){
        if valorLitrosTotais > 400 {
            status = "Crítico"
            statusColor = .red
            mostrarAlertaVazamento = true
        } else if valorLitrosTotais > 250 {
            status = "Atenção"
            statusColor = .orange
        } else {
            status = "Normal"
            statusColor = .black
        }
    }
    
    func simularVazamento(){
        let valorLitrosTotaisOriginal = valorLitrosTotais
        
        valorLitrosMinuto += 12.0
        //status = "Vazamento Detectado"
        statusColor = .red
        valorLitrosTotais += 30
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8){
            valorLitrosMinuto = 2.3
            valorLitrosTotais = valorLitrosTotaisOriginal
            atualizarStatus()
        }
    }
}

#Preview {
    MonitorView(fontSize: .constant(30))
}


