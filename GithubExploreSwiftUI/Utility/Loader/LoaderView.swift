//
//  LoaderView.swift
//  GithubExploreSwiftUI
//
//  Created by Raj Shekhar on 10/06/24.
//

import SwiftUI

class Loader: ObservableObject {
    @Published var isLoading = false

    static let shared = Loader()

    private init() {}
}

struct LoaderView: View {
    @EnvironmentObject var loader: Loader

    var body: some View {
        ZStack {
            if loader.isLoading {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
            }
        }
    }
}
