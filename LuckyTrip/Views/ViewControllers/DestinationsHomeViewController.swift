//
//  DestinationsHomeViewController.swift
//  LuckyTrip
//
//  Created by Rana Alhaj on 17/08/2022.
//  This Class is to display the list of all destinations with search, save options

import UIKit

class DestinationsHomeViewController: BaseViewController {

    //MARK:  DECLERATIONS
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var destinationsCollectionView: UICollectionView!
    private var refreshControl: UIRefreshControl?
    private var selectButton : UIBarButtonItem!
    private var saveButton : UIBarButtonItem!
    private var cancelButton : UIBarButtonItem!
    
    var mode = ListModeType.normal
    private lazy var dataSource = DestinationsDataSource(self,destinationsCollectionView)
    private lazy var viewModel : DestinationViewModel = {
        let viewModel = DestinationViewModel(dataSource: dataSource)
        
        return viewModel
    }()
    


    //MARK:  FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setup()
        initTabBarItems()
        self.dataSource.viewModel = self.viewModel
        self.dataSource.loadData(searchWord: "", searchType: SearchType.city_or_country.rawValue)
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (InternetConnection() == false){
            self.refreshControl?.endRefreshing()
            self.ShowLoading(status: Constants.strings.Hide, View: self.view)
            Utl.ShowNotfication(Status: ResultType.failed.rawValue, Body: "Internet Connection not Available!".localized())
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK:  FOR UI
    private func configure(){
        self.title = "Home".localized()
        self.destinationsCollectionView.backgroundColor = .white
        noDataLbl.isHidden = true
        addRefreshControl()
    }
    
    private func initTabBarItems(){
        selectButton = UIBarButtonItem(title: "Select".localized(), style: .done, target: self, action: #selector(selectButtonAction))
        saveButton = UIBarButtonItem(title: "Save".localized(), style: .done, target: self, action: #selector(saveButtonAction))
        cancelButton = UIBarButtonItem(title: "Cancel".localized(), style: .done, target: self, action: #selector(cancelButtonAction))
        
        self.navigationItem.leftBarButtonItem = self.selectButton
    }
    
    
    private func addRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = .gray
        self.refreshControl?.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        self.destinationsCollectionView.refreshControl = self.refreshControl
    }
    
    /*
     self.refreshControl?.endRefreshing()
     self.ShowLoading(status: Constants.strings.Hide, View: self.view)
     Utl.ShowNotfication(Status: ResultType.failed.rawValue, Body: "Internet Connection not Available!".localized())
     */
    func InternetConnection() -> Bool{
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            return true
        }else{
            print("Internet Connection not Available!")
           
            return false
        }
    }
    
    //MARK:  ACTIONS
    @objc func selectButtonAction(){
        self.mode = ListModeType.select
        self.destinationsCollectionView.reloadData()
        self.navigationItem.rightBarButtonItem = self.cancelButton
        self.navigationItem.leftBarButtonItem = self.saveButton
    }
    
    
    @objc func cancelButtonAction(){
        
        if (self.mode == ListModeType.select){
            self.navigationItem.leftBarButtonItem = self.selectButton
            self.navigationItem.rightBarButtonItem = nil
        }
        
        self.mode = ListModeType.normal
        self.dataSource.deselect()
        self.destinationsCollectionView.reloadData()
    }
    
    
    @objc func saveButtonAction(){
        //user can't save less than 3 items
        //saved item will not be saved again
        let count = self.viewModel.dataSource?.data.value.first?.destinations?.filter({$0.ischecked == true}).count
        
       // if ((count == self.viewModel.dataSource?.data.value.first?.destinations?.count)
           // || (count ?? 0 >= Constants.numbers.MIN_ITEMS_TO_SAVE)){
        
        if ((count ?? 0 >= Constants.numbers.MIN_ITEMS_TO_SAVE)){
            
            self.viewModel.dataSource?.data.value.first?.destinations?.filter({(dest: DestinationModel) in dest.ischecked == true}).forEach {
                
                let item = $0
                //check if item saved before or not
                CoreDataModel.shared.destinationExist(item: $0, complation: { result in
                    if (result == false){
                        CoreDataModel.shared.saveDestinations(id: item.id , cityName: item.city  , countryName: item.country_name , thumbnailImage: item.thumbnail?.image_url, thumbnailType: item.thumbnail?.image_type, descriptionText: item.description?.body, isVideo: (item.destination_video == nil) ? 0 : 1)
                        
                    }
                })
            }
            
            cancelButtonAction()
            Utl.ShowNotfication(Status: ResultType.success.rawValue , Body: "your destinations have been saved".localized())
        }else{
            Utl.ShowNotfication(Status: ResultType.failed.rawValue, Body: "Please select at least three destinations".localized())
        }
        
    }
    
    
    @objc private func refreshList(){
        if (InternetConnection() == true){
            self.dataSource.loadData(searchWord: self.searchBar.text, searchType: SearchType.city_or_country.rawValue)
        }else{
            self.refreshControl?.endRefreshing()
            self.ShowLoading(status: Constants.strings.Hide, View: self.view)
            Utl.ShowNotfication(Status: ResultType.failed.rawValue, Body: "Internet Connection not Available!".localized())
        }
    }
}

//MARK:  SETUP
private extension DestinationsHomeViewController {
    func setup(){
        self.dataSource.data.addAndNotify(observer: self) { [weak self] in
            guard let self = self else {return}
            self.refreshControl?.endRefreshing()
            guard let first = self.dataSource.data.value.first else {return}
            self.ShowLoading(status: Constants.strings.Hide, View: self.view)
            if (first.destinations?.count == 0) {
                self.noDataLbl.isHidden = false
                self.noDataLbl.text = "No data found".localized()
            }else{
                self.noDataLbl.isHidden = true
            }
            //Observer here will refresh the UI and reload the fetched data
            self.destinationsCollectionView.reloadData()
        }
    }
}

//MARK:  SEARCHBAR DELEGATE
extension DestinationsHomeViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        self.dataSource.loadData(searchWord: self.searchBar.text, searchType: SearchType.city_or_country.rawValue)
    }
}
