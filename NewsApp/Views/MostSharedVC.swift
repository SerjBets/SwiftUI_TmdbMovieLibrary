//  MostSharedVC.swift
//  NewsApp
//  Created by Serhii Bets on 13.04.2022.
//  Copyright by Serhii Bets. All rights reserved.

import UIKit

class MostSharedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private enum Constants {
        enum Identifiers {
            static let cell = "mostSharedCell"
            static let segue = "sharedSegue"
        }
    }
    
    @IBOutlet weak var mostSharedTableView: UITableView!
    
    var sharedNewsList = [[News]]() {
        didSet {
            mostSharedTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NewsService.shared.fetchNews(for: .mostShared) { results in
            switch results {
            case .success(let news):
                self.buildData(for: news.results)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.Identifiers.segue,
                let news = sender as? News,
                let detailedVC = segue.destination as? DetailNewsVC else { return }
        detailedVC.news = news
    }
    
    private func buildData(for news: [News]) {
        let groups = Dictionary(grouping: news, by: { $0.section }).sorted { $0.0 < $1.0 }
        groups.forEach { sharedNewsList.append($0.value.sorted(by: { $0 < $1 })) }
    }

}

// === MARK: - TableView Delegate / DataSource extension ===
extension MostSharedVC {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = sharedNewsList[indexPath.section][indexPath.row]
        performSegue(withIdentifier: Constants.Identifiers.segue, sender: news)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharedNewsList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mostSharedTableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.cell,
                                                            for: indexPath)
        let news = sharedNewsList[indexPath.section][indexPath.row]
        cell.textLabel?.text = news.title
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sharedNewsList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sharedNewsList[section].compactMap { $0.section }.first ?? "Unknown"
    }
}
