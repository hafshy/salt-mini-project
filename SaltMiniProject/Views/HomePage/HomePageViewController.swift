//
//  HomePageViewController.swift
//  SaltMiniProject
//
//  Created by Hafshy Yazid Albisthami on 20/10/23.
//

import Foundation
import UIKit
import Alamofire

class HomePageViewController: UIViewController {
    private var userInfoData: [UserInfoData] = []                       // MARK: Loaded User Data
    private let loadingView = UIActivityIndicatorView(style: .large)    // MARK: Loading View (Object)
    
//  MARK: Table View (Object)
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.allowsSelection = false
        tableView.register(UserInfoCell.self, forCellReuseIdentifier: UserInfoCell.identifier)
        return tableView
    }()
    
//  MARK: viewDidLoad (Entry)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Homepage"
        loadDataAndConfigureTableView()
    }
    
//  MARK: Fetch data from API and set it up for Table View if success, show dialog when failed
    private func loadDataAndConfigureTableView() {
        configureLoadingIndicator()
        
        let request = AF.request("https://reqres.in/api/users?page=2")
        request.responseDecodable(of: HomepageDataModel.self) { response in
            self.removeLoadingIndicator()
            if let successResponse = response.value {
                self.userInfoData = successResponse.data
                self.configureTableView()
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.rowHeight = 80
            } else {
                print("FAILED BRO")
            }
        }
    }
    
//  MARK: Setup Table View
    private func configureTableView() {
        self.view.backgroundColor = .systemBlue
        self.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }

//  MARK: Show Loading Indicator (Used when fetching API)
    private func configureLoadingIndicator() {
        self.view.addSubview(loadingView)
        loadingView.startAnimating()
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
//  MARK: Un-show Loading Indicator (After API fetched)
    private func removeLoadingIndicator() {
        loadingView.stopAnimating()
        loadingView.removeFromSuperview()
    }
}

//  MARK: Table View Cells
extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoCell.identifier, for: indexPath) as? UserInfoCell else {
            fatalError("Table view is unable to dequeue a UserInfoCell")
        }
        
        cell.configure(userInfo: userInfoData[indexPath.row])
        
        return cell
    }
}
