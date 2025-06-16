//
//  GeminiViewModel.swift
//  Projeto_Final
//
//  Created by Turma02-19 on 15/05/25.
//

import Foundation

let apiKey = "AIzaSyDXa-uwcQePg8nsP4WKIHi5jz4Q9ECKvFE"
let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=\(apiKey)")!

struct Request: Codable {
    let contents: [RequestContent]
}

struct RequestContent: Codable {
    let parts: [Prompt]
}

struct Prompt: Codable {
    let text: String
}

struct GeminiResponse: Codable {
    struct CandidateResponse: Codable {
        let content: ContentResponse
        
        struct ContentResponse: Codable {
            let parts: [Prompt]
        }
    }
    let candidates: [CandidateResponse]
}

class GeminiDicaViewModel: ObservableObject {
    @Published var dica: String = ""
    
    func getDica(_ prompt: String) {
        let requestBody = Request(contents: [RequestContent(parts: [Prompt(text: prompt)])])
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(requestBody)

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let self = self else { return }

            if let data = data,
               let decodedResponse = try? JSONDecoder().decode(GeminiResponse.self, from: data),
               let dicaText = decodedResponse.candidates.first?.content.parts.first?.text {
                DispatchQueue.main.async {
                    self.dica = dicaText
                }
            } else {
                print("Erro ao decodificar resposta: \(error?.localizedDescription ?? "Resposta inválida")")
            }
        }
        
        task.resume()
    }
    
    func solicitarDica(tema: String) {
        self.dica = ""
        self.getDica("Me dê uma dica simples, prática e curta (até 25 palavras) sobre \(tema)")
    }
}
