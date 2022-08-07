//
//  SearchView.swift
//  testddd
//
//  Created by macbook on 22.04.2021.
//

import UIKit

class SearchView: UIView {
    
    let searchField  = makeSearch()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    let tableView = makeTable()
    weak var delegate:delegateSearchController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addAllSub()
        setSearchConstraint()
        setTableConstraint()
        setActivityIndicatorConstraint()
        addFieldTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

//MARK: -FabricaUI
private extension SearchView {
    private static func makeSearch() -> UISearchTextField {
        let s = UISearchTextField()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.returnKeyType = .search
        return s
    }
    
    private static func makeTable() -> UITableView {
        let t = UITableView()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.register(cell: SearchViewCell.self)
        t.keyboardDismissMode = .onDrag
        return t
    }
}

//MARK: -SetConstrains
private extension SearchView {
    private func setSearchConstraint() {
        searchField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,constant: 10).isActive = true
        searchField.leftAnchor.constraint(equalTo: leftAnchor,constant: 10).isActive = true
        searchField.rightAnchor.constraint(equalTo: rightAnchor,constant: -10).isActive = true
        searchField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setTableConstraint() {
        tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor,constant: 10).isActive = true
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func setActivityIndicatorConstraint() {
        activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
    }
}

//MARK: -fieldTarget
private extension SearchView {
    private func addFieldTarget(){
        searchField.addTarget(self, action: #selector(searchText), for: .editingChanged)
    }
    @objc func searchText(){
        delegate?.search(text: searchField.text)
    }
}

//MARK: -addAllSub
private extension SearchView {
    private func addAllSub(){
        addSubview(searchField)
        addSubview(tableView)
        tableView.addSubview(activityIndicator)
    }
}
//MARK: -delegate
protocol delegateSearchController : AnyObject {
    func search(text:String?)
}
