//
//  CheckinView.swift
//

import UIKit

internal class CheckinView: UIView {
    
    private let buttonStack =  makeButtonStack()
    private let labelStack = makeLabelStack()
    private let nameLabel = makeLabel()
    private let categoryLabel = makeLabel()
    private let adressLabel = makeLabel()
    private let cityLabel = makeLabel()
    private let countryLabel = makeLabel()
    private let coordinate = makeLabel()
    private let searchButton = makeButton(name: "Search name", color: .blue)
    private let addButton = makeButton(name: "Confirm and ADD", color: .green)
    
    weak var delegateChekcinController: CheckinControllerDelegate?
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addAllSubView()
        setConstrains()
        addButtonTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: -fabricaUI
private extension CheckinView {
    private static func  makeButton(name:String, color: UIColor) -> UIButton{
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle(name, for: .normal)
        b.backgroundColor = color
        return b
    }
    
    private static func makeButtonStack() -> UIStackView{
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    private static func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.5
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    private static func makeLabelStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
}
//MARK: -makeConstraint
private extension CheckinView {
    private func setButtonConstraint() {
        buttonStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        buttonStack.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        buttonStack .rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        buttonStack.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func setLabelConstraint() {
        labelStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,constant: 5).isActive = true
        labelStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,constant: 20).isActive = true
        labelStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,constant: -20).isActive = true
        labelStack.bottomAnchor.constraint(equalTo: buttonStack.topAnchor,constant: -5).isActive = true
    }
    
    private func setActivityIndicatorConstrains() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    
    private func setConstrains(){
        setButtonConstraint()
        setLabelConstraint()
        setActivityIndicatorConstrains()
    }
}

//MARK: -AddSubview
private extension CheckinView{
    private func addAllSubView(){
        addSubview(buttonStack)
        addSubview(labelStack)
        [nameLabel,categoryLabel,adressLabel,cityLabel,countryLabel,coordinate]
            .forEach { labelStack.addArrangedSubview($0) }
        [searchButton,addButton]
            .forEach({buttonStack.addArrangedSubview($0)})
        addSubview(activityIndicator)
    }
}


//MARK: -AddButtonTarget
private extension CheckinView {
    private func addButtonTarget() {
        addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(pushSearch), for: .touchUpInside)
    }
    
    @objc private func add(){
        delegateChekcinController?.addPlace()
    }
    
    @objc private func pushSearch(){
        delegateChekcinController?.presentSearch()
    }
    
}


//MARK: -UpdateUI
extension CheckinView {
    func update(place: Place){
        nameLabel.text = place.name
        categoryLabel.text = place.category
        adressLabel.text =  place.adress
        cityLabel.text = place.city
        countryLabel.text = place.country
        coordinate.text = place.lat+","+place.long
    }
}

//MARK: -CheckinViewDelegate
protocol CheckinControllerDelegate : AnyObject {
    func addPlace()
    func presentSearch()
}
