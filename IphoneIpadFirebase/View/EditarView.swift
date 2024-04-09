//
//  EditarView.swift
//  IphoneIpadFirebase
//
//  Created by Enrique Sarmiento on 3/4/24.
//

import SwiftUI

struct EditarView: View {
    @State private var titulo : String =  ""
    @State private var desc : String = ""
    
    
    var plataforma: String
    var datos: FirebaseModel
    
    @StateObject var guardar = FirebaseViewModel()
    
    // PARA LA IMAGEN
    @State private var imageData: Data = .init(capacity: 0)
    @State private var mostrarMenu = false
    @State private var imagePicker = false
    //para este es necesario tener un navigacion view si no funciona.
    @State private var source: UIImagePickerController.SourceType = .camera
    @State private var progress : Bool = false
    @Environment(\.presentationMode) var presentationMode
    
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
                        .onAppear{
                            titulo = datos.titulo
                        }
                    
                    
                    TextEditor(text: $desc)
                        .frame(height: 200)
                        .onAppear{
                            desc = datos.desc
                        }
                    
                    
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
                        
                    }
                    
                    Button(action: {
                        Task {
                            if imageData.isEmpty{
                                guardar.edit(titulo: titulo, desc: desc, plataforma: plataforma, id: datos.id) { done in
                                    if done {
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            }else{
                                progress = true
                                guardar.editWithImage(titulo: titulo, desc: desc, plataforma: plataforma, id: datos.id, index: datos, portada: imageData) { done in
                                    if done {
                                        presentationMode.wrappedValue.dismiss()
                                        progress = false
                                    }
                                }
                            }
                            
                        }
                    }){
                        Text("Editar")
                            .foregroundColor(.white)
                            .bold()
                            .font(.largeTitle)
                    }
                    
                    if progress {
                        Text("espere un momento por favor...").foregroundColor(.black)
                        ProgressView()
                    }

                }.padding()
            }.preferredColorScheme(.light)
        }.onAppear{
            print("DEBUG: aqui en edit view", datos)
        }
    }
}
