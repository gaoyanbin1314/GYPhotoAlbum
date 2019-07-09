//
//  FZAlbumDetailController.swift
//  FZAlbum
//
//  Created by 王欣 on 2019/1/10.
//  Copyright © 2019年 李雷川. All rights reserved.
//

import UIKit
import Photos

/// FZAlbumDetailControllerDelegate
protocol FZAlbumDetailControllerDelegate: NSObjectProtocol {
    // 获取图片的数量
    func epAlbumDetailGetPhotoCount() -> Int
    // 获取当前的model
    func epAlbumDetailGetPhotoByCurrentIndex(_ currentIndex: Int) -> FZAlbumModel
    // 获取model对应的index
    func epAlbumDetailGetModelIndex(_ model: FZAlbumModel) -> Int
    // 点击选中按钮的处理事件
    func epAlbumDetailSelectedBtnEvent(_ assetModel:FZAlbumModel?)
    // 点击完成按钮的事件
    func epAlbumDetailDoneEvent(_ button :UIButton)
    // Preview
    func epAlbumDatailGetPreviewArray() -> [FZAlbumModel]
    // 移动停止的回调
    func epAlbumDetailDragEnd(_ finalPhotosRank :[FZAlbumModel])
    
}

class FZAlbumDetailController: UIViewController {
    
    weak var delegate: FZAlbumDetailControllerDelegate?
    fileprivate var currentIndex: Int = 0 // 当前row
    var previewArray = [FZAlbumModel]()
    
    var isEdite = false
    var dragIndexPath: IndexPath?
    var targetIndexPath: IndexPath?
    var preViewSelectedCell :FZAlbumPreviewCell?
    var preViewSelectedNumber :Int?
    
    lazy var doneBtn :UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexString: "#B4272D")
        button.setTitle("下一步", for: UIControl.State.normal)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(nextEvent), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    @objc func nextEvent(_ button :UIButton){
        delegate?.epAlbumDetailDoneEvent(button)
    }
    
    lazy var previewCollectionView:UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize.init(width: 86, height: 86)
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        collectionView.register(FZAlbumPreviewCell.self, forCellWithReuseIdentifier: "previewCell")
        collectionView.backgroundColor = UIColor(hexString: "#000000", alpha: 0.8)
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:)))
        collectionView.addGestureRecognizer(longPress)
        return collectionView
    }()
    
    private lazy var dragingItem: FZAlbumPreviewCell = {
        
        let cell = FZAlbumPreviewCell(frame: CGRect(x: 0, y: 0, width: 86, height: 86))
        cell.isHidden = true
        previewCollectionView.addSubview(cell)
        return cell
    }()
    
    lazy var photoCollectionView:UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        collectionView.register(FZAlbumDetailCell.self, forCellWithReuseIdentifier: "detailCell")
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    lazy var lineView :UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor(hexString: "#E8E8E8", alpha: 0.8)
        view.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.5)
        bottomView.addSubview(view)
        return view
    }()
    
    lazy var bottomView :UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.gray
        view.backgroundColor = UIColor(hexString: "#000000", alpha: 0.8)
        return view
    }()
    
    lazy var goBackBtn :UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage.init(named: FZAlbum.fzImageNamed(imageName: "arrow_left")), for: UIControl.State.normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(goBackEvent), for: UIControl.Event.touchUpInside)
        return button
    }()
    @objc func goBackEvent(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    lazy var selectedBtn :UIButton = {
        let button = UIButton()
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(selectBtn), for: UIControl.Event.touchUpInside)
        button.setBackgroundImage(UIImage.init(named: FZAlbum.fzImageNamed(imageName: "unselected")), for: UIControl.State.normal)
        button.backgroundColor = UIColor.green
        return button
    }()
    
    // 点击选中按钮
    @objc func selectBtn(sender :UIButton) {
        
        let model = getDataByCurrentIndex(currentIndex)
        delegate?.epAlbumDetailSelectedBtnEvent(model)
        self.previewArray = (delegate?.epAlbumDatailGetPreviewArray())!
        self.previewCollectionView.reloadData()
        showPhotoTagBtn()
    }
    
    deinit {
        delegate = nil
    }
    
    
    /// 初始化
    /// - Parameters:
    ///   - index: 当前页
    ///   - delegate: 代理
    convenience init(_ index: Int,_ delegate: FZAlbumDetailControllerDelegate) {
        self.init()
        currentIndex = index
        self.delegate = delegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.selectedBtn)
