//
//  RandomListTableViewController.swift
//  RandomPairs
//
//  Created by LAURA JELENICH on 11/15/20.
//

import UIKit

class RandomListTableViewController: UITableViewController {

    var pairs: [[Person]]?

    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        randomizePairs()
    }
    
    //MARK: - Actions
    @IBAction func addNameButtonTapped(_ sender: Any) {
        presentAddNameAlert(nil)
    }
    
    @IBAction func shuffleButtonTapped(_ sender: UIBarButtonItem) {
        randomizePairs()
    }
    
    //MARK: - Helper Functions
    func randomizePairs() {
        pairs = RandomController.shared.makePairs()
        tableView.reloadData()
    }
    
    func presentAddNameAlert(_ person: Person?) {
        let alert = UIAlertController(title: "Add a name", message: "Add someone new to the list", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Add name here"
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .sentences
            if let person = person {
                textField.text = person.name
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addNameAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else {return}
            RandomController.shared.create(name: text)
            self.randomizePairs()
        }
        alert.addAction(cancelAction)
        alert.addAction(addNameAction)
        self.present(alert, animated: true, completion: nil)
    }

    //MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return pairs?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = .orange
        label.text = "Group: \(section + 1)"
        return label
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pairs?[section].count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let name = pairs?[indexPath.section][indexPath.row]
        cell.textLabel?.text = name?.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let name = pairs?[indexPath.section][indexPath.row]
                else { return }
            pairs?[indexPath.section].remove(at: indexPath.row)
            RandomController.shared.delete(person: name)
            tableView.deleteRows(at: [indexPath], with: .fade)
            randomizePairs()
        }
    }
}
