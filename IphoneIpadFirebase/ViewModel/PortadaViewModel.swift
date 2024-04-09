//
//  PortadaViewModel.swift
//  IphoneIpadFirebase
//
//  Created by Enrique Sarmiento on 1/4/24.
//

import Foundation
import Firebase
import FirebaseStorage

class PortadaViewModel: ObservableObject {
    @Published var data: Data? = nil
    
    init(imageUrl: String){
        //AGREGUE ESTE IF POR HABIA CACHING DE LA IMAGEN POR ALGUNA RAZON Y NO SUPE ELIMINARLA.
        if imageUrl != "ruta" {
            let storageImage = Storage.storage().reference(forURL: imageUrl)
            storageImage.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error?.localizedDescription {
                    print("DEBUG: error al traer la imagen", error)
                }else{
                    DispatchQueue.main.async {
                        self.data = data
                    }
                }
            }
            
        }
    }
}
