
//
//  IGStoryPreviewController.swift
//  InstagramStories
//
//  Created by Boominadha Prakash on 06/09/17.
//  Copyright © 2017 DrawRect. All rights reserved.
//

import UIKit

/**Road-Map: Story(CollectionView)->Cell(ScrollView(nImageViews:Snaps))
 If Story.Starts -> Snap.Index(Captured|StartsWith.0)
 While Snap.done->Next.snap(continues)->done
 then Story Completed
 */

protocol StoryDismissDelegate : AnyObject {
    func didDismissStory()
}
final class IGStoryPreviewController: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK: - Private Vars
    private var _view: IGStoryPreviewView!
    private var viewModel: IGStoryPreviewModel?
    
    
    public  var delegate:StoryDismissDelegate?
    
    private(set) var stories: [StoryDetails]
    /** This index will tell you which Story, user has picked*/
    private(set) var handPickedStoryIndex: Int //starts with(i)
    /** This index will tell you which Snap, user has picked*/
    private(set) var handPickedSnapIndex: Int //starts with(i)
    /** This index will help you simply iterate the story one by one*/
    
    private var nStoryIndex: Int = 0 //iteration(i+1)
    private var draggedIndex : Int = 0
    private var nIndex : Int = 0
    private var isFromDragging : Bool = false
    private var story_copy: StoryDetails?
    private(set) var layoutType: IGLayoutType
    private(set) var executeOnce = false
    var storiesIds = String()
    var storiesIdsConc = String()
    
    //check whether device rotation is happening or not
    private(set) var isTransitioning = false
    private(set) var currentIndexPath: IndexPath?
    
    private let dismissGesture: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer()
        gesture.direction = .down
        return gesture
    }()
    private let showActionSheetGesture: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer()
        gesture.direction = .up
        return gesture
    }()
    private var currentCell: IGStoryPreviewCell? {
        guard let indexPath = self.currentIndexPath else {
            debugPrint("Current IndexPath is nil")
            return nil
        }
        return self._view.snapsCollectionView.cellForItem(at: indexPath) as? IGStoryPreviewCell
    }
    lazy private var actionSheetController: UIAlertController = {
        let alertController = UIAlertController(title: "Instagram Stories", message: "More Options", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deleteSnap()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.currentCell?.resumeEntireSnap()
        }
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        return alertController
    }()
    
    //MARK: - Overriden functions
    override func loadView() {
        super.loadView()
        _view = IGStoryPreviewView.init(layoutType: self.layoutType)
        viewModel = IGStoryPreviewModel.init(self.stories, self.handPickedStoryIndex)
        _view.snapsCollectionView.decelerationRate = .fast
        dismissGesture.delegate = self
        dismissGesture.addTarget(self, action: #selector(didSwipeDown(_:)))
        _view.snapsCollectionView.addGestureRecognizer(dismissGesture)
        
        // This should be handled for only currently logged in user story and not for all other user stories.
        if(isDeleteSnapEnabled) {
            showActionSheetGesture.delegate = self
            showActionSheetGesture.addTarget(self, action: #selector(showActionSheet))
            _view.snapsCollectionView.addGestureRecognizer(showActionSheetGesture)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setup_viewConstraint()
        _view.snapsCollectionView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavigationBarHidden(true)
        // AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
       /* if UIDevice.current.userInterfaceIdiom == .phone {
            AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        }*/
        if !executeOnce {
            DispatchQueue.main.async {
                self._view.snapsCollectionView.delegate = self
                self._view.snapsCollectionView.dataSource = self
                let indexPath = IndexPath(item: self.handPickedStoryIndex, section: 0)
                self._view.snapsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                //self.handPickedStoryIndex = 0
                self.executeOnce = true
                
            }
        }/*else{
            let indexPath = IndexPath(item: self.handPickedStoryIndex, section: 0)
            let vCell =  self._view.snapsCollectionView.cellForItem(at: indexPath) as? IGStoryPreviewCell
            vCell?.didEnterForeground()
        }*/
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       /* if UIDevice.current.userInterfaceIdiom == .phone {
            AppUtility.lockOrientation(.all)
        }*/
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        isTransitioning = true
        _view.snapsCollectionView.collectionViewLayout.invalidateLayout()
    }
    init(layout:IGLayoutType = .cubic,stories: [StoryDetails],handPickedStoryIndex: Int, handPickedSnapIndex: Int = 0) {
        self.layoutType = layout
        self.stories = stories
        self.handPickedStoryIndex = handPickedStoryIndex
        self.handPickedSnapIndex = handPickedSnapIndex
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //    deinit {
    //        NotificationCenter.default.removeObserver(self)
    //    }
    override var prefersStatusBarHidden: Bool { return true }
    
    @objc private func showActionSheet() {
        self.present(actionSheetController, animated: true) { [weak self] in
            self?.currentCell?.pauseEntireSnap()
        }
    }
    private func deleteSnap() {
        guard let indexPath = currentIndexPath else {
            debugPrint("Current IndexPath is nil")
            return
        }
        let cell = _view.snapsCollectionView.cellForItem(at: indexPath) as? IGStoryPreviewCell
        cell?.deleteSnap()
    }
    //MARK: - Selectors
    @objc func didSwipeDown(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        // saveStoryStatus()
        
    }
    private func saveStoryStatus(id : String){
        print(id)
        //        let r : String = String(storiesIdsConc.dropFirst())
        StoriesManager().storiesSeen(ids: id , success: didSuccess, failed: didFailedSaveStories)
    }
    fileprivate func didSuccess(_ response:StorySeenModel?){
        DispatchQueue.main.async { [weak self] in
            guard let wself = self else {return}
            Utl.ShowLoading(status: Hide, View: wself.view)
            guard let response = response else {return}
            guard let status = response.status else { return }
        }
    }
    private func didFailedSaveStories(_ error:NSError?){
        DispatchQueue.main.async { [weak self] in
            guard let wself = self else {return}
            //                Utl.ShowLoading(status: Hide, View: wself.view)
            guard let error = error else {return}
            if error.code == 401{
                wself.setNavClear()
                Route.goCheckPhone()
            }
            // Utl.ShowNotfication(Status: Failed, Body: error.domain)
        }
    }
    
    private func setup_viewConstraint() {
        view.addSubview(_view)
        _view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            _view.leftAnchor.constraint(equalTo: view.igLeftAnchor,constant: .zero),
            _view.topAnchor.constraint(equalTo: view.igTopAnchor,constant: .zero),
            _view.rightAnchor.constraint(equalTo: view.igRightAnchor,constant: .zero),
            _view.bottomAnchor.constraint(equalTo: view.igBottomAnchor,constant: .zero)
        ])
    }
}

//MARK:- Extension|UICollectionViewDataSource
extension IGStoryPreviewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let model = viewModel else {return 0}
        let i = model.numberOfItemsInSection(section)
        return model.numberOfItemsInSection(section)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IGStoryPreviewCell.reuseIdentifier, for: indexPath) as? IGStoryPreviewCell else {
            fatalError()
        }
        let story = viewModel?.cellForItemAtIndexPath(indexPath)
        cell.storyDetails = story
        cell.delegate = self
        currentIndexPath = indexPath
        nStoryIndex = indexPath.item
        return cell
    }
}

