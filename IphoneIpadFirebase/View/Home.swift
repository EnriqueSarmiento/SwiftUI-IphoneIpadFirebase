//
//  Home.swift
//  IphoneIpadFirebase
//
//  Created by Enrique Sarmiento on 30/3/24.
//

import SwiftUI
import Firebase

struct Home: View {
    @State private var index = "Playstation"
    @State private var menu = false
    @State private var widthMenu = UIScreen.main.bounds.width
    
    @EnvironmentObject var loginShow : FirebaseViewModel
    
    
    var body: some View {
        ZStack{
            VStack{
                NavBar(index: $index, menu: $menu)
                ZStack{
                    if index == "Playstation" {
                        ListView(plataforma:index)
                    }else if index == "Xbox" {
                        ListView(plataforma: index)
                    }else if index == "Nintendo" {
                        ListView(plataforma: index)
                    }else{
                        AddView()
                    }
                }
            }
            // aqui terminar navbar para ipad
            if menu {
                HStack{
                    Spacer()
                    VStack{
                        HStack{
                            Spacer()
                            Button {
                                withAnimation {
                                    menu.toggle()
                                }
                            } label: {
                               Image(systemName: "xmark")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                                
                            }

                        }.padding()
                            .padding(.top, 50)
                        VStack(alignment: .trailing){
                            ButtonView(index: $index, menu: $menu, title: "Playstation")
                            ButtonView(index: $index, menu: $menu, title: "Xbox")
                            ButtonView(index: $index, menu: $menu, title: "Nintendo")
                            ButtonView(index: $index, menu: $menu, title: "Agregar")
                            Button(action: {
                                Task {
                                    try? Auth.auth().signOut()
                                    UserDefaults.standard.removeObject(forKey: "sesion")
                                    loginShow.show.toggle()
                                }
                            }){
                                Text("Salir").font(.title)
                                    .frame(width: 200)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 25)
                            }.background(Capsule().stroke(Color.white))
                        }
                        Spacer()
                        
                    }.frame(width: widthMenu - (widthMenu / 3))
                    .background(Color.purple)
                }
            }
        }.background(Color("fondo"))
    }
}
