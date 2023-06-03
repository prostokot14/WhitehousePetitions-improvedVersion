//
//  TableViewController.swift
//  Project7
//
//  Created by Антон Кашников on 02.06.2023.
//

import UIKit

class TableViewController: UITableViewController {
    private var petitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "doc.text"), style: .plain, target: self, action: #selector(showCredits))

        let urlString = navigationController?.tabBarItem.tag == 0 ? "https://www.hackingwithswift.com/samples/petitions-1.json" : "https://www.hackingwithswift.com/samples/petitions-2.json"

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parce(json: data)
                return
            }
        }

        showError()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        petitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]

        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = petition.title
            content.secondaryText = petition.body
            content.textProperties.numberOfLines = 1
            content.secondaryTextProperties.numberOfLines = 1
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = petition.title
            cell.detailTextLabel?.text = petition.body
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    private func parce(json: Data) {
        if let jsonPetitions = try? JSONDecoder().decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }

    private func showError() {
        let alertController = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }

    @objc private func showCredits() {
        let alertController = UIAlertController(title: "Whitehouse", message: "The data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
