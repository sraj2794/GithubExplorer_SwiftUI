//
//  NewRepoView.swift
//  GithubExploreSwiftUI
//
//  Created by Raj Shekhar on 10/06/24.
//

import SwiftUI

struct NewRepoView: View {
    @StateObject var viewModel: RepoListViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
            }
            .padding([.top, .leading, .trailing])
            Text("Welcome!")
                .fontWeight(.heavy)
                .font(Font.system(size: 25))
            Text("Enter any programming language")
            
            TextField("Swift, Python... ", text: $viewModel.text)
                .padding()
            Button {
                viewModel.searchRepos()
                dismiss()
            } label: {
                Image(systemName: "checkmark.circle.fill")
            }.padding()
            
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
    }
}

struct NewRepoView_Previews: PreviewProvider {
    static var previews: some View {
        NewRepoView(viewModel: RepoListViewModel())
    }
}


struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
