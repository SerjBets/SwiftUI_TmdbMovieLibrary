//  MostViewedVC.swift
//  NewsApp
//  Created by Serhii Bets on 13.04.2022.
//  Copyright by Serhii Bets. All rights reserved.

import UIKit

class MostViewedVC: UIViewController,UITableViewDelegate, UITableViewDataSource {

    private enum Constants {
        enum Identifiers {
            static let cell = "mostViewedCell"
            static let segue = "viewedSegue"
        }
    }
    
    @IBOutlet weak var mostViewedTableView: UITableView!
    
    var viewedNewsList = [[News]]() {
        didSet {
            mostViewedTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NewsService.shared.fetchNews(for: .mostViewed) { results in
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
        groups.forEach { viewedNewsList.append($0.value.sorted(by: { $0 < $1 })) }
    }
}

// === MARK: - TableView Delegate / DataSource extension ===
extension MostViewedVC {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = viewedNewsList[indexPath.section][indexPath.row]
        performSegue(withIdentifier: Constants.Identifiers.segue, sender: news)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewedNewsList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mostViewedTableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.cell,
                                                            for: indexPath)
        let news = viewedNewsList[indexPath.section][indexPath.row]
        cell.textLabel?.text = news.title
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewedNewsList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewedNewsList[section].compactMap { $0.section }.first ?? "Unknown"
    }
    
}
