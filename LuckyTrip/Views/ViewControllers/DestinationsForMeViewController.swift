//
//  DestinationsForMeViewController.swift
//  LuckyTrip
//
//  Created by Rana Alhaj on 17/08/2022.
//  This Class is to display the list  of saved destinations


import UIKit

class DestinationsForMeViewController: BaseViewController {
    
    //MARK:  DECLERATIONS
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var savedDestCountLbl: UILabel!
    
    @IBOutlet weak var destinationsCollectionView: UICollectionView!
    private var refreshControl: UIRefreshControl?
    
    private lazy var dataSource = SavedDestinationsDataSource(self,destinationsCollectionView)
    private lazy var viewModel : SavedDestinationViewModel = {
        let viewModel = SavedDestinationViewModel(dataSource: dataSource)
        return viewModel
    }()
    


    //MARK:  FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setup()
        self.dataSource.viewModel = self.viewModel
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataSource.loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK:  FOR UI
    private func configure(){
        self.title = "For me".localized()
        self.destinationsCollectionView.backgroundColor = .white
        noDataLbl.isHidden = true
        addRefreshControl()
    }
    
    
    
    private func addRefreshControl(){
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = .gray
        self.refreshControl?.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        self.destinationsCollectionView.refreshControl = self.refreshControl
    }
   
    @objc private func refreshList(){
        self.dataSource.loadData()
    }
    
}

//MARK:  SETUP
private extension DestinationsForMeViewController {
    func setup(){
        self.dataSource.data.addAndNotify(observer: self) { [weak self] in
            guard let self = self else {return}
            self.refreshControl?.endRefreshing()
            print(self.dataSource.data.value.first)
            guard let first = self.dataSource.data.value.first else {return}
            self.ShowLoading(status: Constants.strings.Hide, View: self.view)
            if (first.count == 0) {
                self.noDataLbl.isHidden = false
                self.noDataLbl.text = "No data found".localized()
            }else{
                self.noDataLbl.isHidden = true
            }
            //Observer here will refresh the UI and reload the fetched data
            self.destinationsCollectionView.reloadData()
            self.savedDestCountLbl.text = "\(first.count)"
        }
    }
}

