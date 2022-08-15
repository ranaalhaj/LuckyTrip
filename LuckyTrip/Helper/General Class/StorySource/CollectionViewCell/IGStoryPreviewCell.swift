//
//  IGStoryPreviewCell.swift
//  InstagramStories
//
//  Created by Boominadha Prakash on 06/09/17.
//  Copyright © 2017 DrawRect. All rights reserved.
//

import UIKit
import AVKit
import Alamofire

protocol StoryPreviewProtocol: AnyObject {
    func didCompletePreview()
    func moveToPreviousStory()
    func didTapCloseButton()
    func didTapShareButton(shareTxt: String)
    func didSeenStory(id : String)
    func openDeepLinkAction(story : Story, index : Int)
}
enum SnapMovementDirectionState {
    case forward
    case backward
}

//Identifiers
fileprivate let snapViewTagIndicator: Int = 8
fileprivate var textToShare: String = ""

final class IGStoryPreviewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    //MARK: - Delegate
    public weak var delegate: StoryPreviewProtocol? {
        didSet { storyHeaderView.delegate = self }
    }
    
    //MARK:- Private iVars
    private lazy var storyHeaderView: IGStoryPreviewHeaderView = {
        let v = IGStoryPreviewHeaderView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var longPress_gesture: UILongPressGestureRecognizer = {
        let lp = UILongPressGestureRecognizer.init(target: self, action: #selector(didLongPress(_:)))
        lp.minimumPressDuration = 0.2
        lp.delegate = self
        return lp
    }()
    
    
    private lazy var tap_gesture: UITapGestureRecognizer = {
        let tg = UITapGestureRecognizer(target: self, action: #selector(didTapSnap(_:)))
        tg.cancelsTouchesInView = false;
        tg.numberOfTapsRequired = 1
        tg.delegate = self
        return tg
    }()
    
    private var previousSnapIndex: Int {
        return snapIndex - 1
    }
    private var snapViewXPos: CGFloat {
        return (snapIndex == 0) ? 0 : scrollview.subviews[previousSnapIndex].frame.maxX
    }
    private var videoSnapIndex: Int = 0
    private var handpickedSnapIndex: Int = 0
    var retryBtn: IGRetryLoaderButton!
    var longPressGestureState: UILongPressGestureRecognizer.State?
    public var  moreBtn : UIButton{
        let button = UIButton()
        button.frame = CGRect(x: (contentView.frame.size.width / 2) - (100 / 2), y: contentView.frame.size.height -  80, width: 100, height: 80)
        button.setImage(UIImage(named: "Image"), for: .normal)
        button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.cornerRadius_ = 12
        button.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        return button
    }
    
    //MARK:- Public iVars
    public var direction: SnapMovementDirectionState = .forward
    public let scrollview: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        sv.isScrollEnabled = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    public var getSnapIndex: Int {
        return snapIndex
    }
    public var snapIndex: Int = 0 {
        didSet {
            scrollview.isUserInteractionEnabled = true
            switch direction {
            case .forward:
                if snapIndex < storyDetails?.subStoriesCount ?? 0{
                    textToShare = storyDetails?.url_share ?? ""
                    if let snap = storyDetails?.sub_stories?[snapIndex] {
                        if snap.storyType != MimeType.video {
                            if let snapView = getSnapview() {
                                startRequest(snapView: snapView, with: snap.file ?? "")
                            } else {
                                let snapView = createSnapView()
                                startRequest(snapView: snapView, with: snap.file ?? "")
                            }
                        }else {
                            if let videoView = getVideoView(with: snapIndex) {
                                startPlayer(videoView: videoView, with: snap.file ?? "")
                            }else {
                                let videoView = createVideoView()
                                startPlayer(videoView: videoView, with: snap.file ?? "")
                            }
                        }
                        storyHeaderView.snaperNameLabel.text = snap.title
                        storyHeaderView.snaperNameLabel.font = UIFont(name: Constants.Fonts.AlmaraiRegular, size: 13)
                        descriptionLabel.text = snap.desc
                        descriptionLabel.textAlignment = .center
                        descriptionLabel.font = UIFont(name: Constants.Fonts.AlmaraiRegular, size: 13)
                        if snap.deepLinkType == 0 {
                            // moreBtn.isHidden = true
                            moreBtn.removeFromSuperview()
                        }else{
                            //  moreBtn.isHidden = false
                            DisplayMoreButton()
                        }
                    }
                    
                }
            case .backward:
                if snapIndex < storyDetails?.subStoriesCount ?? 0{
                    textToShare = storyDetails?.url_share ?? ""
                    if let snap = storyDetails?.sub_stories?[snapIndex] {
                        if snap.storyType != MimeType.video {
                            if let snapView = getSnapview() {
                                self.startRequest(snapView: snapView, with: snap.file ?? "")
                            }
                        }else {
                            if let videoView = getVideoView(with: snapIndex) {
                                startPlayer(videoView: videoView, with: snap.file ?? "")
                            }
                            else {
                                let videoView = self.createVideoView()
                                self.startPlayer(videoView: videoView, with: snap.file ?? "")
                            }
                        }
                        //storyHeaderView.lastUpdatedLabel.text = snap.lastUpdated
                        storyHeaderView.snaperNameLabel.text = snap.title
                        descriptionLabel.text = snap.desc
                        
                        if snap.deepLinkType == 0 {
                            //moreBtn.isHidden = true
                            moreBtn.removeFromSuperview()
                        }else{
                            //moreBtn.isHidden = false
                            DisplayMoreButton()
                        }
                    }
                }
            }
        }
    }
    
    public var storyDetails: StoryDetails? {
        didSet {
            print("testtt::",storyDetails?.sub_stories ?? [])
            storyHeaderView.storyDetails = storyDetails
            if let picture = storyDetails?.url {
                storyHeaderView.snaperImageView.setImage(url: picture)
            }
            if !isGuest() {
                if let id = storyDetails?.id, let seen = storyDetails?.is_seen{
                    if seen != true{
                        delegate?.didSeenStory(id: "\(id)" )
                    }
                    
                }
            }
        }
    }
    
    internal let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    func DisplayMoreButton(){
      
        self.contentView.addSubview(moreBtn)
        let xConstraint = NSLayoutConstraint(item: moreBtn, attribute: .centerX, relatedBy: .equal, toItem: self.contentView, attribute: .centerX, multiplier: 1, constant: 0)
        
       //self.contentView.addConstraint(xConstraint)
    }
    
 
    @objc func moreButtonTapped(sender: UIButton!) {
        let tag = snapIndex
        didEnterBackground()
        pauseEntireSnap()
        stopPlayer()
        stopSnapProgressors(with: self.snapIndex)
        self.delegate?.openDeepLinkAction(story: (storyDetails?.sub_stories![tag])!, index : tag)
    }
    
    //MARK: - Overriden functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollview.frame = bounds
        loadUIElements()
        installLayoutConstraints()
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        direction = .forward
        clearScrollViewGarbages()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Private functions
    private func loadUIElements() {
        scrollview.delegate = self
        scrollview.isPagingEnabled = true
        scrollview.backgroundColor = .black
        contentView.addSubview(scrollview)
        contentView.addSubview(storyHeaderView)
        contentView.addSubview(descriptionLabel)
        scrollview.addGestureRecognizer(longPress_gesture)
        scrollview.addGestureRecognizer(tap_gesture)
        
    }
    
    private func installLayoutConstraints() {
        //Setting constraints for scrollview
        
        NSLayoutConstraint.activate([
            scrollview.igLeftAnchor.constraint(equalTo: contentView.igLeftAnchor),
            contentView.igRightAnchor.constraint(equalTo: scrollview.igRightAnchor),
            scrollview.igTopAnchor.constraint(equalTo: contentView.igTopAnchor),
            contentView.igBottomAnchor.constraint(equalTo: scrollview.igBottomAnchor),
            scrollview.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.0),
            scrollview.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1.0)
        ])
        NSLayoutConstraint.activate([
            storyHeaderView.igLeftAnchor.constraint(equalTo: contentView.igLeftAnchor),
            contentView.igRightAnchor.constraint(equalTo: storyHeaderView.igRightAnchor),
            storyHeaderView.igTopAnchor.constraint(equalTo: contentView.igTopAnchor),
            storyHeaderView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            contentView.trailingAnchor.constraint(equalTo: descriptionLabel.safeAreaLayoutGuide.trailingAnchor,constant: 10),
            //contentView.igRightAnchor.constraint(equalTo: descriptionLabel.igRightAnchor, constant: 10),
            contentView.igBottomAnchor.constraint(equalTo: descriptionLabel.igBottomAnchor, constant: 65),
        ])
        
        self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        descriptionLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
    }
    private func createSnapView() -> UIImageView {
        let snapView = UIImageView()
        snapView.backgroundColor = UIColor(named: "Black_181E24")
        snapView.translatesAutoresizingMaskIntoConstraints = false
        snapView.contentMode = .scaleAspectFill
        snapView.tag = snapIndex + snapViewTagIndicator
        
        
        scrollview.subviews.filter({$0.tag == snapIndex + snapViewTagIndicator}).first?.removeFromSuperview()
        
        scrollview.addSubview(snapView)
        
        
        /// Setting constraints for snap view.
        NSLayoutConstraint.activate([
            
            snapView.centerXAnchor.constraint(equalTo: scrollview.centerXAnchor),
            snapView.centerYAnchor.constraint(equalTo: scrollview.centerYAnchor),
            snapView.heightAnchor.constraint(equalTo: snapView.widthAnchor, multiplier: 16/9),
            snapView.widthAnchor.constraint(equalToConstant: scrollview.width),
            snapView.igTopAnchor.constraint(equalTo: scrollview.igTopAnchor),
            scrollview.centerYAnchor.constraint(equalTo: snapView.centerYAnchor),
            scrollview.igBottomAnchor.constraint(equalTo: snapView.igBottomAnchor),
        ])
        snapView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        if(snapIndex != 0) {
            NSLayoutConstraint.activate([
                snapView.leftAnchor.constraint(equalTo: scrollview.leftAnchor, constant: CGFloat(snapIndex)*scrollview.width)
            ])
        }
        return snapView
    }
    func getSnapview() -> UIImageView? {
        if let imageView = scrollview.subviews.filter({$0.tag == snapIndex + snapViewTagIndicator}).first as? UIImageView {
            return imageView
        }
        return nil
    }
    func createVideoView() -> IGPlayerView {
        let videoView = IGPlayerView()
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.tag = snapIndex + snapViewTagIndicator
        videoView.playerObserverDelegate = self
        
        scrollview.subviews.filter({$0.tag == snapIndex + snapViewTagIndicator}).first?.removeFromSuperview()
        
        scrollview.addSubview(videoView)
        NSLayoutConstraint.activate([
            
            videoView.leftAnchor.constraint(equalTo: (snapIndex == 0) ? scrollview.leftAnchor : scrollview.subviews[previousSnapIndex].rightAnchor),
            videoView.igTopAnchor.constraint(equalTo: scrollview.igTopAnchor),
            scrollview.centerXAnchor.constraint(equalTo: videoView.centerXAnchor),
            self.contentView.centerYAnchor.constraint(equalTo: videoView.centerYAnchor),
            scrollview.igBottomAnchor.constraint(equalTo: videoView.igBottomAnchor),
            videoView.heightAnchor.constraint(equalTo: videoView.widthAnchor, multiplier: 16/9)
        ])
        videoView.transform = CGAffineTransform(scaleX: -1, y: 1)
        
        if(snapIndex != 0) {
            NSLayoutConstraint.activate([
                videoView.leftAnchor.constraint(equalTo: scrollview.leftAnchor, constant: CGFloat(snapIndex)*scrollview.width)
            ])
        }
        return videoView
    }
    private func getVideoView(with index: Int) -> IGPlayerView? {
        if let videoView = scrollview.subviews.filter({$0.tag == index + snapViewTagIndicator}).first as? IGPlayerView {
            return videoView
        }
        return nil
    }
    
    func startRequest(snapView: UIImageView, with url: String) {
        
        snapView.setImage(url: url, style: .squared) { result in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return}
                switch result {
                case .success(_):
                    /// Start progressor only if handpickedSnapIndex matches with snapIndex and the requested image url should be matched with current snapIndex imageurl
                    if(strongSelf.handpickedSnapIndex == strongSelf.snapIndex && url == strongSelf.storyDetails!.sub_stories?[strongSelf.snapIndex].file) {
                        strongSelf.startProgressors()
                    }
                case .failure(_):
                 //   strongSelf.showRetryButton(with: url, for: snapView)
                    let y = 0 
                }
            }
        }
    }
    
    private func showRetryButton(with url: String, for snapView: UIImageView) {
        self.retryBtn = IGRetryLoaderButton.init(withURL: url)
        self.retryBtn.translatesAutoresizingMaskIntoConstraints = false
        self.retryBtn.delegate = self
        self.isUserInteractionEnabled = true
        snapView.addSubview(self.retryBtn)
        NSLayoutConstraint.activate([
            self.retryBtn.igCenterXAnchor.constraint(equalTo: snapView.igCenterXAnchor),
            self.retryBtn.igCenterYAnchor.constraint(equalTo: snapView.igCenterYAnchor)
        ])
    }
    private func startPlayer(videoView: IGPlayerView, with url: String) {
        if scrollview.subviews.count > 0 {
            if storyDetails?.isCompletelyVisible == true {
                videoView.startAnimating()
                print("video url :: ",url)
                //DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3) { [weak self] in
                IGVideoCacheManager.shared.getFile(for: url) { [weak self] (result) in
                    // guard let strongSelf = self else { return }
                    switch result {
                    case .success(let videoURL):
                        //videoView.stopAnimating()
                        /// Start progressor only if handpickedSnapIndex matches with snapIndex
                        let videoResource = VideoResource(filePath: videoURL.absoluteString)
                        videoView.play(with: videoResource)
                        self?.resumeEntireSnap()
                        //                            if(strongSelf.handpickedSnapIndex == strongSelf.snapIndex) {
                        //
                        //                            }
                    case .failure(let error):
                        videoView.stopAnimating()
                        debugPrint("Video error: \(error)")
                    }
                }
            }
        }
    }
    //}
    @objc private func didLongPress(_ sender: UILongPressGestureRecognizer) {
        longPressGestureState = sender.state
        if sender.state == .began ||  sender.state == .ended {
            if(sender.state == .began) {
                pauseEntireSnap()
            } else {
                resumeEntireSnap()
            }
        }
    }
    @objc private func didTapSnap(_ sender: UITapGestureRecognizer) {
        let touchLocation = sender.location(ofTouch: 0, in: self.scrollview)
        
        if let snapCount = storyDetails?.subStoriesCount {
            var n = snapIndex
            /*!
             * Based on the tap gesture(X) setting the direction to either forward or backward
             */
            if let snap = storyDetails?.sub_stories?[n]{
                if snap.storyType == .image , getSnapview()?.image == nil{
                    //Remove retry button if tap forward or backward if it exists
                    if let snapView = getSnapview(), let btn = retryBtn, snapView.subviews.contains(btn) {
                        snapView.removeRetryButton()
                    }
                    fillupLastPlayedSnap(n)
                }
            }else {
                //Remove retry button if tap forward or backward if it exists
                if let videoView = getVideoView(with: n), let btn = retryBtn, videoView.subviews.contains(btn) {
                    videoView.removeRetryButton()
                }
                if getVideoView(with: n)?.player?.timeControlStatus != .playing {
                    fillupLastPlayedSnap(n)
                }
            }
            if touchLocation.x < scrollview.contentOffset.x + (scrollview.frame.width/2) {
                direction = .backward
                if snapIndex >= 1 && snapIndex <= snapCount {
                    clearLastPlayedSnaps(n)
                    stopSnapProgressors(with: n)
                    n -= 1
                    resetSnapProgressors(with: n)
                    willMoveToPreviousOrNextSnap(n: n)
                } else {
                    delegate?.moveToPreviousStory()
                }
            } else {
                if snapIndex >= 0 && snapIndex <= snapCount {
                    //Stopping the current running progressors
                    stopSnapProgressors(with: n)
                    direction = .forward
                    n += 1
                    willMoveToPreviousOrNextSnap(n: n)
                }
            }
        }
    }
    
    @objc func didEnterForeground() {
        if let story  = storyDetails {
            if let snap = story.sub_stories?[snapIndex] {
                if snap.storyType == .video {
                    let videoView = getVideoView(with: snapIndex)
                    startPlayer(videoView: videoView!, with: snap.file ?? "")
                }else {
                    startSnapProgress(with: snapIndex)
                }
            }
        }
    }
    @objc  func didEnterBackground() {
        if let story  = storyDetails {
            if let snap = story.sub_stories?[snapIndex] {
                if snap.storyType == .video {
                    stopPlayer()
                }
            }
        }
        resetSnapProgressors(with: snapIndex)
    }
    private func willMoveToPreviousOrNextSnap(n: Int) {
        if let count = storyDetails?.subStoriesCount {
            if n < count {
                //Move to next or previous snap based on index n
                let x = n.toFloat * frame.width
                let offset = CGPoint(x: x,y: 0)
                scrollview.setContentOffset(offset, animated: false)
                storyDetails?.lastPlayedSnapIndex = n
                handpickedSnapIndex = n
                snapIndex = n
            } else {
                delegate?.didCompletePreview()
            }
        }
    }
    @objc private func didCompleteProgress() {
        let n = snapIndex + 1
        if let count = storyDetails?.subStoriesCount {
            if n < count {
                //Move to next snap
                let x = n.toFloat * frame.width
                let offset = CGPoint(x: x,y: 0)
                scrollview.setContentOffset(offset, animated: false)
                storyDetails?.lastPlayedSnapIndex = n
                direction = .forward
                handpickedSnapIndex = n
                snapIndex = n
            }else {
                stopPlayer()
                delegate?.didCompletePreview()
            }
        }
    }
    private func fillUpMissingImageViews(_ sIndex: Int) {
        if sIndex != 0 {
            for i in 0..<sIndex {
                snapIndex = i
            }
            let xValue = sIndex.toFloat * scrollview.frame.width
            scrollview.contentOffset = CGPoint(x: xValue, y: 0)
        }
    }
    //Before progress view starts we have to fill the progressView
    private func fillupLastPlayedSnap(_ sIndex: Int) {
        if let snap = storyDetails?.sub_stories?[sIndex], snap.storyType == .video {
            videoSnapIndex = sIndex
            stopPlayer()
        }
        if let holderView = self.getProgressIndicatorView(with: sIndex),
           let progressView = self.getProgressView(with: sIndex){
            progressView.widthConstraint?.isActive = false
            progressView.widthConstraint = progressView.widthAnchor.constraint(equalTo: holderView.widthAnchor, multiplier: 1.0)
            progressView.widthConstraint?.isActive = true
        }
    }
    private func fillupLastPlayedSnaps(_ sIndex: Int) {
        //Coz, we are ignoring the first.snap
        if sIndex != 0 {
            for i in 0..<sIndex {
                if let holderView = self.getProgressIndicatorView(with: i),
                   let progressView = self.getProgressView(with: i){
                    progressView.widthConstraint?.isActive = false
                    progressView.widthConstraint = progressView.widthAnchor.constraint(equalTo: holderView.widthAnchor, multiplier: 1.0)
                    progressView.widthConstraint?.isActive = true
                }
            }
        }
    }
    private func clearLastPlayedSnaps(_ sIndex: Int) {
        if let _ = self.getProgressIndicatorView(with: sIndex),
           let progressView = self.getProgressView(with: sIndex) {
            progressView.widthConstraint?.isActive = false
            progressView.widthConstraint = progressView.widthAnchor.constraint(equalToConstant: 0)
            progressView.widthConstraint?.isActive = true
        }
    }
    private func clearScrollViewGarbages() {
        scrollview.contentOffset = CGPoint(x: 0, y: 0)
        if scrollview.subviews.count > 0 {
            var i = 0 + snapViewTagIndicator
            var snapViews = [UIView]()
            scrollview.subviews.forEach({ (imageView) in
                if imageView.tag == i {
                    snapViews.append(imageView)
                    i += 1
                }
            })
            if snapViews.count > 0 {
                snapViews.forEach({ (view) in
                    view.removeFromSuperview()
                })
            }
        }
    }
    
    private func gearupTheProgressors(type: MimeType, playerView: IGPlayerView? = nil) {
        if let holderView = getProgressIndicatorView(with: snapIndex),
           let progressView = getProgressView(with: snapIndex){
            progressView.story_identifier = self.storyDetails?.internalIdentifier
            progressView.snapIndex = snapIndex
            DispatchQueue.main.async {
                if type == .image {
                    progressView.start(with: 5.0, holderView: holderView, completion: {(identifier, snapIndex, isCancelledAbruptly) in
                        print("Completed snapindex: \(snapIndex)")
                        if isCancelledAbruptly == false {
                            self.didCompleteProgress()
                        }
                    })
                }else {
                    //Handled in delegate methods for videos
                }
            }
        }
    }
    
    //MARK:- Internal functions
    func startProgressors() {
        DispatchQueue.main.async {
            if self.scrollview.subviews.count > 0 {
                let imageView = self.scrollview.subviews.filter{v in v.tag == self.snapIndex + snapViewTagIndicator}.first as? UIImageView
                if imageView?.image != nil && self.storyDetails?.isCompletelyVisible == true {
                    self.gearupTheProgressors(type: .image)
                } else {
                    // Didend displaying will call this startProgressors method. After that only isCompletelyVisible get true. Then we have to start the video if that snap contains video.
                    if self.storyDetails?.isCompletelyVisible == true {
                        let videoView = self.scrollview.subviews.filter{v in v.tag == self.snapIndex + snapViewTagIndicator}.first as? IGPlayerView
                        let snap = self.storyDetails?.sub_stories?[self.snapIndex]
                        if let vv = videoView, self.storyDetails?.isCompletelyVisible == true {
                            self.startPlayer(videoView: vv, with: snap!.file ?? "")
                        }
                    }
                }
            }
        }
    }
    func getProgressView(with index: Int) -> IGSnapProgressView? {
        let progressView = storyHeaderView.getProgressView
        if progressView.subviews.count > 0 {
            let pv = getProgressIndicatorView(with: index)?.subviews.first as? IGSnapProgressView
            guard let currentStory = self.storyDetails else {
                fatalError("story not found")
            }
            pv?.story = currentStory
            //print("Current:::" , currentStory)
            return pv
        }
        return nil
    }
    func getProgressIndicatorView(with index: Int) -> IGSnapProgressIndicatorView? {
        let progressView = storyHeaderView.getProgressView
        return progressView.subviews.filter({v in v.tag == index+progressIndicatorViewTag}).first as? IGSnapProgressIndicatorView ?? nil
    }
    func adjustPreviousSnapProgressorsWidth(with index: Int) {
        fillupLastPlayedSnaps(index)
    }
    func deleteSnap() {
        let progressView = storyHeaderView.getProgressView
        clearLastPlayedSnaps(snapIndex)
        stopSnapProgressors(with: snapIndex)
        
        let snapCount = storyDetails?.subStoriesCount ?? 0
        if let lastIndicatorView = getProgressIndicatorView(with: snapCount-1), let preLastIndicatorView = getProgressIndicatorView(with: snapCount-2) {
            
            lastIndicatorView.constraints.forEach { $0.isActive = false }
            
            preLastIndicatorView.rightConstraiant?.isActive = false
            preLastIndicatorView.rightConstraiant = progressView.igRightAnchor.constraint(equalTo: preLastIndicatorView.igRightAnchor, constant: 8)
            preLastIndicatorView.rightConstraiant?.isActive = true
        } else {
            debugPrint("No Snaps")
        }
        
        if storyDetails?.sub_stories?[snapIndex].storyType == .video {
            stopPlayer()
        }
        scrollview.subviews.filter({$0.tag == snapIndex + snapViewTagIndicator}).first?.removeFromSuperview()
        
        storyDetails?.sub_stories?[snapIndex].isDeleted = true
        direction = .forward
        for sIndex in 0..<snapIndex {
            if let holderView = self.getProgressIndicatorView(with: sIndex),
               let progressView = self.getProgressView(with: sIndex){
                progressView.widthConstraint?.isActive = false
                progressView.widthConstraint = progressView.widthAnchor.constraint(equalTo: holderView.widthAnchor, multiplier: 1.0)
                progressView.widthConstraint?.isActive = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3) {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.willMoveToPreviousOrNextSnap(n: strongSelf.snapIndex)
        }
    }
    
    //MARK: - Public functions
    public func willDisplayCellForZerothIndex(with sIndex: Int, handpickedSnapIndex: Int) {
        self.handpickedSnapIndex = handpickedSnapIndex
        storyDetails?.isCompletelyVisible = true
        willDisplayCell(with: handpickedSnapIndex)
    }
    public func willDisplayCell(with sIndex: Int) {
        //Todo:Make sure to move filling part and creating at one place
        //Clear the progressor subviews before the creating new set of progressors.
        storyHeaderView.clearTheProgressorSubviews()
        storyHeaderView.createSnapProgressors()
    
        fillUpMissingImageViews(sIndex)
        fillupLastPlayedSnaps(sIndex)
        snapIndex = sIndex
        
        //Remove the previous observors
        NotificationCenter.default.removeObserver(self)
        
        
        // Add the observer to handle application from background to foreground
        NotificationCenter.default.addObserver(self, selector: #selector(self.didEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    public func startSnapProgress(with sIndex: Int) {
        if let indicatorView = getProgressIndicatorView(with: sIndex),
           let pv = getProgressView(with: sIndex) {
            pv.start(with: 5.0, holderView: indicatorView, completion: { (identifier, snapIndex, isCancelledAbruptly) in
                if isCancelledAbruptly == false {
                    self.didCompleteProgress()
                }
            })
        }
    }
    public func pauseSnapProgressors(with sIndex: Int) {
        storyDetails?.isCompletelyVisible = false
        getProgressView(with: sIndex)?.pause()
    }
    public func stopSnapProgressors(with sIndex: Int) {
        getProgressView(with: sIndex)?.stop()
    }
    public func resetSnapProgressors(with sIndex: Int) {
        self.getProgressView(with: sIndex)?.reset()
    }
    public func pausePlayer(with sIndex: Int) {
        getVideoView(with: sIndex)?.pause()
    }
    public func stopPlayer() {
        let videoView = getVideoView(with: videoSnapIndex)
        if videoView?.player?.timeControlStatus != .playing {
            getVideoView(with: videoSnapIndex)?.player?.replaceCurrentItem(with: nil)
            let progressView = getProgressView(with: videoSnapIndex)
            progressView?.resume()
        }
        videoView?.stop()
        //getVideoView(with: videoSnapIndex)?.player = nil
    }
    public func resumePlayer(with sIndex: Int) {
        getVideoView(with: sIndex)?.play()
    }
    public func didEndDisplayingCell() {
        
    }
    public func resumePreviousSnapProgress(with sIndex: Int) {
        getProgressView(with: sIndex)?.resume()
    }
    public func pauseEntireSnap() {
        let v = getProgressView(with: snapIndex)
        let videoView = scrollview.subviews.filter{v in v.tag == snapIndex + snapViewTagIndicator}.first as? IGPlayerView
        if videoView != nil {
            v?.pause()
            videoView?.pause()
        }else {
            v?.pause()
        }
    }
    public func resumeEntireSnap() {
        let v = getProgressView(with: snapIndex)
        let videoView = scrollview.subviews.filter{v in v.tag == snapIndex + snapViewTagIndicator}.first as? IGPlayerView
        if videoView != nil {
            v?.resume()
            videoView?.play()
        }else {
            v?.resume()
        }
    }
    //Used the below function for image retry option
    public func retryRequest(view: UIView, with url: String) {
        if let v = view as? UIImageView {
            v.removeRetryButton()
            self.startRequest(snapView: v, with: url)
        }else if let v = view as? IGPlayerView {
            v.removeRetryButton()
            self.startPlayer(videoView: v, with: url)
        }
    }
}

//MARK: - Extension|StoryPreviewHeaderProtocol
extension IGStoryPreviewCell: StoryPreviewHeaderProtocol {
    
    func didTapShareButton(textToShare: String) {
        delegate?.didTapShareButton(shareTxt: textToShare)
        pauseEntireSnap()
    }
    
    func didTapCloseButton() {
        delegate?.didTapCloseButton()
    }
}

//MARK: - Extension|RetryBtnDelegate
extension IGStoryPreviewCell: RetryBtnDelegate {
    func retryButtonTapped() {
        
        self.retryRequest(view: retryBtn.superview!, with: retryBtn.contentURL!)
        
    }
}

//MARK: - Extension|IGPlayerObserverDelegate
extension IGStoryPreviewCell: IGPlayerObserver {
    
    func didStartPlaying() {
        if let videoView = getVideoView(with: snapIndex), videoView.currentTime <= 0 {
            if videoView.error == nil && (storyDetails?.isCompletelyVisible)! == true {
                if let holderView = getProgressIndicatorView(with: snapIndex),
                   let progressView = getProgressView(with: snapIndex) {
                    progressView.story_identifier = self.storyDetails?.internalIdentifier
                    progressView.snapIndex = snapIndex
                    if let duration = videoView.currentItem?.asset.duration {
                        if Float(duration.value) > 0 {
                            progressView.start(with: duration.seconds, holderView: holderView, completion: {(identifier, snapIndex, isCancelledAbruptly) in
                                if isCancelledAbruptly == false {
                                    self.videoSnapIndex = snapIndex
                                    self.stopPlayer()
                                    self.didCompleteProgress()
                                } else {
                                    self.videoSnapIndex = snapIndex
                                    self.stopPlayer()
                                }
                            })
                        }else {
                            debugPrint("Player error: Unable to play the video")
                        }
                    }
                }
            }
        }
    }
    func didFailed(withError error: String, for url: URL?) {
        debugPrint("Failed with error: \(error)")
        if let videoView = getVideoView(with: snapIndex), let videoURL = url {
            self.retryBtn = IGRetryLoaderButton(withURL: videoURL.absoluteString)
            self.retryBtn.translatesAutoresizingMaskIntoConstraints = false
            self.retryBtn.delegate = self
            self.isUserInteractionEnabled = true
            videoView.addSubview(self.retryBtn)
            NSLayoutConstraint.activate([
                self.retryBtn.igCenterXAnchor.constraint(equalTo: videoView.igCenterXAnchor),
                self.retryBtn.igCenterYAnchor.constraint(equalTo: videoView.igCenterYAnchor)
            ])
        }
    }
    func didCompletePlay() {
        //Video completed
    }
    
    func didTrack(progress: Float) {
        //Delegate already handled. If we just print progress, it will print the player current running time
    }
    
}

extension IGStoryPreviewCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if(gestureRecognizer is UISwipeGestureRecognizer) {
            return true
        }
        return false
    }
}

