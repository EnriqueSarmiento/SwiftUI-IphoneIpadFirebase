//
//  ContentView.swift
//  IphoneIpadFirebase
//
//  Created by Enrique Sarmiento on 29/3/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var loginShow: FirebaseViewModel
    var body: some View {
        return Group{
            if loginShow.show {
                Home()
                    .edgesIgnoringSafeArea(.all)
                   
            }else {
                Login()
            }
        }.onAppear {
            if !UserDefaults.standard.objectIsForced(forKey: "sesion") {
                loginShow.show = true
            }
        }
    }
}