//        self.navigationItem.rightBarButtonItem?.width = 26
        print("item")
        print(self.navigationItem.rightBarButtonItem)
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(customView: self.goBackBtn)
        
        view.backgroundColor = UIColor.black
        view.addSubview(photoCollectionView)
        view.addSubview(previewCollectionView)
        view.addSubview(bottomView)
        bottomView.addSubview(doneBtn)
        
        self.photoCollectionView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview()
            }
        }
        self.bottomView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
                make.height.equalTo(44)
            } else {
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(44)
            }
        }
        self.doneBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-6)
            make.centerY.equalToSuperview()
            make.width.equalTo(64)
            make.height.equalTo(24)
        }
        self.previewCollectionView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.left.right.equalTo(self.view.safeAreaLayoutGuide)
                make.bottom.equalTo(self.bottomView.snp.top)
                make.height.equalTo(100)
            } else {
                make.left.right.equalToSuperview()
                make.bottom.equalTo(self.bottomView.snp.top)
                make.height.equalTo(100)
            }
            
        }
        view.layoutIfNeeded()
        photoCollectionView.scrollToItem(at: IndexPath.init(row: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
        showPhotoTagBtn()

    }
    
    // preview的选中状态
    func showPreviewCollectionCellSelectedStatus() {
        
        let currentModel = getDataByCurrentIndex(currentIndex)
        
        if let row = self.previewArray.index(where: { $0 === currentModel }) {
            
            let item = previewCollectionView.cellForItem(at: IndexPath.init(item: row, section: 0)) as? FZAlbumPreviewCell
            if item == nil {
                preViewSelectedNumber = row
            }
            if (preViewSelectedCell != nil && item != preViewSelectedCell) {
                preViewSelectedCell?.backgroundColor = UIColor.clear
            }
            item?.backgroundColor = UIColor.green
            preViewSelectedCell = item
        } else{
            if (preViewSelectedCell != nil) {
                preViewSelectedCell?.backgroundColor = UIColor.clear
            }
        }
    }
    
    /// 处理选择按钮显内容
    func showPhotoTagBtn() {
        
        showPreviewCollectionCellSelectedStatus()
        let currentModel = getDataByCurrentIndex(currentIndex)
        self.navigationItem.rightBarButtonItem?.width = 26
        if currentModel?.isSelected == true {
            selectedBtn.backgroundColor = UIColor(hexString: "#B4272D")
            selectedBtn.setTitle(String(currentModel?.selectedSerialNumber ?? 0), for: UIControl.State.normal)
            selectedBtn.setBackgroundImage(UIImage.init(named: FZAlbum.fzImageNamed(imageName: "")), for: UIControl.State.normal)
        }else {
            selectedBtn.backgroundColor = UIColor.clear
            selectedBtn.setTitle("", for: UIControl.State.normal)
            selectedBtn.setBackgroundImage(UIImage.init(named: FZAlbum.fzImageNamed(imageName: "unselected")), for: UIControl.State.normal)
        }
    }
    
    // 获取图片数量
    func getPhotosCount() -> Int? {
        
        return delegate?.epAlbumDetailGetPhotoCount()
    }
    
    // 获取数据源
    func getDataByCurrentIndex(_ index :Int) -> FZAlbumModel? {
        
        return delegate?.epAlbumDetailGetPhotoByCurrentIndex(index)
    }
    
    
// mark 点击拖动效果
    //MARK: - 长按动作
    @objc func longPressGesture(_ tap: UILongPressGestureRecognizer) {
        
        let point = tap.location(in: previewCollectionView)
        
        switch tap.state {
        case UIGestureRecognizer.State.began:
            dragBegan(point: point)
        case UIGestureRecognizer.State.changed:
            drageChanged(point: point)
        case UIGestureRecognizer.State.ended:
            drageEnded(point: point)
        case UIGestureRecognizer.State.cancelled:
            drageEnded(point: point)
        default: break
            
        }
        
    }
    
    //MARK: - 长按开始
    private func dragBegan(point: CGPoint) {
        
        dragIndexPath = previewCollectionView.indexPathForItem(at: point)
        if dragIndexPath == nil
        {return}
        
        let item = previewCollectionView.cellForItem(at: dragIndexPath!) as? FZAlbumPreviewCell
        item?.isHidden = true
        dragingItem.isHidden = false
        dragingItem.frame = (item?.frame)!
        dragingItem.photoImageView.image = item?.photoImageView.image
        dragingItem.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    }
    //MARK: - 长按过程
    private func drageChanged(point: CGPoint) {
        if dragIndexPath == nil {return}
        dragingItem.center = point
        targetIndexPath = previewCollectionView.indexPathForItem(at: point)
        if targetIndexPath == nil || (targetIndexPath?.section)! > 0 || dragIndexPath == targetIndexPath {return}
        // 更新数据
        let obj = previewArray[dragIndexPath!.item]
        previewArray.remove(at: dragIndexPath!.row)
        previewArray.insert(obj, at: targetIndexPath!.item)
        //交换位置
        previewCollectionView.moveItem(at: dragIndexPath!, to: targetIndexPath!)
        dragIndexPath = targetIndexPath
    }
    
    //MARK: - 长按结束
    private func drageEnded(point: CGPoint) {
        
        if dragIndexPath == nil {return}
        let endCell = previewCollectionView.cellForItem(at: dragIndexPath!)
        
        for (i,item) in previewArray.enumerated(){
            item.selectedSerialNumber = i + 1
        }
        
        delegate?.epAlbumDetailDragEnd(previewArray)
        showPhotoTagBtn()
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.dragingItem.transform = CGAffineTransform.identity
            self.dragingItem.center = (endCell?.center)!
            
        }, completion: {
            
            (finish) -> () in
            
            endCell?.isHidden = false
            self.dragingItem.isHidden = true
            self.dragIndexPath = nil
            
        })
    }
}

