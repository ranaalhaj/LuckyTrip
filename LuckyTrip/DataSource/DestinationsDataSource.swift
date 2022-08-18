

import Foundation
import UIKit
import SDWebImage
import SwiftUI


class DestinationsDataSource : GenericDataSource<DestinationListModel> {
    
    private let destinationsCollectionView: UICollectionView!
    weak var viewModel : DestinationViewModel?
    private let viewController : DestinationsHomeViewController
    var navigationController :  UINavigationController?
    
    init(_ vc : DestinationsHomeViewController ,_ destinationsCollectionView: UICollectionView) {
        self.destinationsCollectionView = destinationsCollectionView
        self.viewController = vc
        super.init()
        setup()
        registerCells()
    }
    
    func loadData(searchWord: String?, searchType: String?){
        self.viewController.ShowLoading(status: Constants.strings.Show, View: self.viewController.view)
        viewModel?.fetchData(searchWord: searchWord, searchType: searchType, completion: { (bool) in
            
        })
    }
    
    
    func deselect(){
        self.data.value.first?.destinations?.forEach { $0.ischecked = false }
    }
}


extension DestinationsDataSource: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width - 20
        let hieght = width * (2.5/4)
        return CGSize(width:  width, height: hieght )
    }
    
    private func getWidth(txt:String) -> CGSize  {
        return (txt as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .bold)])
    }
}

extension DestinationsDataSource : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print(data.value)
        if let first = data.value.first, let destinations = first.destinations {
            return destinations.count
        }
        return  0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: DestinationCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifiers.DESTINATIONCELLID , for: indexPath) as! DestinationCell
        
        if let destinationList = data.value.first,let  destinations = destinationList.destinations{
            
            let currentDest = destinations[indexPath.item]
            print (currentDest)
            cell.fillCellValuesWithDefultDest(destination: currentDest, mode: viewController.mode.rawValue)
            cell.delegate = self
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let destinationList = data.value.first,let  destinations = destinationList.destinations else{
            return
        }
        
        let currentDest = destinations[indexPath.item]
        let storyboard = UIStoryboard(name: Constants.StoryBoards.Main , bundle: nil)
        let  destinationDetailsViewController = storyboard.instantiateViewController(withIdentifier: "DestinationDetailsViewController") as? DestinationDetailsViewController
        
        if (destinationDetailsViewController != nil){
            destinationDetailsViewController?.destination = currentDest
            self.viewController.navigationController?.pushViewController(destinationDetailsViewController!, animated: true)
        }
    }
}



extension DestinationsDataSource : SelectedItemsDelegate{
    func playButtonClicked(destination: DestinationModel) {
        //Call the player here
    }
    func deleteButtonClicked(index: Int) {
        
    }
}



private extension DestinationsDataSource {
    func setup() {
        self.destinationsCollectionView.dataSource = self
        self.destinationsCollectionView.delegate = self
    }
    
    func registerCells(){
        self.destinationsCollectionView.register(UINib(nibName: "DestinationCell", bundle: nil), forCellWithReuseIdentifier: Constants.cellIdentifiers.DESTINATIONCELLID)
    }
    
}


