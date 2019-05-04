//
//  ViewController.swift
//  Whitehouse Petitions
//
//  Created by mac_os on 22/08/1440 AH.
//  Copyright © 1440 mac_os. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filterPetitions = [Petition]()
    var urlString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(Credits))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(Filter))
        performSelector(inBackground: #selector(fetchJSON), with: nil)
        
    }
    
    @objc func fetchJSON(){
        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filterPetitions = petitions
            
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func Credits(){
        let alert  = UIAlertController(title: "Credits to", message: urlString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
        
    }
    
    @objc func Filter() {
        let alert  = UIAlertController(title: "Filter petitions", message: "Enter word to filter petitions", preferredStyle: .alert)
        alert.addTextField()
        
        let filterAction = UIAlertAction(title: "Filter", style: .default) {
            [weak self, weak alert] _ in
            guard let word = alert?.textFields?[0].text else {return}
            self?.filterData(with: word)
        }
        alert.addAction(filterAction)
        present(alert, animated: true, completion: nil)
    }
    
    func filterData(with word: String) {
        let word = word.lowercased()
        filterPetitions.removeAll()
        for petition in petitions {
            if petition.title.contains(word) || petition.body.contains(word) {
                filterPetitions.append(petition)
            }
        }
        tableView.reloadData()
    }
    
    @objc func showError() {
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petition = filterPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
