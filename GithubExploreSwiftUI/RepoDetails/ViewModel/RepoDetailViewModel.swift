//
//  RepoDetailViewModel.swift
//  GithubRepoAppSwift
//
//  Created by Raj Shekhar on 02/06/24.
//

import UIKit
import Combine

enum ListType {
    case contributorsList
    case commentsList
    case issuesList
}

class RepoDetailViewModel: ObservableObject {
    
    private let repoDetailService: RepositoryDetailServiceProtocol
    
    @Published var popularContributors: [Contributors] = []
    @Published var popularComments: [Comments] = []
    @Published var popularIssues: [Issues] = []
    
    init(repoDetailService: RepositoryDetailServiceProtocol = RepositoryDetailService()) {
        self.repoDetailService = repoDetailService
    }

    // MARK:- functions for the viewModel
    func getPopularContributors(loginName: String, name: String) {
        repoDetailService.fetchPopularContributors(loginName: loginName, name: name) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let contributors):
                    let sliced = contributors.prefix(3)
                    self.popularContributors = Array(sliced)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getPopularComments(loginName: String, name: String) {
        repoDetailService.fetchPopularComments(loginName: loginName, name: name) { [unowned self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let comments):
                    let sliced = comments.prefix(3)
                    self.popularComments = Array(sliced)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getPopularIssues(loginName: String, name: String) {
        repoDetailService.fetchPopularIssues(loginName: loginName, name: name) { [unowned self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let issues):
                    let sliced = issues.prefix(3)
                    self.popularIssues = Array(sliced)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
