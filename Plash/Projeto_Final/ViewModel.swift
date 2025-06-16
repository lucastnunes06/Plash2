//
//  ViewModel.swift
//  Projeto_Final
//
//  Created by Turma02-18 on 20/05/25.
//

import Foundation

struct ContaMensal: Identifiable {
    var id = UUID()
    var mes: String
    var valor: Double
}

class ViewModel: ObservableObject {
    @Published var cons: [Tarifas] = []
    @Published var contas: [ContaMensal] = []
    
    func fetch() {
        guard let url = URL(string: "http://192.168.128.125:1880/get") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let parsed = try JSONDecoder().decode([Tarifas].self, from: data)
                DispatchQueue.main.async {
                    self?.cons = parsed
                  //  self?.processarContasMensais() 
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }

    func processarContasMensais() {
        let meses = ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez"]
        
        contas = cons.enumerated().map { index, item in
            ContaMensal(
                mes: index < meses.count ? meses[index] : "Mês \(index + 1)",
                valor: item.valorTotalConta
            )
        }
    }
    
    func post(_ obj: Tarifas){
        
        guard let url = URL(string: "http://192.168.128.125:1880/post") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        let encoder = JSONEncoder()
        
        do {
            let jsonData = try encoder.encode(obj)
            request.httpBody = jsonData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            print("Error encoding to JSON: \(error.localizedDescription)")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error to send resource: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error to send resource: invalid response")
                return
            }
            
            if httpResponse.statusCode == 200 {
                print("Resource POST successfully")
            } else {
                print("Error POST resource: status code \(httpResponse.statusCode)")
            }
        }
        task.resume()
    }
}
