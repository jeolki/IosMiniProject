//
//  ContentView.swift
//  NetflixStyleCollectionViewSampleApp
//
//  Created by Jeonggi Hong on 2021/11/16.
//

import SwiftUI

struct ContentView: View {
    
    let titles = ["Netflix Sample App"]
    
    var body: some View {
        
        NavigationView {
            List(titles, id: \.self) {
                let netflixVC = HomeViewControllerRepresentable()
                    .navigationBarHidden(true)
                    .edgesIgnoringSafeArea(.all)
                NavigationLink($0, destination: netflixVC)
            }
            .navigationTitle("SwiftUI to UIkit")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
