//
//  RepoListView.swift
//  GithubExploreSwiftUI
//
//  Created by Raj Shekhar on 09/06/24.
//

import SwiftUI
import Combine

struct RepoListView: View {
    @ObservedObject var viewModel = RepoListViewModel()
    @State var presentPopup: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack{
                List(viewModel.githubRepoList, id: \.id) { repo in
                    Button {
                        self.viewModel.repo = repo
                    } label: {
                        HStack {
                            if let avatar = repo.owner?.avatarUrl, let avatarURL = URL(string: avatar) {
                                AsyncImage(url: avatarURL) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(maxWidth: 80, maxHeight: 80)
                            } else {
                                Image(systemName: "")
                            }
                            VStack(alignment: .leading) {
                                Text("\(repo.name ?? "")")
                                    .fontWeight(.heavy)
                                Text("\(repo.descriptionField ?? "")")
                                    .multilineTextAlignment(.leading)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationDestination(isPresented: $viewModel.redirectToDetails, destination: {
                RepoDetailsView(repo: $viewModel.repo)
            })
            .navigationTitle("GitHub Repos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        presentPopup.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .fullScreenCover(isPresented: $presentPopup, content: {
                        NewRepoView(viewModel: viewModel)
                            .background(BackgroundClearView())
                            .ignoresSafeArea()
                    })

                    VStack(alignment: .leading) {
                        Menu {
                            ForEach(viewModel.sortingItem, id: \.self) {
                                option in
                                Button {
                                    viewModel.selectedSort = option
                                } label: {
                                    HStack {
                                        Text("\(option.rawValue)")
                                        if viewModel.selectedSort == option {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack{
                                Image("sort")
                                    .renderingMode(.template)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .overlay(LoaderView().zIndex(1))
            .environmentObject(Loader.shared)
        }
        .onAppear {
            presentPopup.toggle()
        }
    }
}

struct RepoListView_Previews: PreviewProvider {
    static var previews: some View {
        RepoListView()
    }
}
