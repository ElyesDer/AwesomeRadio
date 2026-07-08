////
////  ThreeDimensionalRotationEffect.swift
////  AwesomePlayer
////
////  Created by Elyes Derouiche on 01/11/2024.
////
//
//import SwiftUI
//
//struct SwiftUIView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//#Preview {
//    ThreeDimensionalRotationEffect()
//}
//
//struct ThreeDimensionalRotationEffect: View {
//
//    @State private var flipped: Bool = false
//
//    var body: some View {
//        VStack {
//            HStack {
//                if !flipped {
//                    Text("What is the meaning of 'Appreciation'")
//                } else {
//                    Text("thank, thanks, appreciation, gratitude, auditor, inspection")
//                        .rotation3DEffect(Angle(degrees: 180), axis: (x: 0.0, y: 1.0, z: 0.0))
//                }
//            }
//            .multilineTextAlignment(.center)
//            .foregroundColor(.white)
//            .padding()
//            .frame(maxWidth: 300, maxHeight: 600)
//            .background(Color.brown)
//            .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
//            .rotation3DEffect(
//                flipped ? Angle(degrees: 180) : .zero,
//                axis: (x: 0.0, y: 1.0, z: 0.0)
//            )
//            .animation(.default, value: flipped)
//            .onTapGesture {
//                flipped.toggle()
//            }
//        }
//    }
//}
