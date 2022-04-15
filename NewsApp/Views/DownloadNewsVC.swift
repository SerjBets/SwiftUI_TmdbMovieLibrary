//
//  DownloadVC.swift
//  NewsApp
//
//  Created by Сергей Бец on 13.04.2022.
//

import UIKit

class DownloadNewsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private enum Constants {
        enum Identifiers {
            static let cell = "savedTableViewCell"
            static let segue = "savedSegue"
        }
    }
    
    @IBOutlet weak var savedNewsTableView: UITableView!
    
    var news : News?
    private var savedNewsList = [NewsEntity]() {
        didSet {
            savedNewsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLocalStorageForDownload()
        NotificationCenter.default.addObserver(self, selector: #selector(self.shouldReload), name: NSNotification.Name(rawValue: "Downloaded"), object: nil)
    }
    
    @objc func shouldReload() {
        fetchLocalStorageForDownload()
    }

    private func fetchLocalStorageForDownload() {
        CoreDataManager.shared.fetchingNewsFromCoreData() { [weak self] result in
            switch result {
            case .success(let news):
                self?.savedNewsList = news
                DispatchQueue.main.async {
                    self?.savedNewsTableView.reloadData()
                }
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

}

// === MARK: - TableView Delegate / DataSource extension ===
extension DownloadNewsVC {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = savedNewsList[indexPath.row]
        performSegue(withIdentifier: Constants.Identifiers.segue, sender: news)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedNewsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = savedNewsTableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.cell, for: indexPath)
        cell.textLabel?.text = savedNewsList[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            CoreDataManager.shared.deleteNewsWith(model: savedNewsList[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("Deleted fromt the database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.savedNewsList.remove(at: indexPath.row)
            }
        default:
            break;
        }
    }
    
}
