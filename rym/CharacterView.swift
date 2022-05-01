//
//  CharacterView.swift
//  rym
//
//  Created by Kabeli Amicar on 29-04-22.
//

import SwiftUI

struct CharacterView: View {
    let character: Character
    let isFavorite: Bool;
    var body: some View {
        ScrollView {
            AsyncImage(url: URL(string: character.image)) {
                image in image.resizable()
            } placeholder: {
                ProgressView()
            }
                .cornerRadius(8)
                .frame(width: 400, height: 400, alignment: .center)
            Text(character.name).font(.title)
            isFavorite ?
                Image(systemName: "heart.fill").resizable()
                .frame(width: 30, height: 27)
                .padding(4)
                .foregroundColor(.blue) :
                Image(systemName: "heart").resizable()
                .frame(width: 30, height: 27)
                .padding(4)
                .foregroundColor(.blue)
            Divider()
            VStack (alignment: .leading) {
                HStack {
                    Text("Estado:").font(.body)
                    Text(character.status).font(.body).fontWeight(.bold)
                }
                Spacer()
                HStack {
                    Text("Especie:").font(.body)
                    Text(character.species).font(.body).fontWeight(.bold)
                }
                Spacer()
                HStack {
                    Text("Genero:").font(.body)
                    Text(character.gender).font(.body).fontWeight(.bold)
                }
                Spacer()
                HStack {
                    Text("Locacion:").font(.body)
                    Text(character.location.name).font(.body).fontWeight(.bold)
                }
                Spacer()
                HStack {
                    Text("Origen:").font(.body)
                    Text(character.origin.name).font(.body).fontWeight(.bold)
                }
            }
            .frame(
              minWidth: 0,
              maxWidth: .infinity,
              alignment: .leading
            )
            .padding(12)
        }.navigationBarTitle(Text(""), displayMode: .inline)
    }
}

struct CharacterView_Previews: PreviewProvider {
    static var character = Character.sampleData[0]
    static var previews: some View {
        CharacterView(character: character, isFavorite: false)
    }
}
