//
//  MainView.swift
//
//

import UIKit

class MainView: UIView {
    
    let scrol = makeScoll()
    let  mapView:MapView
    let tableView:TableView
    let segment = makeSegment()
    
    init(map:UIView ,table:UIView) {
        self.mapView = map as! MapView
        self.tableView = table as! TableView 
        super.init(frame: .zero)
        backgroundColor = .white
        addAllSubview()
        setAllConstraint()
        createNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: -Uifabrica
private extension MainView {
    private static func  makeScoll() -> UIScrollView{
        let s = UIScrollView()
        s.showsVerticalScrollIndicator = false
        s.showsHorizontalScrollIndicator = false
        s.translatesAutoresizingMaskIntoConstraints = false
        s.isScrollEnabled = false
        return s
    }
    
    private static func makeSegment() -> UISegmentedControl{
        let c = UISegmentedControl(items: ["Map","List"])
        c.selectedSegmentIndex = 0
        c.translatesAutoresizingMaskIntoConstraints = false
        return c 
    }
}

//MARK: -setConstraint
private extension MainView {
    private func setScrollConstraint(){
        scrol.topAnchor.constraint(equalTo: segment.bottomAnchor).isActive = true
        scrol.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrol.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        scrol.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
    }
    
    private func setSegmentConstraint(){
        segment.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor ,constant: 0).isActive = true
        segment.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,constant: 0).isActive = true
        segment.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,constant: 0).isActive = true
        segment.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    
    private func setMapConstraint(){
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: scrol.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: scrol.bottomAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: scrol.leftAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: scrol.heightAnchor, multiplier: 1).isActive = true
        mapView.widthAnchor.constraint(equalTo: scrol.widthAnchor, multiplier: 1).isActive = true
    }
    
    private func setTableConstraint(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo:scrol.topAnchor ).isActive = true
        tableView.leftAnchor.constraint(equalTo:mapView.rightAnchor ).isActive = true
        tableView.rightAnchor.constraint(equalTo:scrol.rightAnchor ).isActive = true
        tableView.bottomAnchor.constraint(equalTo:scrol.bottomAnchor ).isActive = true
        tableView.heightAnchor.constraint(equalTo: scrol.heightAnchor, multiplier: 1).isActive = true
        tableView.widthAnchor.constraint(equalTo: scrol.widthAnchor, multiplier: 1).isActive = true
    }
}

//MARK: -TatgetSegment
private extension MainView{
    private func addTarget(){
        segment.addTarget(self, action: #selector(setScrol), for: .valueChanged)
    }
    
    @objc func setScrol(){
        let offset = scrol.frame.width * CGFloat(segment.selectedSegmentIndex)
        scrol.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
    }
}

//MARK: - createNotificationCenter
private extension MainView{
    private func createNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(setSegmentFirst), name: PlacesManager.changeSegment, object: nil)
    }
    
    @objc private func setSegmentFirst() {
        segment.selectedSegmentIndex = 0
        setScrol()
    }
    
}

//MARK: -setConstrains
private extension MainView {
    private func setAllConstraint() {
        setScrollConstraint()
        setSegmentConstraint()
        setMapConstraint()
        setTableConstraint()
        addTarget()
    }
}

//MARK: -addAllSubview
private extension MainView {
    private func addAllSubview() {
        addSubview(segment)
        addSubview(scrol)
        scrol.addSubview(mapView)
        scrol.addSubview(tableView)
    }
}

