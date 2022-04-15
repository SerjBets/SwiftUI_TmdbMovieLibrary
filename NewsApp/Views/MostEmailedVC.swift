//  MostEmailedVC.swift
//  NewsApp
//  Created by Serhii Bets on 13.04.2022.
//  Copyright by Serhii Bets. All rights reserved.

import UIKit
import Alamofire

class MostEmailedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private enum Constants {
        enum Identifiers {
            static let cell = "mostEmailedCell"
            static let segue = "emailedSegue"
        }
    }
    
    @IBOutlet weak var mostEmailedTableView: UITableView!
    
    var emailedNewsList = [[News]]() {
        didSet {
            mostEmailedTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NewsService.shared.fetchNews(for: .mostEmailed) { results in
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
        groups.forEach { emailedNewsList.append($0.value.sorted(by: { $0 < $1 })) }
    }
}

// === MARK: - TableView Delegate / DataSource extension ===
extension MostEmailedVC {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = emailedNewsList[indexPath.section][indexPath.row]
        performSegue(withIdentifier: Constants.Identifiers.segue, sender: news)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailedNewsList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mostEmailedTableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.cell,
                                                            for: indexPath)
        let news = emailedNewsList[indexPath.section][indexPath.row]
        cell.textLabel?.text = news.title
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return emailedNewsList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return emailedNewsList[section].compactMap { $0.section }.first ?? "Unknown"
    }
}
