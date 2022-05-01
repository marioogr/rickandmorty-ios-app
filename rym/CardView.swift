//
//  CardView.swift
//  rym
//
//  Created by Kabeli Amicar on 28-04-22.
//

import SwiftUI

struct CardView: View {
    let character: Character
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: character.image)) {
                image in image.resizable()
            } placeholder: {
                ProgressView()
            }
                .cornerRadius(360)
                .padding(12)
                .frame(width: 100, height: 100, alignment: .center)
            VStack (alignment: .leading) {
                Text(character.name).font(.title2)
                Text(character.gender).font(.callout).fontWeight(.semibold).foregroundColor(.gray)
                Text(character.status).font(.callout).fontWeight(.semibold).foregroundColor(.gray)
            }
        }
        .frame(
          minWidth: 0,
          maxWidth: .infinity,
          alignment: .leading
        )
        .padding(8)
    }
}


struct CardView_Previews: PreviewProvider {
    static var character = Character.sampleData[0]
    static var previews: some View {
        CardView(character: character)
    }
}

