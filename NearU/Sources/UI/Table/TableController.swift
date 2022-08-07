//
//  TableController.swift
//  testddd
//
//  Created by macbook on 21.04.2021.
//

import UIKit
import CoreData

class TableController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.delegateMainController = self
        PlacesManager.shared.placesRepository.fetch()
        PlacesManager.shared.observerManager.add(subscriber: self)
        
    }
    
    override func loadView() {
        super.loadView()
        view = View()
    }
    
}

//MARK: -LoadView
private extension TableController {
    private typealias View = TableView
    
    private var contentView : View {
        return view as! View
    }
}

//MARK: - ControllerDelegate
extension TableController : TableControllerDelegate {
    func presentCheckinController() {
        let checkin = CheckinViewController()
        NotificationCenter.default.post(name: PlacesManager.changeSegment, object: nil)
        navigationController?.pushViewController(checkin, animated: true)
    }
    
    
}
//MARK: -DelegateDataSource
extension TableController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlacesManager.shared.getArrCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cell: TableViewCell.self, for: indexPath)
        let place = PlacesManager.shared.getPlace(at: indexPath)
        cell.updateCell(place: place)
        return cell
    }
    
}

//MARK: -DelegateTableView
extension TableController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action,view,nil)  in
            let deletePlace = PlacesManager.shared.getPlace(at: indexPath)
            PlacesManager.shared.remove(pId: deletePlace.id)
        }
        
        delete.image = UIImage(named: "delete")
        let copy = UIContextualAction(style: .normal, title: "Copy") { (action,view,nil)  in
            var copyPlace = PlacesManager.shared.getPlace(at: indexPath)
            PlacesManager.shared.copy(p: &copyPlace)
        }
        copy.backgroundColor = .orange
        copy.image = UIImage(named: "copy")
        return UISwipeActionsConfiguration(actions: [delete,copy])
    }
}

//MARK: -ObserverPatern
extension TableController : ObserverSubscriber {
    func receive(index: IndexPath, event: SubscriptionEvent) {
        switch event {
        case .insert  : contentView.tableView.insertRows(at: [index], with: .automatic)
        case .delete  : contentView.tableView.deleteRows(at: [index], with: .automatic)
        case .update  : contentView.tableView.reloadRows(at: [index], with: .automatic)
        }
    }
    
    func startUp() {
        contentView.tableView.beginUpdates()
    }
    
    func endUp() {
        contentView.tableView.endUpdates()
    }
}
