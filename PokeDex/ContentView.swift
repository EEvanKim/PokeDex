//
//  ContentView.swift
//  PokeDex
//
//  Created by Evan Kim (student LM) on 12/17/24.
//

import SwiftUI

struct ContentView: View {
    @State private var fetchPokemon = FetchDataPokemons()
    @State private var pokeSprites: [String: String] = [:]
    var body: some View {
        ScrollView {
            ForEach(fetchPokemon.kanto.results) { poke in
                VStack {
                    Text(poke.name)
                        .padding()
                    if let spriteURL = pokeSprites[poke.name] {
                        AsyncImage(url: URL(string: spriteURL)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(25)
                                    .frame(height: 200)
                            case .failure:
                                Image(systemName: "questionmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(25)
                                    .frame(height: 50)
                            }
                        }
                    } else {
                        ProgressView()
                            .frame(height: 200)
                    }

                    Text(poke.url)
                        .padding()
                    Text("-------------------------")
                        .padding()
                }
                .task {
                    if let spriteURL = await fetchPokemon.getSpriteData(pokeURL: poke.url) {
                        pokeSprites[poke.name] = spriteURL
                    }
                }
            }
        }
        .task {
            await fetchPokemon.getData()
        }
    }
}


#Preview {
    ContentView()
}
