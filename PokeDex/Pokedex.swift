//
//  Pokedex.swift
//  PokeDex
//
//  Created by Evan Kim (student LM) on 1/2/25.
//

import Foundation
struct FetchDataPokemons{
    var kanto: Kanto = Kanto()
    
    mutating func getData() async{
        let URLString = "https://newsapi.org/v2/everything?domains=wsj.com&language=en&apiKey=948d8f533bf6439d94f891fae25ccf45"
        
        guard let url = URL(string: URLString) else {return}
        guard let (data, _) = try? await URLSession.shared.data(from: url) else {return}
        
        guard let k = try? JSONDecoder().decode(Kanto.self, from: data) else {return}
        kanto = k
    }
}

struct Kanto: Codable{
    var results: [Pokemon] = []
}

struct Pokemon: Codable{
    var name: String?
    var url: String?
}

extension Pokemon: Identifiable{
    var id: String{name ?? ""}
}
struct FetchSpriteokemons{
    var response: Response = Response()
    
    mutating func getData() async{
        let URLString = "https://newsapi.org/v2/everything?domains=wsj.com&language=en&apiKey=948d8f533bf6439d94f891fae25ccf45"
        
        guard let url = URL(string: URLString) else {return}
        guard let (data, _) = try? await URLSession.shared.data(from: url) else {return}
        
        guard let r = try? JSONDecoder().decode(Response.self, from: data) else {return}
        response = r
    }
}