//MARK:- Extension|UICollectionViewDelegate
extension IGStoryPreviewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? IGStoryPreviewCell else {
            return
        }
        
        //Taking Previous(Visible) cell to store previous story
        let visibleCells = collectionView.visibleCells.sortedArrayByPosition()
        let visibleCell = visibleCells.first as? IGStoryPreviewCell
        if let vCell = visibleCell {
            vCell.storyDetails?.isCompletelyVisible = false
            vCell.pauseSnapProgressors(with: (vCell.storyDetails?.lastPlayedSnapIndex)!)
            story_copy = vCell.storyDetails
        }
        //Prepare the setup for first time story launch
        if story_copy == nil {
            cell.willDisplayCellForZerothIndex(with: cell.storyDetails?.lastPlayedSnapIndex ?? 0, handpickedSnapIndex: handPickedSnapIndex)
            return
        }
        if indexPath.item == nStoryIndex {
            let s = stories[nStoryIndex/*+handPickedStoryIndex*/]
            cell.willDisplayCell(with: s.lastPlayedSnapIndex)
        }
        /// Setting to 0, otherwise for next story snaps, it will consider the same previous story's handPickedSnapIndex. It will create issue in starting the snap progressors.
        handPickedSnapIndex = 0
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let visibleCells = collectionView.visibleCells.sortedArrayByPosition()
        let visibleCell = visibleCells.first as? IGStoryPreviewCell
        guard let vCell = visibleCell else {return}
        guard let vCellIndexPath = _view.snapsCollectionView.indexPath(for: vCell) else {
            return
        }
        vCell.storyDetails?.isCompletelyVisible = true
        
        if vCell.storyDetails !=  self.story_copy {
            self.nStoryIndex = vCellIndexPath.item
            if vCell.longPressGestureState == nil {
                vCell.resumePreviousSnapProgress(with: (vCell.storyDetails?.lastPlayedSnapIndex)!)
            }
            if (vCell.storyDetails?.sub_stories?[vCell.storyDetails?.lastPlayedSnapIndex ?? 0])?.storyType == .video {
                vCell.resumePlayer(with: vCell.storyDetails?.lastPlayedSnapIndex ?? 0)
            }
            vCell.longPressGestureState = nil
        }else {
            if let cell = cell as? IGStoryPreviewCell {
                cell.stopPlayer()
            }
            
            vCell.startProgressors()
        }
        
        if vCellIndexPath.item == nStoryIndex {
            vCell.didEndDisplayingCell()
        }
    }
}

