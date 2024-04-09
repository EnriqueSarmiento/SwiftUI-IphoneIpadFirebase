//
//  Login.swift
//  IphoneIpadFirebase
//
//  Created by Enrique Sarmiento on 30/3/24.
//

import SwiftUI

struct Login: View {
    @State  var email: String = ""
    @State var password: String = ""
    
    @StateObject var login = FirebaseViewModel()
    @EnvironmentObject var loginShow : FirebaseViewModel
    
    var device = UIDevice.current.userInterfaceIdiom
    
    var body: some View {
        ZStack{
            Color.purple.edgesIgnoringSafeArea(.all)
            VStack(spacing: 10){
                Text("My games")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .frame(width: device == .pad ? 400 : nil)
                    
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .frame(width: device == .pad ? 400 : nil)
                    .padding(.bottom)
                    
                Button(action: {
                    login.login(withEmail: email, password: password) { done in
                        if done{
                            UserDefaults.standard.set(true, forKey: "sesion")
                            loginShow.show.toggle()
                        }
                    }
                }){
                    Text("Entrar")
                        .font(.title)
                        .frame(width: 200)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                }.background(
                    Capsule()
                        .stroke(Color.white)
                )
                
                Divider()
                
                Button(action: {
                    login.createUser(withEmail: email, password: password) { done in
                        if done{
                            UserDefaults.standard.set(true, forKey: "sesion")
                            loginShow.show.toggle()
                        }
                    }
                }){
                    Text("Registro")
                        .font(.title)
                        .frame(width: 200)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                }.background(
                    Capsule()
                        .stroke(Color.white)
                )
                
                    
            }.padding(.all)
        }
    }
}
