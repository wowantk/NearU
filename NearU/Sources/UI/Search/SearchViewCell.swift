//
//  SearchViewCell.swift
//  testddd
//
//  Created by macbook on 23.04.2021.
//

import UIKit

class SearchViewCell: UITableViewCell {
    
    let label = makeLabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier : String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(label)
        setLabelConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        accessoryType =   .none
    }
    
}

//MARK: -FabricaUI
private extension SearchViewCell {
    private static func  makeLabel() -> UILabel {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }
    
}

//MARK: -Set All Constraint
private extension SearchViewCell {
    private func setLabelConstraint() {
        label.topAnchor.constraint(equalTo: topAnchor,constant: 5).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -5).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor ,constant: -30).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    }
}

//MARk: UpdateCell
extension SearchViewCell {
    func update(place:Place,selected:Bool){
        self.label.text = place.name + "," + place.category
        if selected{
            accessoryType = .checkmark
        }
        
    }
}



