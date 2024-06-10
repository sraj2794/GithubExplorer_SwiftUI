//
//  RepoListViewModel.swift
//  GithubRepoAppSwift
//
//  Created by Raj Shekhar on 02/06/24.
//

import UIKit
import Combine

class RepoListViewModel: ObservableObject {
    @Published var githubRepoList: [Item] = []
    var sortingItem: [Sorting] = [.forks, .help_wanted, .stars, .updated_at]
    @Published var selectedSort: Sorting? {
        didSet {
            searchRepos()
        }
    }
    @Published var error: Error?
    @Published var text: String = ""
    @Published var repo: Item? {
        didSet {
            redirectToDetails.toggle()
        }
    }
    @Published var redirectToDetails: Bool = false
    
    var offset: Int = 0
    var limit: Int = 0
    
    private let repoService: RepoServiceProtocol
    
    init(repoService: RepoServiceProtocol = RepoService()) {
        self.repoService = repoService
    }
    
    func searchRepos(withText text: String = "Swift") {
        repoService.searchRepositories(query: self.text, sortBy: selectedSort ?? Sorting.stars, offset: offset, limit: limit) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let dataList):
                    if self.offset == 0 {
                        self.githubRepoList.removeAll()
                    }
                    self.githubRepoList.append(contentsOf: dataList.items ?? [])
                    self.error = nil
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.error = error
                }
            }
        }
    }
}