//MARK:- Extension|UICollectionViewDelegateFlowLayout
extension IGStoryPreviewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /* During device rotation, invalidateLayout gets call to make cell width and height proper.
         * InvalidateLayout methods call this UICollectionViewDelegateFlowLayout method, and the scrollView content offset moves to (0, 0). Which is not the expected result.
         * To keep the contentOffset to that same position adding the below code which will execute after 0.1 second because need time for collectionView adjusts its width and height.
         * Adjusting preview snap progressors width to Holder view width because when animation finished in portrait orientation, when we switch to landscape orientation, we have to update the progress view width for preview snap progressors also.
         * Also, adjusting progress view width to updated frame width when the progress view animation is executing.
         */
        if isTransitioning {
            let visibleCells = collectionView.visibleCells.sortedArrayByPosition()
            let visibleCell = visibleCells.first as? IGStoryPreviewCell
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { [weak self] in
                guard let strongSelf = self,
                      let vCell = visibleCell,
                      let progressIndicatorView = vCell.getProgressIndicatorView(with: vCell.snapIndex),
                      let pv = vCell.getProgressView(with: vCell.snapIndex) else {
                          fatalError("Visible cell or progressIndicatorView or progressView is nil")
                      }
                vCell.scrollview.setContentOffset(CGPoint(x: CGFloat(vCell.snapIndex) * collectionView.frame.width, y: 0), animated: false)
                vCell.adjustPreviousSnapProgressorsWidth(with: vCell.snapIndex)
                
                if pv.state == .running {
                    pv.widthConstraint?.constant = progressIndicatorView.frame.width
                }
                strongSelf.isTransitioning = false
            }
        }
        if #available(iOS 11.0, *) {
            return CGSize(width: _view.snapsCollectionView.safeAreaLayoutGuide.layoutFrame.width, height: _view.snapsCollectionView.safeAreaLayoutGuide.layoutFrame.height)
        } else {
            return CGSize(width: _view.snapsCollectionView.frame.width, height: _view.snapsCollectionView.frame.height)
        }
    }
}

