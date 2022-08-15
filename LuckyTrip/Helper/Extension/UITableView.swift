//
//  UIExtension.swift
//  Avon Sales


import Foundation
import UIKit

extension UICollectionView {
    func dequeueCVCell<T: UICollectionViewCell>(indexPath:IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("Could not locate viewcontroller with with identifier \(String(describing: T.self)) in storyboard.")
        }
        return cell
    }
    
    
    func registerCell(id: String) {
        self.register(UINib(nibName: id, bundle: nil), forCellWithReuseIdentifier: id)
    }
    
    func registerCell(id: UICollectionViewCell.Type) {
        let _id = String(describing: id)
        self.register(UINib(nibName: _id, bundle: nil), forCellWithReuseIdentifier: _id)
    }
    static var idinitifer:String{
        return String(describing: self)
    }
    static var nib:UINib{
        return UINib(nibName: self.idinitifer, bundle: nil)
    }
    
}


extension UITableView {
    func dequeueTVCell<T: UITableViewCell>() -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("Could not locate viewcontroller with identifier \(String(describing: T.self)) in storyboard.")
        }
        return cell
    }
    
    func registerCell(id: String) {
        self.register(UINib(nibName: id, bundle: nil), forCellReuseIdentifier: id)
    }
    
    func registerCell(id: UITableViewCell.Type) {
        let _id = String(describing: id)
        self.register(UINib(nibName: _id, bundle: nil), forCellReuseIdentifier: _id)
    }
    func dequeueHeaderView<T:UITableViewHeaderFooterView>() -> T{
        guard let header = dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("Could not locate viewcontroller with identifier \(String(describing: T.self)) in storyboard.")
        }
        return header
    }
    func registerHeaderView(id:UITableViewHeaderFooterView.Type){
        let id_ = String(describing: id)
        self.register(UINib(nibName: id_, bundle: nil), forHeaderFooterViewReuseIdentifier: id_)
    }
    
    func layoutTableHeaderView() {
        
        guard let headerView = self.tableHeaderView else { return }
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        let headerWidth = headerView.bounds.size.width;
        let temporaryWidthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "[headerView(width)]", options: NSLayoutConstraint.FormatOptions(rawValue: UInt(0)), metrics: ["width": headerWidth], views: ["headerView": headerView])
        
        headerView.addConstraints(temporaryWidthConstraints)
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let headerSize = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let height = headerSize.height
        var frame = headerView.frame
        
        frame.size.height = height
        headerView.frame = frame
        
        self.tableHeaderView = headerView
        
        headerView.removeConstraints(temporaryWidthConstraints)
        headerView.translatesAutoresizingMaskIntoConstraints = true
    }
}
extension UITableViewCell
{
    static var idinitifer:String{
        return String(describing: self)
    }
    static var nib:UINib{
        return UINib(nibName: self.idinitifer, bundle: nil)
    }
    
}

