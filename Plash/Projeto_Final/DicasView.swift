//
//  DicasView.swift
//  Projeto_Final
//
//  Created by Turma02-19 on 14/05/25.
//

import SwiftUI

struct DicasView: View {
    
    @Binding var fontSize: CGFloat
    @StateObject var gemini = GeminiDicaViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
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
                
                VStack(alignment: .center) {
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
                    
                    Text("Dicas")
                        .font(.system(size: fontSize, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.top, 30)
                    
                    Spacer().frame(height: 100)

                    Group {
                        if gemini.dica.isEmpty {
                            ProgressView("Carregando dica...")
                                .padding()
                        } else {
                            VStack {
                                Text(gemini.dica)
                                    .font(.system(size: fontSize))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .padding()
                            }
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(20)
                            .shadow(radius: 8)
                            .padding(.horizontal, 30)
                        }
                    }
                    
                    Spacer()
                }
                .onAppear {
                    gemini.solicitarDica(tema: "dicas para economizar água")
                }
            }
        }
    }
}

#Preview {
    DicasView(fontSize: .constant(30))
}
