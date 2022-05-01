//
//  ContentView.swift
//  rym
//
//  Created by Kabeli Amicar on 28-04-22.
//

import SwiftUI

struct CharacterOrigin: Decodable {
    var name: String
    var url: String
}

struct Character: Decodable {
    var name: String
    var status: String
    var species: String
    var type: String
    var gender: String
    var origin: CharacterOrigin
    var location: CharacterOrigin
    var image: String
    var episode: [String]
    var url: String
    var created: String
    var id: Int
}

extension Character {
    static let sampleData: [Character] = [
        Character(name: "Rick", status: "Dead", species: "Humanoid", type: "Rick's Toxic Side", gender: "Male", origin: CharacterOrigin(name: "Earth", url: "https://rickandmortyapi.com/api/location/20"), location: CharacterOrigin(name: "Earth", url: "https://rickandmortyapi.com/api/location/20"), image: "https://rickandmortyapi.com/api/character/avatar/361.jpeg", episode: [
            "https://rickandmortyapi.com/api/episode/27"
          ], url: "https://rickandmortyapi.com/api/character/361", created: "2018-01-10T18:20:41.703Z", id: 361)
    ]
}

struct Info: Decodable {
    var count: Int
    var pages: Int
    var next: String?
    var prev: String?
}

struct ApiResponse: Decodable {
    var info: Info
    var results: [Character]
}

struct ContentView: View {
    
    @State private var characters: [Character] = [];
    @State private var apiResponse: ApiResponse?;
    @State private var page: Int = 1;
    @State private var favorites: [Int] = [];
    @State private var selectedFavorite: Int = 0;
    
    var body: some View {
        VStack {
            Text("Rick and Morty")
                .font(.title2)
            NavigationView {
                ScrollView {
                    ScrollViewReader { value in
                        VStack {
                            ForEach(characters, id: \.id) { character in
                                HStack {
                                    NavigationLink(destination: CharacterView(character:  character, isFavorite: self.favorites.contains(character.id))) {
                                        VStack (alignment: .leading){
                                            CardView(character: character)
                                        }
                                        .frame(
                                          minWidth: 0,
                                          maxWidth: .infinity,
                                          alignment: .leading
                                        )
                                    }
                                    Button (action: {
                                        addFavorite(favoriteId: character.id)
                                    }){
                                        Image(systemName: self.favorites.contains(character.id) ? "heart.fill" : "heart")
                                            .resizable()
                                            .frame(width: 25, height: 22)
                                            .padding(4)
                                            .foregroundColor(.blue)
                                    }.padding(.trailing, 12)
                                }
                                Divider()
                            }
                            .navigationTitle("Volver")
                            .navigationBarHidden(true)
                        }
                        HStack (alignment: .center){
                            Button(action: prevPage) {
                                Text("Anterior")
                                    .fontWeight(.bold)
                            }
                            .disabled(page == 1 ? true : false)
                            Spacer()
                            HStack {
                                Text("Pagina: ").fontWeight(.bold)
                                Text(String(page))
                                    .fontWeight(.semibold)
                            }
                            Spacer()
                            Button(action: {
                                nextPage()
                                withAnimation {
                                    value.scrollTo(characters[0].id, anchor: .top)
                                }
                            }) {
                                Text("Siguente")
                                    .fontWeight(.bold)
                            }
                        }.padding(8)
                    }
                }
            }
        }
        .frame(
          minWidth: 0,
          maxWidth: .infinity,
          minHeight: 0,
          maxHeight: .infinity
        )
        .onAppear(perform: fetchData)
    }
    
    private func addFavorite(favoriteId: Int) {
        if (!self.favorites.contains(favoriteId)) {
            self.favorites.insert(favoriteId, at: 0)
        } else {
            self.favorites = self.favorites.filter(){$0 != favoriteId}
        }
    }
    
    private func nextPage() {
        if (self.page < apiResponse?.info.pages ?? 9999) {
            self.page += 1;
            fetchData();
        }
    }
    
    private func prevPage() {
        if (self.page + 1 >= 0) {
            self.page -= 1;
            fetchData();
        }
    }
    
    private func fetchData() {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character/?page="+String(page)) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            if let decodedData = try? JSONDecoder().decode(ApiResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.characters = decodedData.results
                    self.apiResponse = decodedData
                }
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
