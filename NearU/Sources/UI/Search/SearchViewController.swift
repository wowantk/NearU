//
//  SearchViewController.swift
//  testddd
//
//  Created by macbook on 22.04.2021.
//

import UIKit
class SearchViewController: UIViewController{
    private let rightB = SearchViewController.createButton()
    private let backB = createButton()
    private var  allPlaces:[Place] = []
    private var searchTimer: Timer?
    let searchBusiness = SearchBussins()
    private var selectedArr: [UUID] = []{
        didSet{
            if selectedArr.isEmpty {
                rightB.isHidden = true
            }else{
                rightB.isHidden = false
                rightB.setTitle("Add \(selectedArr.count) items", for: .normal)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.tableView.allowsSelection = true
        contentView.tableView.isUserInteractionEnabled = true
        contentView.delegate = self
        contentView.searchField.delegate = self
        addButton()
        searchBusiness.delegate = self 
        search(text: nil)
    }
    
    override func loadView() {
        view = View()
    }
    
}

//MARK: -loadView
private extension SearchViewController {
    typealias View = SearchView
    private var contentView : View {
        return view as! View
    }
}


//MARK: -TableViewDataSource
extension SearchViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cell: SearchViewCell.self, for: indexPath)
        
        cell.update(place: allPlaces[indexPath.row],selected: checkStatus(p: allPlaces[indexPath.row]))
        return cell
    }
}

//MARK: -TableViewDelegate
extension SearchViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
            selectedArr.removeAll(where: {$0 ==  allPlaces[indexPath.row].id})
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            selectedArr.append(allPlaces[indexPath.row].id)
        }
    }
}

//MARK: -SearchFieldDelegate
extension SearchViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: -WorkWithApi
extension SearchViewController : delegateSearchController {
    func search(text: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.contentView.activityIndicator.isHidden = false
            self?.contentView.activityIndicator.startAnimating()
        }
        searchBusiness.search(text: text?.lowercased()) { [weak self] arr in
            self?.allPlaces = arr
            self?.contentView.tableView.reloadData()
            self?.selectedArr.removeAll()
            self?.contentView.activityIndicator.stopAnimating()
            self?.contentView.activityIndicator.isHidden = true
        }
    }
}

//MARK: -PresentProblemWithConnection
extension SearchViewController:SearchControlerDelegate {
    func presentAlertError(err: Error) {
        let alert = UIAlertController(title: "Connection Error", message: err.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

//MARK: -FabricaUI
private extension SearchViewController {
    private static  func  createButton() -> UIButton {
        let b = UIButton(type: .system)
        b.setTitleColor(UIColor.blue, for: .normal)
        b.frame = CGRect(x: 0, y: 0, width: 90, height: 20)
        b.isHidden = true
        return b
    }
}

//MARK: -AddButton
private extension SearchViewController{
    private func addButton(){
        rightB.addTarget(self, action: #selector(addElemnt), for: .touchUpInside)
        backB.addTarget(self, action: #selector(popRoot), for: .touchUpInside)
        backB.setTitle("Back", for: .normal)
        backB.isHidden = false
        navigationItem.rightBarButtonItem  = UIBarButtonItem(customView: rightB)
        navigationItem.leftBarButtonItem  = UIBarButtonItem(customView: backB)
        
    }
    
    @objc func addElemnt(){
        for id in selectedArr {
            PlacesManager.shared.addPlace(p: allPlaces.first(where: {$0.id == id}))
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func popRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: checkCheckmark
private extension SearchViewController {
    func checkStatus(p:Place) -> Bool{
        return  selectedArr.contains(p.id)
    }
}

