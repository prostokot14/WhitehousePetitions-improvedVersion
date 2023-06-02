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
        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parce(json: data)
            }
        }
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
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = petition.title
            cell.detailTextLabel?.text = petition.body
        }

        return cell
    }

    private func parce(json: Data) {
        if let jsonPetitions = try? JSONDecoder().decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
}
