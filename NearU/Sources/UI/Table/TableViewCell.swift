//
//  TableViewCell.swift
//  testddd
//
//  Created by macbook on 21.04.2021.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    let topLabel = makeLabel()
    let bottom  =  makeLabel()
    let stack  = makeStack()
    
    static var reuseIdentifire : String {
        String(describing: self)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier : String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        stack.addArrangedSubview(topLabel)
        stack.addArrangedSubview(bottom)
        addSubview(stack)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        topLabel.text = ""
        bottom.text = "" 
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    
}
//MARK: -FabricaView
private extension TableViewCell {
    private static func  makeLabel() -> UILabel {
        let p = UILabel()
        p.adjustsFontSizeToFitWidth = true
        p.textAlignment = .natural
        return p
    }
    
    private static func makeStack() -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }
    
}

//MARK: -Layout
private extension TableViewCell {
    private func layout() {
        stack.frame = bounds
    }
}


//MARK: -UpdateView
extension TableViewCell {
    func updateCell(place:Place) {
        topLabel.text = place.name
        bottom.text = place.category + "," + place.adress
    }
}
