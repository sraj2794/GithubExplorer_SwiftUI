//
//  RepoDetailsView.swift
//  GithubExploreSwiftUI
//
//  Created by Raj Shekhar on 09/06/24.
//

import SwiftUI
import Combine

struct RepoDetailsView: View {

    @StateObject var viewModel = RepoDetailViewModel()
    @Binding var repo: Item?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Repo Details")
                .font(Font.system(size: 25))
                .fontWeight(.heavy)
            ScrollView {
                VStack(alignment: .leading) {
                    contributors
                    Text("Top 3 Comments")
                        .fontWeight(.heavy)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.popularComments, id: \.body) { comment in
                                VStack(alignment: .leading) {
                                    if let avatar = comment.user?.avatarUrl, let avatarURL = URL(string: avatar) {
                                        AsyncImage(url: avatarURL) { image in
                                            image.resizable()
                                                .frame(width: 130, height: 160)
                                                .aspectRatio(contentMode: .fit)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                        } placeholder: {
                                            ProgressView()
                                        }
                                    } else {
                                        Image(systemName: "")
                                    }
                                    Text(comment.user?.login ?? "")
                                    Text(comment.body ?? "")
                                        .lineLimit(1)
                                }
                                .frame(maxWidth: 200)
                            }
                        }
                    }
                    
                    Text("Top 3 Issues")
                        .fontWeight(.heavy)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.popularIssues, id: \.updatedAt) { issue in
                                VStack(alignment: .leading) {
                                    if let avatar = issue.user?.avatarUrl, let avatarURL = URL(string: avatar) {
                                        AsyncImage(url: avatarURL) { image in
                                            image.resizable()
                                                .frame(width: 130, height: 160)
                                                .aspectRatio(contentMode: .fit)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                        } placeholder: {
                                            ProgressView()
                                        }
                                    } else {
                                        Image(systemName: "")
                                    }
                                    Text(issue.user?.login ?? "")
                                    Text(issue.title ?? "")
                                        .lineLimit(1)
                                }
                                .frame(maxWidth: 130)
                            }
                        }
                    }
                }
            }
            
        }
        .overlay(LoaderView().zIndex(1))
        .environmentObject(Loader.shared)
        .padding([.leading, .trailing])
        .onAppear {
            if let repo = repo {
                viewModel.getPopularContributors(loginName: repo.owner?.login ?? "", name: repo.name ?? "")
                viewModel.getPopularComments(loginName: repo.owner?.login ?? "", name: repo.name ?? "")
                viewModel.getPopularIssues(loginName: repo.owner?.login ?? "", name: repo.name ?? "")
            }
        }
    }
    
    var contributors: some View {
        VStack(alignment: .leading){
            Text("Top 3 Contributers")
                .fontWeight(.heavy)
            ScrollView(.horizontal,showsIndicators: false) {
                HStack {
                    ForEach(viewModel.popularContributors, id: \.id) { contributor in
                        VStack(alignment: .leading) {
                            if let avatar = contributor.avatarUrl, let avatarURL = URL(string: avatar) {
                                AsyncImage(url: avatarURL) { image in
                                    image.resizable()
                                        .frame(width: 130, height: 160)
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                } placeholder: {
                                    ProgressView()
                                }
                            } else {
                                Image(systemName: "")
                            }
                            Text(contributor.login ?? "")
                            Text("\(contributor.contributions ?? 0)")
                        }
                    }
                }
            }
            
        }
    }
}

struct RepoDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        RepoDetailsView(repo: .constant(nil))
    }
}
