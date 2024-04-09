//
//  AddView.swift
//  IphoneIpadFirebase
//
//  Created by Enrique Sarmiento on 30/3/24.
//

import SwiftUI

struct AddView: View {
    @State private var titulo : String =  ""
    @State private var desc : String = ""
    
    var consola = ["Playstation", "Xbox", "Nintendo"]
    
    @State private var plataforma = "Playstation"
    
    @StateObject var guardar = FirebaseViewModel()
    
    // PARA LA IMAGEN
    @State private var imageData: Data = .init(capacity: 0)
    @State private var mostrarMenu = false
    @State private var imagePicker = false
    //para este es necesario tener un navigacion view si no funciona.
    @State private var source: UIImagePickerController.SourceType = .camera
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.yellow.edgesIgnoringSafeArea(.all)
                VStack{
                    NavigationLink("imagenes"){
                        EmptyView()
                    }.toolbar(.hidden).navigationDestination(isPresented: $imagePicker, destination: {
                        ImagePicker(show: $imagePicker, image: $imageData, source: source)
                    })
                    
                    TextField("titulo", text: $titulo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextEditor(text: $desc)
                        .frame(height: 200)
                    
                    
                    Picker(selection:  $plataforma) {
                        ForEach(consola, id: \.self) { item in
                            Text(item).foregroundColor(.black)
                        }
                    } label: {
                        Text("Plataforma")
                    }.pickerStyle(.wheel)
                    
                    Button(action: {
                        mostrarMenu.toggle()
                    }){
                        Text("Cargar imagen")
                            .foregroundColor(.white)
                            .bold()
                            .font(.largeTitle)
                    }.actionSheet(isPresented: $mostrarMenu) {
                        ActionSheet(title: Text("Menu"), message: Text("Selecciona una opcion"), buttons: [
                            .default(Text("Camara"), action: {
                                source = .camera
                                imagePicker.toggle()
                            }),
                            .default(Text("Libreria"), action: {
                                source = .photoLibrary
                                imagePicker.toggle()
                            }),
                            .default(Text("Cancelar"))
                        
                        ])
                      
                    }
                    
                    if imageData.count != 0 {
                        Image(uiImage: UIImage(data: imageData)!).resizable()
                            .frame(width: 250, height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                        Button(action: {
                            Task {
                                guardar.save(titulo:titulo, desc:desc, plataforma: plataforma, portada: imageData) { done in
                                    if done {
                                        titulo = ""
                                        desc = ""
                                        imageData = .init(capacity: 0)
                                    }
                                }
                            }
                        }){
                            Text("Guardar")
                                .foregroundColor(.white)
                                .bold()
                                .font(.largeTitle)
                        }
                        
                    }

                }.padding()
            }.preferredColorScheme(.light)
        }
    }
}
