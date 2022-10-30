//
//  ViewController.swift
//  JSONWebinar
//
//  Created by Александр on 29.10.2022.
//

import UIKit

class ViewController: UIViewController {

    
    let networkDataFetcher = NetworkDataFetcher()
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    var searchResponse: SearchResponse? = nil
    private var timer: Timer?
    
    @IBOutlet var trackNameLabel: UILabel!
    @IBOutlet var imageSong: UIImageView!
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
    }

    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.obscuresBackgroundDuringPresentation = false
        
    
    }
    
    private func setupTableView() {
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResponse?.results.count ?? 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let track = searchResponse?.results[indexPath.row]
//        imageSong.image = UIImage(named: track?.artworkUrl60 ?? "cosmoboy")
//        trackNameLabel.text = track?.trackName
//        print(track?.artworkUrl60)
//        content.text = track?.trackName
        guard let url = URL(string: track?.artworkUrl60 ?? "cosmoboy") else { return cell }
        DispatchQueue.main.async {
            if let data = try? Data(contentsOf: url) {
                content.image = UIImage(data: data)
            }
        }
          print(track?.artworkUrl60 ?? "000")
//        table.reloadData()
        cell.contentConfiguration = content
        return cell
        
    }
}
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { // searchText - то что вводим
        let urlString = "https://itunes.apple.com/search?term=\(searchText)&limit=5"
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.networkDataFetcher.fetchTracks(urlString: urlString) { searchResponse in
                guard let searchResponse = searchResponse else { return }
                self.searchResponse = searchResponse
                self.table.reloadData()
            }
//            self.networkService.request(urlString: urlString) { [weak self] result in
//                switch result {
//                case .success(let searchResponse):
//                    self?.searchResponse = searchResponse
//                    self?.table.reloadData()
//                case .failure(let error):
//                    print("error", error)
//                }
//            }
        })
        
    }
}
