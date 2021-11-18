//
//  SearchViewController.swift
//  ShoppingApp
//
//  Created by syed on 09/10/2021.
//

import UIKit

class SearchViewController: UIViewController {
    
    var data = [["one","two","three","four","five","six","seven","eight"],["1","2","3","4","5","6","7","8"]]
    
    
    private let tableView:UITableView = {
       let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.isUserInteractionEnabled  = true
        tableView.isEditing  = true
    
        tableView.dataSource = self
        tableView.delegate  = self
     
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    
}

extension SearchViewController:UITableViewDelegate,UITableViewDataSource{

    private func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
          switch editingStyle {
          case .delete:
              break
               default:
             return
           }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let section = data[indexPath.section]
        let item = section[indexPath.row]
        content.text = item
        
        cell.contentConfiguration = content
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0 :
            return "String"
        default :
            return "Numbers"
        }
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section != destinationIndexPath.section{
            print("Should not move")
            tableView.reloadData()
        }else {
            let item = data[sourceIndexPath.section][sourceIndexPath.row]
            data[sourceIndexPath.section].remove(at: sourceIndexPath.row )
            data[sourceIndexPath.section].insert(item, at: destinationIndexPath.row)
            print(data)
        }
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
