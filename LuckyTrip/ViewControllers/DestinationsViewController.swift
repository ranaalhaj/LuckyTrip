//
//  DestinationsViewController.swift
//  LuckyTrip
//
//  Created by Rana Alhaj on 14/08/2022.
//

import UIKit

class DestinationsViewController: UIViewController {
    
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var destinationsCollectionView: UICollectionView!
    
    var destinations:[DestinationModel]  = []
    var destinationsToSave:[DestinationModel]  = []
    private var refreshControl: UIRefreshControl?
    var saveButton : UIBarButtonItem!
    var cancelButton : UIBarButtonItem!
    var saveMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setRefreshControl()
        initTabBarItems()
        getDestinationsWithText("")
        
    }
    
    private func configure(){
        self.title = "Home".localized
        
        self.destinationsCollectionView.dataSource = self
        self.destinationsCollectionView.delegate = self
        self.destinationsCollectionView.registerCell(id: DestinationCell.self)
        self.destinationsCollectionView.backgroundColor = .white
        noDataLbl.isHidden = true
    }
    
    private func initTabBarItems(){
        saveButton = UIBarButtonItem(title: "Save".localized, style: .done, target: self, action: #selector(saveButtonAction))
        cancelButton = UIBarButtonItem(title: "Cancel".localized, style: .done, target: self, action: #selector(cancelButtonAction))
    }
    
    
    private func updateTabBarItems(){
        
        var status: Bool = false
        if self.destinationsToSave.count >= 3{
            status = true
        }
        if (status == true){
            self.navigationItem.leftBarButtonItem = self.saveButton
            self.navigationItem.rightBarButtonItem = self.cancelButton
            saveMode = true
        }else{
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = nil
            saveMode = false
        }
    }
    
    private func localizeUIElements(){
        noDataLbl.text = "no_data".localized
    }
    
    private func setRefreshControl(){
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = .gray
        self.refreshControl?.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        self.destinationsCollectionView.refreshControl = self.refreshControl
    }
    
    
    @objc func saveButtonAction(){
        
        var saved = false
        for dest in destinationsToSave {
            
            CoreDataModel.shared.destinationExist(item: dest, complation: { result in
                if (result == false){
                    CoreDataModel.shared.saveDestinations(id: dest.id ?? 0, cityName: dest.city ?? "" , countryName: dest.country_name ?? "" , thumbnailImage: dest.thumbnail?.image_url, thumbnailType: dest.thumbnail?.image_type, descriptionText: dest.description?.text)
                    
                    saved = true
                }
            })
            
        }

        if (saved == true){
            Utl.ShowNotfication(Status: "Success".localized, Body: "your destinations have been saved".localized)
        }else{
            Utl.ShowNotfication(Status: "Failed".localized, Body: "your destinations already have been saved".localized)
        }
        
        cancelButtonAction()
        
    }
    
    
    @objc func cancelButtonAction(){
        destinationsToSave = []
        updateTabBarItems()
        destinationsCollectionView.reloadData()
    }
    
    func removeDestination(destToRemove: DestinationModel){
        if let index = destinationsToSave.enumerated().first(where: {$0.element.id == destToRemove.id}) {
            destinationsToSave.remove(at: index.offset)
        }
    }
    
    
    //https://devapi.luckytrip.co.uk/api/2.0/test/destinations?search_type=city_or_country&search_value=d
    // MARK: - Get Related Programs
    @objc private func refreshList(){
        getDestinationsWithText (self.searchBar.text ?? "")
    }
    
    private func getDestinationsWithText(_ word: String){
        print(word)
        self.searchBar.endEditing(true)
        Utl.ShowLoading(status: Show, View: self.view)
        destinations = []
        self.destinationsCollectionView.reloadData()
        DestinationsManager().getDestinations(keyword : word , success: didGetDestinations, failed: didFailedCallBack)
        
    }
    
    
    fileprivate func didGetDestinations(_ response:Destinations?){
        DispatchQueue.main.async { [weak self] in
            guard let wself = self else {return}
            Utl.ShowLoading(status: Hide, View: wself.view)
            wself.refreshControl?.endRefreshing()
            guard let response = response else {return}
            
            wself.destinations = response.destinations ?? []
           
            wself.noDataLbl.isHidden =  !wself.destinations.isEmpty
            
            if  wself.destinations.isEmpty{
            }else{
                wself.destinationsCollectionView.backgroundView = nil
            }
            wself.destinationsCollectionView.reloadData()
        }
        
    }
}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension DestinationsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return destinations.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: DestinationCell = collectionView.dequeueCVCell(indexPath: indexPath)
        let destination  = destinations[indexPath.item]
        cell.cityName.text = destination.city
        cell.countryName.text = destination.country_name
        cell.thumbnailImage.setImageKF(imageLink: destination.thumbnail?.image_url)
        
        if destination.thumbnail?.image_type ?? ""  == "thumbnail"{
            cell.playIcon.isHidden = true
        }else{
            cell.playIcon.isHidden = false
        }
        
        if (self.saveMode == false){
            cell.checkboxBtn.tag = 0
        }
        
        cell.checkboxBtn.isSelected =  (cell.checkboxBtn.tag == 0) ? false : true
        
        if let image = UIImage(named: (cell.checkboxBtn.tag == 0) ? "checkbox_unselected" : "checkbox_selected" ) {
            cell.checkboxBtn.setImage(image, for: .normal)
        }
        
        
        if self.saveMode == true{
            cell.checkboxBtn.isSelected = false
        }else{
            
        }
       
        cell.index = indexPath.item
        cell.delegate = self
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let currentDestination  = destinations[indexPath.item]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let  destinationDetailsViewController = storyboard.instantiateViewController(withIdentifier: "DestinationDetailsViewController") as? DestinationDetailsViewController
        
        destinationDetailsViewController?.destination = currentDestination
        self.navigationController?.pushViewController(destinationDetailsViewController!, animated: true)
        
    }
}

extension DestinationsViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width - 20
        let hieght = width * (2.5/4)
        return CGSize(width:  width, height: hieght )
    }
    
    private func getWidth(txt:String) -> CGSize  {
        return (txt as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .bold)])
    }
}



extension DestinationsViewController : UISearchBarDelegate{
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        self.getDestinationsWithText(searchBar.text ?? "")
    }
    
}


extension DestinationsViewController : CheckedDelegate{
    func checkClicked(index: Int, isChecked: Int) {
        let dest = self.destinations[index]
        print(dest)
        
        if (isChecked == 1){
            destinationsToSave.append(dest)
        }else{
            removeDestination(destToRemove: dest)
        }
        self.updateTabBarItems()
    }
}
