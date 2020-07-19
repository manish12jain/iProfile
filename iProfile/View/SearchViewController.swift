//
//  SearchViewController.swift
//  iProfile
//
//  Created by pc on 7/18/20.
//  Copyright © 2020 Manish Jain. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchVM = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard() {
           DispatchQueue.main.async {
               self.searchBar.resignFirstResponder()
           }
       }
       
    
    override func viewWillAppear(_ animated: Bool) {
        searchVM.readAllData { (result) in
            self.mTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchVM.refinedArray.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.employeeCell, for: indexPath)
        let employee = searchVM.refinedArray[indexPath.row] as! Employee
        cell.textLabel?.text = String(Constants.emplNameText+employee.employee_name) 
        return cell
    }
        
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool
    {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        dismissKeyboard()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchVM.searchEmployee(with: searchText) {
            self.mTableView.reloadData()
            if searchText.isEmpty {
                self.dismissKeyboard()
            }
        }
    }
}
