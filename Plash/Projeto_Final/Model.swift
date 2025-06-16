//
//  Model.swift
//  Projeto_Final
//
//  Created by Turma02-18 on 20/05/25.
//

import Foundation

struct Faixas: Codable,Hashable{
    var nome: String
    var limiteFAIXA: Int
    var valorPORmetroCUBICO: Double
}

struct Tarifas: Encodable, Decodable, Hashable{
    var faixasAGUA: [Faixas]
    var tarifaAGUA: Double
    var tarifaESGOTO: Double
    var valorTotalConta: Double
}
