//
//  TableView.swift
//  testddd
//
//  Created by macbook on 21.04.2021.
//

import UIKit

class TableView: UIView {
    
    let tableView = makeTableView()
    let customView = makeFooterView()
    let button = makeButton()
    weak var delegateMainController:TableControllerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addAllSub()
        createCenter()
        createTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
}

//MARK: -layout
private extension TableView {
    private func layout() {
        tableView.frame = bounds
        button.frame = customView.bounds
    }
}



//MARK: -FabricaView
private extension TableView {
    private  static func makeFooterView() -> UIView {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        v.backgroundColor = .white
        return v
    }
    
    private static func makeButton() -> UIButton {
        let b = UIButton()
        b.layer.borderColor = UIColor.black.cgColor
        b.layer.borderWidth = 0.5
        b.setTitleColor(.green, for: .normal)
        b.setTitle("Add current place", for: .normal)
        return b
    }
}
//MARK: -AddAllSub
private extension TableView {
    private func addAllSub() {
        addSubview(tableView)
        customView.addSubview(button)
        tableView.tableFooterView = customView
    }
}

//MARK: -CreateNotificationCentre
private extension TableView {
    func createCenter(){
        
    }
    
    @objc private func reloadTable() {
        tableView.reloadData()
    }
}

//MARK: -CreateTarget
private extension TableView {
    func createTarget(){
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    @objc func buttonAction() {
        delegateMainController?.presentCheckinController()
    }
    
}


//MARK: -ViewFabrica
private extension TableView {
    private static func makeTableView() -> UITableView {
        let view = UITableView()
        view.separatorStyle = .singleLine
        view.register(cell: TableViewCell.self)
        view.allowsSelection = false
        return view
    }
}

//MARK: -DelegateController
protocol TableControllerDelegate : AnyObject {
    func presentCheckinController()
}


