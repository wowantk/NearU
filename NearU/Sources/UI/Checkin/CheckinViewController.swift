//
//  CheckinViewController.swift
// 

import UIKit

class CheckinViewController: UIViewController {
    
    private let checkIn = CheckIn()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllData()
        contentView.delegateChekcinController = self
        checkIn.delegate = self
    }
    
    override func loadView() {
        view = View()
    }
    
}

//MARK: -WorkWithApi
private extension CheckinViewController{
    func getAllData(){
        DispatchQueue.main.async { [weak self] in
            self?.contentView.activityIndicator.startAnimating()
            self?.contentView.activityIndicator.isHidden = false
        }
        checkIn.nearest { [weak self] in
            self?.contentView.update(place: $0)
            self?.contentView.activityIndicator.stopAnimating()
            self?.contentView.activityIndicator.isHidden = true
        }
    }
}

//MARK: LoadView
private extension CheckinViewController {
    
    typealias View = CheckinView
    
    var contentView: View {
        view as! View
    }
}


//MARK: -CheckinControllerDelegate
extension CheckinViewController:CheckinControllerDelegate {
    func presentSearch() {
        let v = SearchViewController()
        navigationController?.pushViewController(v, animated: true)
    }
    
    func addPlace() {
        PlacesManager.shared.addPlace(p: checkIn.savedPlace)
        navigationController?.popToRootViewController(animated: true)
    }
}
//MARk: -presentProblemWithConnection
extension CheckinViewController:CheckinDelegate {
    func presentErrorAlert(err: Error) {
        let alert = UIAlertController(title: "Connection Error", message: err.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
