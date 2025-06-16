//
//  HistoricoView.swift
//  Projeto_Final
//
//  Created by Turma02-19 on 14/05/25.
//

import SwiftUI
import Charts
import PDFKit
import UIKit

struct HistoricoView: View {
    @StateObject var viewModel = ViewModel()
    @Binding var fontSize: CGFloat
    @State private var pdfURL: URL? = nil

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
                            Text("Tamanho da fonte:")
                            Button("Pequeno") { fontSize = 20 }
                            Button("Médio") { fontSize = 33 }
                            Button("Grande") { fontSize = 38 }
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

                    Text("Variação do valor da conta")
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.top, 30)

                    Chart {
                        /*
                            ForEach(viewModel.cons, id: \.self) { value in
                                LineMark(
                                    x: .value("X", value.valorTotalConta),
                                    y: .value("Y", value.faixasAGUA.count)
                                )
                            }
                         */
                        ForEach(Array(viewModel.cons.enumerated()), id: \.offset) { index, value in
                                LineMark(
                                    x: .value("Registro", index),
                                    y: .value("Valor (R$)", value.valorTotalConta)
                                )
                            }
                    }
                    .frame(height: 250)
                    .padding(.horizontal)
                      
                    Button(action: {
                        gerarPDF()
                    }) {
                        Text("Exportar gráfico")
                            .font(.system(size: fontSize, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                    .padding(.horizontal)

                    if let pdfURL = pdfURL {
                        ShareLink("Compartilhar PDF", item: pdfURL)
                            .padding()
                    }

                    Spacer()
                }
            }    .onAppear {
                viewModel.fetch()
            }
        
        }
    }

    func gerarPDF() {
        let pdfView = UIHostingController(rootView:
            VStack(spacing: 15) {
                Text("Relatório de Consumo")
                    .font(.title)
                    .bold()

                Chart(viewModel.contas) { item in
                    BarMark(
                        x: .value("Mês", item.mes),
                        y: .value("Conta (R$)", item.valor)
                    )
                    .foregroundStyle(.black)
                    .cornerRadius(5)
                }
                .frame(height: 250)
                .padding()
            }
            .frame(width: 612, height: 792)
            .padding()
            .background(Color.white)
        )

        let size = CGSize(width: 612, height: 792)
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: size))

        let data = renderer.pdfData { context in
            context.beginPage()
            pdfView.view.frame = CGRect(origin: .zero, size: size)
            pdfView.view.layoutIfNeeded()
            pdfView.view.drawHierarchy(in: CGRect(origin: .zero, size: size), afterScreenUpdates: true)
        }

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let outputURL = documentsURL.appendingPathComponent("relatorio_consumo.pdf")

        do {
            try data.write(to: outputURL)
            self.pdfURL = outputURL
            print("PDF gerado em: \(outputURL)")
        } catch {
            print("Erro ao salvar PDF: \(error)")
        }
    }
}

#Preview {
    let mockVM = ViewModel()
    mockVM.contas = [
        ContaMensal(mes: "Jan", valor: 100),
        ContaMensal(mes: "Fev", valor: 200),
        ContaMensal(mes: "Mar", valor: 150)
    ]
    return HistoricoView(viewModel: mockVM, fontSize: .constant(30))
}


