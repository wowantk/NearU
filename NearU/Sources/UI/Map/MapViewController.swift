//
//  MapViewController.swift
//

import UIKit

class MapViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
    }
    
    override func loadView() {
        view = View()
    }
}


//MARK: -LoadView
private extension MapViewController{
    typealias View = MapView
    
    var contentView: View {
        view as! View
    }
}

//MARK: -Delegate
extension MapViewController:MapViewControllerDelegate {
    func popCheckin() {
        let checkin = CheckinViewController()
        navigationController?.pushViewController(checkin, animated: true)
    }
}