//MARK:- Extension|UIScrollViewDelegate<CollectionView>
extension IGStoryPreviewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let vCell = _view.snapsCollectionView.visibleCells.first as? IGStoryPreviewCell else {return}
        vCell.pauseSnapProgressors(with: (vCell.storyDetails?.lastPlayedSnapIndex)!)
        vCell.pausePlayer(with: (vCell.storyDetails?.lastPlayedSnapIndex)!)
        draggedIndex = vCell.storyDetails?.lastPlayedSnapIndex ?? 0
        isFromDragging = true
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let sortedVCells = _view.snapsCollectionView.visibleCells.sortedArrayByPosition()
        guard let f_Cell = sortedVCells.first as? IGStoryPreviewCell else {return}
        guard let l_Cell = sortedVCells.last as? IGStoryPreviewCell else {return}
        let f_IndexPath = _view.snapsCollectionView.indexPath(for: f_Cell)
        let l_IndexPath = _view.snapsCollectionView.indexPath(for: l_Cell)
        let numberOfItems = collectionView(_view.snapsCollectionView, numberOfItemsInSection: 0)-1
        
        if l_IndexPath?.item == 0 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2) {
                self.dismiss(animated: true, completion: nil)
            }
        }else if f_IndexPath?.item == numberOfItems {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

//MARK:- StoryPreview Protocol implementation
extension IGStoryPreviewController: StoryPreviewProtocol {
    
    func openDeepLinkAction(story : Story, index : Int) {
        let type = story.deepLinkType
        let item_id = story.deepLinkItemID
        
        switch type {
        case 1:
            let liveStreamVC: LiveStreamViewController = UIStoryboard.instanceFromLive()
            let nav = UINavigationController(rootViewController: liveStreamVC)
            nav.modalPresentationStyle = .fullScreen
            nav.modalTransitionStyle = .crossDissolve
            self.present(nav, animated: true, completion: nil)
        case 2:
            let screen: ProgramEpisodeDetailsVC = UIStoryboard.instanceFromDeviceManagement()
            let navBar = UINavigationController.init(rootViewController: screen)
            screen.episodeId = item_id //34800 //
            navBar.modalPresentationStyle = .popover
            navBar.hidesBottomBarWhenPushed = true
            screen.delegate = self
            //screen.setNavigationBarHidden(true)
            self.presentVC(navBar)
        case 4:
            let screen: ProgramDetailsViewController = UIStoryboard.instanceFromDeviceManagement()
            let navBar = UINavigationController.init(rootViewController: screen)
            screen.seriesId = item_id   //93 //
            navBar.modalPresentationStyle = .popover
            screen.hidesBottomBarWhenPushed = true
            screen.setNavigationBarHidden(false)
            screen.delegate = self
            self.present(navBar, animated: true)
        case 3:
            
            let screen: SeriesDetailsViewController = UIStoryboard.instanceFromDeviceManagement()
            let navBar = UINavigationController.init(rootViewController: screen)
            screen.seriesId = item_id   //306 //
            navBar.modalPresentationStyle = .popover
            screen.hidesBottomBarWhenPushed = true
            screen.setNavigationBarHidden(false)
            screen.delegate = self
            self.present(navBar, animated: true)
            
        case 5:
            
            let screen: SeriesDetailsViewController = UIStoryboard.instanceFromDeviceManagement()
            let navBar = UINavigationController.init(rootViewController: screen)
            screen.seriesId = item_id  //1095 //
            navBar.modalPresentationStyle = .popover
            screen.hidesBottomBarWhenPushed = true
            screen.setNavigationBarHidden(false)
            screen.delegate = self
            self.present(navBar, animated: true)
            
        case 6:
            
            let screen: ArticlesDetailsViewController = UIStoryboard.instanceFromArticles()
            let navBar = UINavigationController.init(rootViewController: screen)
            screen.article_id = "\(item_id)"  //"4444" //
            navBar.modalPresentationStyle = .popover
            screen.hidesBottomBarWhenPushed = true
            screen.setNavigationBarHidden(false)
            screen.delegate = self
            self.present(navBar, animated: true)
            
        case 7:
            let url = URL(string: "\( String(describing: currentCell?.storyDetails?.sub_stories![currentCell!.snapIndex].deepLink ?? ""))")
            guard let url = url else {return}
            UIApplication.shared.open(url)
        default:
            print("Have you done something new?")
            
        }
        
    }
    
    func didSeenStory(id: String) {
        saveStoryStatus(id: id)
    }
    
    func didCompletePreview() {
        //nIndex = handPickedStoryIndex+nStoryIndex+1
        if  nStoryIndex < stories.count - 1 {
            //Move to next story
            currentCell?.moreBtn.removeFromSuperview()
            story_copy = stories[nStoryIndex]
            nStoryIndex = nStoryIndex + 1
            handPickedStoryIndex = handPickedStoryIndex + 1
            if handPickedStoryIndex >= stories.count {
                   handPickedStoryIndex = stories.count - 1
            }
            let nIndexPath = IndexPath.init(row: nStoryIndex, section: 0)
            _view.snapsCollectionView.scrollToItem(at: nIndexPath, at: .left, animated: true)
        }else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    /*
     func didCompletePreview() {
         //nIndex = handPickedStoryIndex+nStoryIndex+1
         if  nStoryIndex < stories.count {
             //Move to next story
             currentCell?.moreBtn.removeFromSuperview()
             story_copy = stories[nStoryIndex+handPickedStoryIndex]
             nStoryIndex = nStoryIndex + 1
             handPickedStoryIndex = handPickedStoryIndex + 1 //RanaH On 10Jun2022
             let nIndexPath = IndexPath.init(row: nStoryIndex, section: 0)
             _view.snapsCollectionView.scrollToItem(at: nIndexPath, at: .left, animated: true)
         }else {
             self.dismiss(animated: true, completion: nil)
         }
     }
     */
    func moveToPreviousStory() {
         if nStoryIndex >= 1 &&  nStoryIndex < stories.count  {
             story_copy = stories[nStoryIndex]
             nStoryIndex = nStoryIndex - 1
             
             handPickedStoryIndex = handPickedStoryIndex - 1
             if handPickedStoryIndex < 0 {
                    handPickedStoryIndex = 0
             }
             let nIndexPath = IndexPath.init(row: nStoryIndex, section: 0)
             _view.snapsCollectionView.scrollToItem(at: nIndexPath, at: .right, animated: true)
         } else {
             self.dismiss(animated: true, completion: nil)
         }
     }
    
   /* func moveToPreviousStory() {
        let n = nStoryIndex+1
        if n <= stories.count && n > 1 {
            story_copy = stories[nStoryIndex+handPickedStoryIndex]
            nStoryIndex = nStoryIndex - 1
            let nIndexPath = IndexPath.init(row: nStoryIndex, section: 0)
            _view.snapsCollectionView.scrollToItem(at: nIndexPath, at: .right, animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }*/
    func didTapCloseButton() {
        self.dismiss(animated: true, completion:nil)
        //  self.saveStoryStatus()
    }
    
    func didTapShareButton(shareTxt: String) {
        let textToShare = [ shareTxt ]
        print("shareTxt: ",shareTxt)
        let activity = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activity.popoverPresentationController?.sourceView = self.view
        
        activity.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        activity.completionWithItemsHandler = { activity, success, items, error in
            guard let vCell = self._view.snapsCollectionView.visibleCells.first as? IGStoryPreviewCell else {return}
            vCell.resumeEntireSnap()
            print("activity: \(activity), success: \(success), items: \(items), error: \(error)")
            
        }
        self.present(activity, animated: true, completion: nil)
        
    }
    
}


extension IGStoryPreviewController: ParentViewMPUControllerProtocol{
    func getBackToStory(){
        let indexPath = IndexPath(item: self.handPickedStoryIndex, section: 0)
        let vCell =  self._view.snapsCollectionView.cellForItem(at: indexPath) as? IGStoryPreviewCell
        vCell?.didEnterForeground()
        
    }
}
