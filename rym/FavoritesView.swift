//
//  FavoritesView.swift
//  rym
//
//  Created by Kabeli Amicar on 30-04-22.
//

import SwiftUI

struct FavoritesView: View {
    let favoriteIds: [Int];
    @State private var characters: [Character] = [];
    
    var body: some View {
        VStack {
                ScrollView {
                    VStack {
                        ForEach(characters, id: \.id) { character in
                            HStack {
                                NavigationLink(destination: CharacterView(character:  character, isFavorite: favoriteIds.contains(character.id))) {
                                    VStack (alignment: .leading){
                                        CardView(character: character)
                                    }
                                    .frame(
                                      minWidth: 0,
                                      maxWidth: .infinity,
                                      alignment: .leading
                                    )
                                }
                            }
                            Divider()
                        }
                        .navigationBarTitle(Text("Mis Favoritos"), displayMode: .inline)
                    }
                }
            
        }.onAppear(perform: fetchData)
    }
    
    func convertToString(arrayOfIds: [Int]) -> String{
        let arrayString = arrayOfIds.map{String($0)}
        let arrayToReturn = arrayString.joined(separator: ",")
        return "["+arrayToReturn+"]"
    }
    
    private func fetchData() {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character/"+convertToString(arrayOfIds: favoriteIds)) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            if let decodedData = try? JSONDecoder().decode([Character].self, from: data) {
                DispatchQueue.main.async {
                    self.characters = decodedData
                }
            }
        }.resume()
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(favoriteIds: [1,2])
    }
}
