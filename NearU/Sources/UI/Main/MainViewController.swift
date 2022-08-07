//
//  MainViewController.swift
//

import UIKit

class MainViewController: UIViewController {
    private let mapController = MapViewController()
    private let tableController = TableController()
    private let rightButton = makeBarButton(named: "Search")
    private let leftButton  = makeBarButton(named: "RemoveAll")
    private let locationManager = LocationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "BookMark"
        addAllChild()
        locationManager.checkLocationService()
        addBarItem()
    }
    
    override func loadView() {
        view = View(map: mapController.view, table: tableController.view)
    }
    
}

//MARK: - SetUpView
private extension MainViewController {
    
    typealias View = MainView
    
    var contentView: View {
        view as! View
    }
}

//MARK: -ButtonFabrika
private extension MainViewController {
    private static func makeBarButton(named:String) -> UIButton {
        let b = UIButton(type: .system)
        b.setTitle(named, for: .normal)
        b.setTitleColor(UIColor.blue, for: .normal)
        b.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        return b
    }
}

//MARK: -CustomizeBarItem
private extension MainViewController {
    private func addBarItem(){
        leftButton.addTarget(self, action: #selector(removeAllPlaces), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        rightButton.addTarget(self, action: #selector(presentSearch), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    @objc private func removeAllPlaces() {
        let alert = UIAlertController(title: "Alert", message: "Remove All places?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            PlacesManager.shared.removeAll()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @objc private func presentSearch() {
        let vc = SearchViewController()
        NotificationCenter.default.post(name: PlacesManager.changeSegment, object: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: -addChicldController
private extension MainViewController {
    private func addAllChild(){
        addChild(mapController)
        addChild(tableController)
        mapController.didMove(toParent: self)
        tableController.didMove(toParent: self)
    }
}






