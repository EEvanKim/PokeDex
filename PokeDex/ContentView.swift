//
//  ContentView.swift
//  PokeDex
//
//  Created by 12345678910 (student LM) on 0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0.
//  (im going insane)

import SwiftUI

struct ContentView: View {
    @State private var fetchPokemon = FetchDataPokemons()
    @State private var pokeSprites: [String: String] = [:]
    @State private var pokedex: [String: String] = [:]
    @State private var types: [String: [PokeTypes]] = [:]
    @State var url2: String
    @State var pokedexEntry: String
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    Text("--------------------")
                        .padding(.bottom)
                        .font(Constants.pixelBoldFont)
                    Text("! POKEDEX !")
                        .font(Constants.pixelBoldFont)
                        .foregroundColor(Color.black)
                    Text("--------------------")
                        .padding(.top)
                        .font(Constants.pixelBoldFont)
                    ForEach(fetchPokemon.kanto.results) { poke in
                        VStack {
                            NavigationLink {if let spriteURL = pokeSprites[poke.name] {
                                Text(poke.name)
                                    .font(Constants.pixelBoldFont)
                                    .foregroundColor(Color.black)
                                AsyncImage(url: URL(string: spriteURL)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    case .failure:
                                        Image(systemName: "questionmark")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    }
                                }
                            } else {
                                ProgressView()
                                    .frame(height: 200)
                            }
                                Text("--------------------")
                                    .padding()
                                    .font(Constants.pixelBoldFont)
                                HStack{
                                    ForEach(types[poke.name] ?? []) { type in
                                        Text(type.type.name)
                                            .font(Constants.pixelBoldFont)
                                            .foregroundColor(Color.black)
                                    }.padding()
                                }
                                Text(pokedex[poke.name] ?? pokedexEntry)
                                    .font(Constants.pixelBoldFont)
                                    .foregroundColor(Color.black)
                            } label: {
                                if let spriteURL = pokeSprites[poke.name] {
                                    AsyncImage(url: URL(string: spriteURL)) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        case .failure:
                                            Image(systemName: "questionmark")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        }
                                    }
                                } else {
                                    ProgressView()
                                        .frame(height: 200)
                                }
                            }
                            Text("--------------------")
                                .padding()
                                .font(Constants.pixelBoldFont)
                        }
                        .task {
                            let type = await fetchPokemon.getTypes(pokeURL: poke.url)
                            types[poke.name] = type
                            
                            
                            if let spriteURL = await fetchPokemon.getSpriteData(pokeURL: poke.url) {
                                pokeSprites[poke.name] = spriteURL
                            }
                            
                            let pokeid = await fetchPokemon.getPokeDetails(detailsURL: poke.url)
                            if let pokeid = pokeid {
                                let speciesURL = "https://pokeapi.co/api/v2/pokemon-species/\(pokeid)/"
                                if let pokedexEntry = await fetchPokemon.getPokedexEntry(speciesURL: speciesURL) {
                                    pokedex[poke.name] = pokedexEntry
                                } else {
                                    pokedex[poke.name] = "No Pokédex entry available."
                                }
                            }
                        }
                    }
                }
                .task {
                    await fetchPokemon.getData()
                }
                Rectangle()
                    .foregroundColor(.clear)
                    .border(Color.backgroundRed, width: 30)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }

}



#Preview {
    ContentView(url2: "", pokedexEntry: "")
}
