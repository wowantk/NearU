//
//  File.swift
//  test
//
//  Created by macbook on 13.04.2021.
//

import Foundation
import UIKit
public protocol ReusableViewProtocol: AnyObject {
    static var reuseId: String { get }
}

extension ReusableViewProtocol {
    
    public static var reuseId: String {
        let reuseId = NSStringFromClass(self)
        return reuseId
    }
    
}

extension UITableViewCell: ReusableViewProtocol {
}

public protocol DynamicReuse: NSObjectProtocol {
    associatedtype Cell where Cell: ReusableViewProtocol
    func register(cell: Cell.Type)
}


extension UITableView: DynamicReuse {
    
    public typealias Cell = UITableViewCell
    
    public func dequeueReusable<T: Cell>(cell: T.Type, for indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withIdentifier: cell.reuseId, for: indexPath) as! T
        return cell
    }

    public func register(cell: Cell.Type) {
        register(cell, forCellReuseIdentifier: cell.reuseId)
    }
    
}