// MARK: - UICollectionViewDelegate,UICollectionViewDataSource
extension FZAlbumDetailController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.previewCollectionView{
            
            self.previewCollectionView.isHidden = previewArray.count > 0 ? false: true
            self.lineView.isHidden = previewArray.count > 0 ? false: true
            self.doneBtn.alpha = previewArray.count > 0 ? 1.0 : 0.6
            self.doneBtn.isUserInteractionEnabled = previewArray.count > 0
            return previewArray.count
        }
        return getPhotosCount() ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if collectionView == self.photoCollectionView {
            if cell.isKind(of: FZAlbumDetailCell.self){
                let currentCell :FZAlbumDetailCell = cell as! FZAlbumDetailCell
                currentCell.bottomScrollView.setZoomScale(1.0, animated: false)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.photoCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCell", for: indexPath) as! FZAlbumDetailCell
            
            let detailModel = getDataByCurrentIndex(indexPath.row)
            let options = PHImageRequestOptions()
            options.resizeMode = PHImageRequestOptionsResizeMode.none
            options.isSynchronous = true
            options.isNetworkAccessAllowed = true
            PHImageManager.default().requestImageData(for: (detailModel?.asset)!, options: options, resultHandler: {
                (imageData:Data?, dataUTI:String?, orientation:UIImage.Orientation,
                info:[AnyHashable : Any]?) in
                cell.photoImageView.image = UIImage.init(data: imageData!)
                cell.photoImageView.contentMode = .scaleAspectFit
            })
            return cell
        }
        
        if collectionView == self.previewCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "previewCell", for: indexPath) as! FZAlbumPreviewCell
            
            let previewModel = previewArray[indexPath.row]
            cell.photoImageView.image = previewModel.thumbnailImage
            if preViewSelectedNumber == indexPath.row{
                cell.backgroundColor = UIColor.green
                preViewSelectedNumber = nil
                preViewSelectedCell = cell
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.photoCollectionView {
            if let selectIndexPath = self.photoCollectionView.indexPathsForVisibleItems.first {
                currentIndex = selectIndexPath.row
            }
            showPhotoTagBtn()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.previewCollectionView {
            let model = previewArray[indexPath.item]
            let row = delegate?.epAlbumDetailGetModelIndex(model)
            currentIndex = row ?? 0
            photoCollectionView.scrollToItem(at: IndexPath.init(row: row ?? 0, section: 0), at: .centeredHorizontally, animated: false)
            
            let item = previewCollectionView.cellForItem(at: indexPath) as? FZAlbumPreviewCell
            
            if (preViewSelectedCell != nil && item != preViewSelectedCell) {
                preViewSelectedCell?.backgroundColor = UIColor.clear
            }
            item?.backgroundColor = UIColor.green
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.previewCollectionView{
            return CGSize.init(width: 86, height: 86)
        }
        if #available(iOS 11.0, *) {
            
            return CGSize.init(width: self.view.safeAreaLayoutGuide.layoutFrame.size.width, height: self.view.safeAreaLayoutGuide.layoutFrame.size.height)
        }
        return CGSize.init(width: view.frame.width, height: view.frame.height - 44 - 22)
    }
}
