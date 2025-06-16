import SwiftUI

struct CalculoView: View {
    @Binding var fontSize: CGFloat
    @State private var consumoEmMetrosCubicos: String = ""
   // @State private var valorTotalConta: Double?
    @StateObject private var viewMODEL = ViewModel()
    
    @State var tarifasCaesb = Tarifas(
        faixasAGUA: [
            Faixas(nome:"Faixa 1 (até 7m³)",limiteFAIXA: 7,valorPORmetroCUBICO: 5.57),
            Faixas(nome:"Faixa 2 (8...13m³)",limiteFAIXA: 13,valorPORmetroCUBICO: 9.75),
            Faixas(nome:"Faixa 3 (14...20m³)",limiteFAIXA: 20,valorPORmetroCUBICO: 13.65),
            Faixas(nome:"Faixa 4 (21...28m³)",limiteFAIXA: 28,valorPORmetroCUBICO: 17.55),
            Faixas(nome:"Faixa 5 (29m³...)",limiteFAIXA: 40,valorPORmetroCUBICO: 21.45)
        ],
        tarifaAGUA: 27.83,
        tarifaESGOTO: 27.83,
        valorTotalConta: 0.0
    )
    @State var AUX : Double = 0.0

    var body: some View {
        NavigationStack {
            ZStack{
                LinearGradient(gradient: Gradient(colors: [
                    Color.mint,
                    Color(red: 208/255, green: 255/255, blue: 254/255),
                    Color(red: 208/255, green: 255/255, blue: 254/255),
                    Color(red: 208/255, green: 255/255, blue: 254/255),
                    Color(red: 208/255, green: 255/255, blue: 254/255),
                    Color(red: 208/255, green: 255/255, blue: 254/255),
                    Color.mint
                ]),
                startPoint: .topTrailing,
                endPoint: .bottomLeading)
                .ignoresSafeArea()
                
                LinearGradient(gradient: Gradient(colors: [
                    Color("AzulClaro"),
                Color.white
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
                .ignoresSafeArea()
                VStack(spacing: 20) {

                    HStack {
                        Menu {
                            Text("Tamanho da fonte: ")
                            Button("Pequeno") {fontSize = 20 }
                            Button("Médio") {fontSize = 33 }
                            Button("Grande") {fontSize = 38 }
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

                    Text("Calculadora de Água")
                        .bold()
                        .font(.system(size: fontSize))
                        .padding(.top, 80)

                    VStack(alignment: .leading, spacing: 15) {
                        TextField("Consumo (m³)", text: $consumoEmMetrosCubicos)
                            .keyboardType(.decimalPad)
                            .font(.system(size: fontSize))
                            .padding(12)
                            .background(Color(red: 208/255, green: 255/255, blue: 254/255))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .cornerRadius(8)
                            .padding(.top, 40)

                        Button("Calcular") {
                            calcularGasto()
//                            for i in viewMODEL.cons {
//                              AUX = i.valorTotalConta
//                                print(AUX)
//                            }
                            AUX = tarifasCaesb.valorTotalConta
                            viewMODEL.post(Tarifas(faixasAGUA: tarifasCaesb.faixasAGUA, tarifaAGUA: tarifasCaesb.tarifaAGUA, tarifaESGOTO: tarifasCaesb.tarifaESGOTO,valorTotalConta: AUX ))
                            dismissKeyboard()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.system(size: fontSize))
                        .padding(.top, 10)

                        if (tarifasCaesb.valorTotalConta != nil) {
                            Text("Total da Conta: R$ \(tarifasCaesb.valorTotalConta ,specifier: "%.2f")")
                                .font(.title3)
                                .padding(.top,10)
                        }
                    }
                    .padding()

                    Spacer()
                }
            }
            
        }
    }

    func calcularGasto() {
        guard var ConsumoTotalUsuario = Double(consumoEmMetrosCubicos),ConsumoTotalUsuario >= 0 else{
            self.tarifasCaesb.valorTotalConta = 0.0
            return
        }
        var unidade = 1
        var consumoCalculo = ConsumoTotalUsuario/Double(unidade)
        
        var custoVariavelAgua = 0.0
        var consumoRestante = consumoCalculo
        var limiteInferiorFaixaAtual = 0.0
        
        for faixa in tarifasCaesb.faixasAGUA {
            if consumoRestante <= 0 {
                break
            }

            var volumeMaximoNestaFaixa = Double(faixa.limiteFAIXA) - limiteInferiorFaixaAtual
            var consumoNestaFaixa = min(consumoRestante, volumeMaximoNestaFaixa)
            
            custoVariavelAgua += consumoNestaFaixa * faixa.valorPORmetroCUBICO
            consumoRestante -= consumoNestaFaixa
            
            limiteInferiorFaixaAtual = Double(faixa.limiteFAIXA)
        }
        var custoFIXOagua = tarifasCaesb.tarifaAGUA
        _ = custoVariavelAgua * 1.0
        var custoFIXOesgoto = tarifasCaesb.tarifaESGOTO
        
        tarifasCaesb.valorTotalConta = custoFIXOagua + custoVariavelAgua + custoFIXOesgoto + custoFIXOesgoto
    }
    
    func dismissKeyboard() {
          UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true) // 4
        }
}

#Preview {
    CalculoView(fontSize: .constant(30))
}

