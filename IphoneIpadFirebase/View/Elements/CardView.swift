//
//  CardView.swift
//  IphoneIpadFirebase
//
//  Created by Enrique Sarmiento on 30/3/24.
//

import SwiftUI

struct CardView: View {
    var titulo: String
    var portada: String
    
    var index: FirebaseModel
    var plataforma: String
    
    @StateObject var datos = FirebaseViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            ImagenFirebase(imageUrl: portada)
            Text(titulo)
                .font(.title)
                .bold()
                .foregroundColor(.black)
            
            Button(action: {
                datos.delete(index: index, plataforma: plataforma)
            }){
                Text("eliminar")
                    .foregroundColor(.red)
                    .padding(.vertical,10)
                    .padding(.horizontal,25)
                    .background(Capsule().stroke(Color.red))
            }
            
        }.padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
