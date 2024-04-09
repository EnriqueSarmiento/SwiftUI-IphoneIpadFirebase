//
//  FirebaseViewModel.swift
//  IphoneIpadFirebase
//
//  Created by Enrique Sarmiento on 30/3/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage

class FirebaseViewModel: ObservableObject {
    @Published var show : Bool = false
    @Published var datos = [FirebaseModel]()
    @Published var itemUpdate : FirebaseModel!
    @Published var showEditar = false
    
    func sendData(item: FirebaseModel){
        itemUpdate = item
        showEditar.toggle()
    }
    
    // it is not async throws function
    //** completion is to send a response back to the view after the request ends
    func login(withEmail email: String, password: String, completion: @escaping (_ done: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password){ (user, error) in
            if user != nil {
                print("DEBUG: SI HIZO LIGIN")
                completion(true)
            }else{
                if let error = error?.localizedDescription {
                    print("DEBUG: ERROR FIREBASE ===>", error)
                }else {
                    print("DBEUG: ERROR EN LA APP")
                }
            }
        }
    }
    
    func createUser(withEmail email: String, password: String, completion: @escaping (_ done: Bool) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if user != nil {
                print("DEBUG: SI HIZO REGISTER / LIGIN")
                completion(true)
            }else{
                if let error = error?.localizedDescription {
                    print("DEBUG: ERROR FIREBASE REGISTER ===>", error)
                }else {
                    print("DBEUG: ERROR EN LA APP REGISTER")
                }
            }
        }
    }
    
    // base de datos
    
    func save(titulo: String, desc: String, plataforma: String, portada: Data, completion: @escaping (_ done: Bool) -> Void){
        //GENERAMOS EL UID PARA EL INSERT DE INFORMACION
        @DocumentID var uid: String?
        var id: String {
            return uid ?? NSUUID().uuidString
        }
        
        //configuracion para guardar la imagen en el storage
        let storage = Storage.storage().reference()
        let nombrePortada = UUID()
        let directorio = storage.child("imagenes/\(nombrePortada)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        directorio.putData(portada, metadata: metadata){ data, error in
            if error == nil {
                print("DEBUG: guardo la imagen")
                //FUARDAR TEXTO
                let db = Firestore.firestore()
                guard let idUser = Auth.auth().currentUser?.uid else { return }
                guard let email = Auth.auth().currentUser?.email else { return }
                
                let campos : [String:Any] = ["titulo":titulo, "descripcion":desc, "portada":String(describing: directorio), "idUser":idUser, "email":email]
                
                db.collection(plataforma).document(id).setData(campos){error in
                    if let error = error?.localizedDescription {
                        print("DEBUG: ERROR AL GUARDAR EN FIRESTORE", error)
                    }else{
                       print("DEBUG: GUARDO TODO")
                        completion(true)
                    }
                }
                
                //TERMINO DE GUARDAR LE TEXTO
                
            }else{
                if let error = error?.localizedDescription {
                    print("DEBUG: fallo al subir la imagen", error)
                }else{
                    print("DEBUG: fallo algo en la app")
                }
            }
        }
    }
    
    // mostrar datos
    func getData(plataforma: String){
        
        let db = Firestore.firestore()
        
        db.collection(plataforma).addSnapshotListener { (querySnapshot, error ) in
            
            if let error = error?.localizedDescription {
                print("DEBUG: error del query snapshot al mostrar datos", error)
            }else{
                self.datos.removeAll()
                for document in querySnapshot!.documents {
                    let valor = document.data()
                    let id = document.documentID
                    let titulo = valor["titulo"] as? String ?? "sin titulo"
                    let desc = valor["desc"] as? String ?? "sin desc"
                    let portada = valor["portada"] as? String ?? "sin portada"
                    
                    DispatchQueue.main.async{
                        let registros = FirebaseModel(id: id, titulo: titulo, desc: desc, portada: portada)
                        self.datos.append(registros)
                    }
                }
            }
        }
    }
    
    //eliminar
    func delete(index: FirebaseModel, plataforma: String){
        //eliminar de firestore
        let id = index.id
        let db = Firestore.firestore()
        
        db.collection(plataforma).document(id).delete()
    
        //eliminar del storage
        let imagen = index.portada
        let borrarImagen = Storage.storage().reference(forURL: imagen)
        
        borrarImagen.delete(completion: nil)
    }
    
    //editar
    
    func edit(titulo: String, desc: String, plataforma: String, id: String, completion: @escaping (_ done: Bool) -> Void){
        let db = Firestore.firestore()
        let campos : [String:Any] = ["titulo":titulo, "desc":desc]
        
        db.collection(plataforma).document(id).updateData(campos){ error in
            if let error = error?.localizedDescription {
                print("DEBUG: hubo un error al editar", error)
            }else{
                print("DEBUG: si se edito el texto")
                completion(true)
            }
        }
    }
    
    // editar con imagen
    func editWithImage(titulo: String, desc: String, plataforma: String, id: String, index: FirebaseModel, portada: Data, completion: @escaping (_ done: Bool) -> Void){
       // primero eliminar la imagen anterior
       
        let imagen = index.portada
        let borrarImagen = Storage.storage().reference(forURL: imagen)
        
        borrarImagen.delete(completion: nil)
        
        // subir la nueva imagen
        let storage = Storage.storage().reference()
        let nombrePortada = UUID()
        let directorio = storage.child("imagenes/\(nombrePortada)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        directorio.putData(portada, metadata: metadata){ data, error in
            if error == nil {
                print("DEBUG: guardo la imagen NUEVA")
               
                let db = Firestore.firestore()
                let campos : [String:Any] = ["titulo":titulo, "desc":desc, "portada":String(describing: directorio)]
                
                db.collection(plataforma).document(id).updateData(campos){ error in
                    if let error = error?.localizedDescription {
                        print("DEBUG: hubo un error al editar", error)
                    }else{
                        print("DEBUG: si se edito el texto")
                        completion(true)
                    }
                }
            }else{
                if let error = error?.localizedDescription {
                    print("DEBUG: fallo al subir la imagen", error)
                }else{
                    print("DEBUG: fallo algo en la app")
                }
            }
        }
        
    }
}
