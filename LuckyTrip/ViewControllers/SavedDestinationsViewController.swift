//
//  DestinationsViewController.swift
//  LuckyTrip
//
//  Created by Rana Alhaj on 14/08/2022.
//

import UIKit

class SavedDestinationsViewController: UIViewController {
    
    
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var destinationsCollectionView: UICollectionView!
    

    
    var destinations:[SavedDestinations]  = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
      
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getDestinations()
    }
    
    private func configure(){
        self.title = "For me".localized
    
        self.destinationsCollectionView.dataSource = self
        self.destinationsCollectionView.delegate = self
        self.destinationsCollectionView.registerCell(id: DestinationCell.self)
        self.destinationsCollectionView.backgroundColor = .white
        noDataLbl.isHidden = true
    }
    
    private func localizeUIElements(){
        noDataLbl.text = "no_data".localized
    }
  
    
    // MARK: - Get Related Programs
    private func getDestinations(){
        CoreDataModel.shared.getSavedDestinations { result in
            guard let result = result else {
                return
            }

            self.destinations = result//.reversed()
            if self.destinations.count == 0 {
                noDataLbl.isHidden = false
                noDataLbl.text = "Your list is empty".localized
                noDataLbl.textColor = .darkGray
                
            }else{
                noDataLbl.isHidden = true
                self.destinationsCollectionView.reloadData()
            }
        }
        
    }
}

extension SavedDestinationsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return destinations.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: DestinationCell = collectionView.dequeueCVCell(indexPath: indexPath)
        let destination  = destinations[indexPath.row] as! SavedDestinations
        print(destination)
        cell.checkboxBtn.isHidden = true
        cell.cityName.text = destination.city!
        cell.countryName.text = destination.country_name!
        cell.thumbnailImage.setImageKF(imageLink: destination.thumbnailImage! )
        if destination.thumbnailType!  == "thumbnail"{
            cell.playIcon.isHidden = true
        }else{
            cell.playIcon.isHidden = false
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       /* let currentDestination  = destinations[indexPath.item]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let  destinationDetailsViewController = storyboard.instantiateViewController(withIdentifier: "DestinationDetailsViewController") as? DestinationDetailsViewController
        
        destinationDetailsViewController?.destination = currentDestination
        self.navigationController?.pushViewController(destinationDetailsViewController!, animated: true)*/
        
    }
}

extension SavedDestinationsViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width - 20
        let hieght = width * (2.5/4)
        return CGSize(width:  width, height: hieght )
    }
    
    private func getWidth(txt:String) -> CGSize  {
        return (txt as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .bold)])
    }
}


