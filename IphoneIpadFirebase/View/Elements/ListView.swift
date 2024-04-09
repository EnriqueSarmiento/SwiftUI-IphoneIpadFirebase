//
//  ListView.swift
//  IphoneIpadFirebase
//
//  Created by Enrique Sarmiento on 1/4/24.
//

import SwiftUI

struct ListView: View {
    let plataforma: String
    var device = UIDevice.current.userInterfaceIdiom
    @Environment(\.horizontalSizeClass) var width
    
    func getColumns() -> Int {
        return (device == .pad) ? 3 : ((device == .phone && width == .regular) ? 3 : 1)
    }
    
    @StateObject var datos = FirebaseViewModel()
   // @State private var showEditar = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: getColumns()),spacing: 20) {
                ForEach(datos.datos){item in
                    CardView(titulo: item.titulo, portada: item.portada, index: item, plataforma: plataforma)
                        .onTapGesture {
                            print("DEBUG: EL ITEM", item)
                            //showEditar.toggle()
                            datos.sendData(item: item)
                        }.sheet(isPresented: $datos.showEditar, content: {
                            EditarView(plataforma: plataforma, datos: datos.itemUpdate)
                        })
                        .padding(.all)
                }
            }
        }.onAppear{
            Task{
                datos.getData(plataforma: plataforma)
            }
        }
    }
}
