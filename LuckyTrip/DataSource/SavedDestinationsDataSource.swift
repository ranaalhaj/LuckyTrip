

import Foundation
import UIKit
import SDWebImage
import SwiftUI


class SavedDestinationsDataSource : GenericDataSource<[SavedDestinations]> {
    
    private let destinationsCollectionView: UICollectionView!
    weak var viewModel : SavedDestinationViewModel?
    private let viewController : DestinationsForMeViewController
    var navigationController :  UINavigationController?
    
    init(_ vc : DestinationsForMeViewController ,_ destinationsCollectionView: UICollectionView) {
        self.destinationsCollectionView = destinationsCollectionView
        self.viewController = vc
        super.init()
        setup()
        registerCells()
    }
    
    func loadData(){
        self.viewController.ShowLoading(status: Constants.strings.Show, View: self.viewController.view)
        viewModel?.fetchData(completion: { (bool) in
            
        })
    }
    
}


extension SavedDestinationsDataSource: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width - 20
        let hieght = width * (2.5/4)
        return CGSize(width:  width, height: hieght )
    }
    
    private func getWidth(txt:String) -> CGSize  {
        return (txt as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .bold)])
    }
}

extension SavedDestinationsDataSource : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print(data.value)
        if let first = data.value.first{
            return first.count
        }
        return  0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: DestinationCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifiers.DESTINATIONCELLID , for: indexPath) as! DestinationCell
        
        if let destinations = data.value.first{
            
            let currentDest = destinations[indexPath.item]
            print (currentDest)
            cell.fillCellValuesWithSavedDest(destination: currentDest, index: indexPath.item)
            cell.delegate = self
        }
        
        return cell
        
    }

}



extension SavedDestinationsDataSource : SelectedItemsDelegate{
    func playButtonClicked(destination: DestinationModel) {
        //Call the player here
    }
    // as? SavedDestinations
    func deleteButtonClicked(index: Int) {
        if let destinations = self.data.value.first, let item  = destinations[index] as? SavedDestinations {
        self.viewModel?.deleteDest(SavedDest: item)
            self.loadData()
        }
    }
}


private extension SavedDestinationsDataSource {
    func setup() {
        self.destinationsCollectionView.dataSource = self
        self.destinationsCollectionView.delegate = self
    }
    
    func registerCells(){
        self.destinationsCollectionView.register(UINib(nibName: "DestinationCell", bundle: nil), forCellWithReuseIdentifier: Constants.cellIdentifiers.DESTINATIONCELLID)
    }
    
}


