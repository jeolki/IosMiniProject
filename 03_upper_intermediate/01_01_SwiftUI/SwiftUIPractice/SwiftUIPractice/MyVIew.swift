//
//  MyVIew.swift
//  SwiftUIPractice
//
//  Created by Jeonggi Hong on 2021/11/15.
//

import SwiftUI

struct MyVIew: View {
    // swift가 알아서 관리할 수 있도록 사용하지 않는것이 좋다.
    let helloFont: Font
    
    // body는 필수이며 그리고자 하는것.
    var body: some View {
        VStack {
            VStack {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                    .font(.title)
                Text("만나서 반가워요")
            }
            VStack {
                Text("Hello")
            }
        }
    }
    
}

struct MyVIew_Previews: PreviewProvider {
    static var previews: some View {
        MyVIew(helloFont: .title)
    }
}
