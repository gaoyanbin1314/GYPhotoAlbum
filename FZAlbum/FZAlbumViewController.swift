//
//  FZAlumbViewController.swift
//  FZAlbum
//
//  Created by 李雷川 on 2018/12/26.
//  Copyright © 2018年 李雷川. All rights reserved.
//

import UIKit
import Photos

public protocol FZAlbumViewControllerDelegate: NSObjectProtocol {
    
    func dismissEvent()
    func didFinishedSelect(_ selectPhotos :[FZAlbumModel])
}

class FZAlbumBottomView: UIView {
    
    typealias GetHitTestEvent = () -> Void
    
    var getHitTestEvent :GetHitTestEvent?
    
    class func setIsHiddenTipImageView(value:Bool){
        UserDefaults.standard.set(value, forKey: "isShowTipImageView")
        // 同步
        UserDefaults.standard.synchronize()
    }
    
    class func getIsHiddenTipImageView()->Bool{
        
        if (UserDefaults.standard.value(forKey: "isShowTipImageView") != nil) {
            return (UserDefaults.standard.value(forKey: "isShowTipImageView") != nil)
        }
        
        return false
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if !FZAlbumBottomView.getIsHiddenTipImageView() {
            FZAlbumBottomView.setIsHiddenTipImageView(value: true)
            getHitTestEvent?()
        }
        
       return super.hitTest(point, with: event)
    }
}

class FZAlbumViewController: UIViewController{

    weak var delegate :FZAlbumViewControllerDelegate?
    
    /// 默认缩略图大小
    let thumbnailSize = CGSize.init(width: 150, height: 150)
    var tipIsSelected :Bool = false
    // 指定相册
    var assetCollection: PHAssetCollection?
    // 展示模块的资源
    var modulesData = [PHAssetCollection]()
    // 展示照片的资源
    var photos = [FZAlbumModel]()
    // 已经选择的资源
    var selectPhotos = [FZAlbumModel]()
    var canSelectPhoto :Bool = true
    var maxImagesCount:Int = 0   // 最大可选数量
    
    lazy var bottomView :FZAlbumBottomView = {
        
        let view = FZAlbumBottomView.init(frame: CGRect.zero)
        view.getHitTestEvent = { [weak self] in
                self?.tipImageView.isHidden = true
        }
        return view
    }()
    
    lazy var tipImageView :UIImageView = {
        
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: FZAlbum.fzImageNamed(imageName: "tip"))
        return imageView
    }()
    
    lazy var tableView :UITableView = {
        let tableview = UITableView()
        tableview.isHidden = true
        tableview.backgroundColor = UIColor.white
        tableview.separatorColor = UIColor(hexString: "#E8E8E8")
        let footerView = UIView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 10))
        tableview.tableFooterView = footerView
        tableview.register(FZAlbumModulesCell.self, forCellReuseIdentifier: "tableViewCell")
        tableview.delegate = self
        tableview.dataSource = self
        return tableview
    }()
    
    lazy var leftBtn :UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage.init(named: FZAlbum.fzImageNamed(imageName: "arrow_left")), for: UIControl.State.normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(goBackEvent), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    @objc func goBackEvent(){
        
        let imagePicker = navigationController as! FZAlbum
        self.dismiss(animated: imagePicker.dismissAnimate) {
            self.delegate?.dismissEvent()
        }
    }
    
    lazy var titleBtn :UIButton = {
        
        let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: (UIScreen.main.bounds.size.width), height: 44))
        button.setTitle("相册", for: UIControl.State.normal)
        button.setTitleColor(UIColor(hexString: "#333333"), for: UIControl.State.normal)
        button.setImage(UIImage.init(named: FZAlbum.fzImageNamed(imageName: "xia")), for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(chooseModulesEvent), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    @objc func chooseModulesEvent(){
        
        self.tableView.isHidden = !self.tableView.isHidden
        rotationTitleBtnImage()
    }
    
    func rotationTitleBtnImage() {
        
        tipIsSelected = !tipIsSelected
        UIView.animate(withDuration: 0.25) {
            if self.tipIsSelected {
                self.titleBtn.imageView?.transform = CGAffineTransform(rotationAngle: .pi)
            } else {
                self.titleBtn.imageView?.transform = CGAffineTransform(rotationAngle: 0)
            }
        }
    }
    
    
    func setIconInRight() {
        
        let img_W :CGFloat = titleBtn.imageView?.frame.size.width ?? 10
        let tit_W :CGFloat = titleBtn.titleLabel?.frame.size.width ?? 64
        let Spacing :CGFloat = 5
        titleBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(img_W + Spacing / 2) + 20, bottom: 0, right: (img_W + Spacing / 2) - 20)
        titleBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: (tit_W + Spacing / 2) + 20, bottom: 0, right:  -(tit_W + Spacing / 2) - 20)
    }
    
    
    lazy var nextBtn :UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 64, height: 24))
        button.backgroundColor = UIColor(hexString: "#B4272D")
        button.setTitle("下一步", for: UIControl.State.normal)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(nextBtnEvent), for: UIControl.Event.touchUpInside)
        button.alpha = 0.6
        button.isUserInteractionEnabled = false
        return button
    }()
    
    @objc func nextBtnEvent(sender :UIButton) {
        
        let imagePicker = navigationController as! FZAlbum
        self.dismiss(animated: imagePicker.dismissAnimate) {
            self.delegate?.didFinishedSelect(self.selectPhotos)
        }
    }
    
    
    
    
    var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        
        let window = UIApplication.shared.keyWindow
        
        let w = window?.frame.width ?? UIScreen.main.bounds.width
        let h = window?.frame.height ?? UIScreen.main.bounds.height
        
        var count :Int = 4
        if UIDevice.current.model == "iPad" {
            count = 6
        }
        let size = w > h ? h : w
        let wh = (size - 5.0 * CGFloat(count)) / CGFloat(count)
        layout.itemSize = CGSize.init(width: wh, height: wh)
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionView.register(FZAlbumPhotoCell.self, forCellWithReuseIdentifier: "collectionViewCell")
        return collectionView
    }()
    
    
    ///
    /// - Parameters:初始化方法
    convenience init(maxImagesCount: Int ,delegate: FZAlbumViewControllerDelegate?) {
        
        self.init()
        self.maxImagesCount = maxImagesCount > 0 ? maxImagesCount : 9 // 默认最大可选9张
        self.delegate = delegate
        // 检查是否有权限
        let result = FZAlbum.checkPhotoAuth(checkPhotoAuthBlock: { (result:Bool) in
            
            DispatchQueue.main.async {
                if result {
                    //// 加载数据  默认加载全
                    
                    self.configUI()
                    self.loadModulesData()
                    self.loadPhotosData()
                } else{
                    UIAlertView.init(title: nil, message: "打开相册权限才可以获取相册", delegate: nil, cancelButtonTitle: "确定").show()
                }
            }
        })
        
        if result {
            //// 加载数据  默认加载全部
            configUI()
            self.loadModulesData()
            self.loadPhotosData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setNavigationBar()
    }
    // 设置导航栏
    func setNavigationBar() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.nextBtn)
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(customView: self.leftBtn)
        self.navigationItem.titleView = self.titleBtn
        setIconInRight()
    }
    
    // 设置UI
    func configUI() {
        
        view.addSubview(self.bottomView)
        bottomView.addSubview(self.collectionView)
        bottomView.addSubview(self.tableView)
        bottomView.addSubview(self.tipImageView)
        
        self.bottomView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide)
            } else {
                make.top.equalTo(kStatusBarHeight + kNavBarHeight)
                make.height.equalToSuperview().offset(kStatusBarHeight == 44 ? -34 :0)
                make.leading.trailing.equalToSuperview()
            }
        }
        
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.right.bottom.equalTo(0)
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(85 * 2)
        }
        
        self.tipImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-10)
            make.left.equalTo(view.snp.centerX)
            make.width.equalTo(80)
            make.height.equalTo(35)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tipImageView.isHidden = FZAlbumBottomView.getIsHiddenTipImageView()
    }
    
    // 获取相册模块数据
    func loadModulesData() {
        
        modulesData.removeAll()
        FZAlbum.getModulesData { [weak self] (dataArray) in
            
            for item in dataArray{
                self?.modulesData.append(item)
            }
            
            DispatchQueue.main.async {
                var rect = self!.tableView.frame
                rect.size.height = CGFloat(self!.modulesData.count < 4 ? self!.modulesData.count * 85 :4 * 85 )
                self!.tableView.frame = rect
                self?.tableView.reloadData()
            }
        }
    }
    
    // 获取模块内的所有照片
    func loadPhotosData() {
        
        // 没有指定模块 默认查询所有照片模块
        if self.assetCollection == nil {
            
            let smartAssetCollections = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
            smartAssetCollections.enumerateObjects({ (assetCollection, _, _) in
                
                if assetCollection.assetCollectionSubtype == PHAssetCollectionSubtype.smartAlbumUserLibrary {
                    
                    self.assetCollection = assetCollection
                    return
                }
            })
        }
        
        if let assetCollection = self.assetCollection {
            
            self.photos.removeAll()
            FZAlbum.getPhotosData(assetCollection: assetCollection,
                                  getPhotoDataBlock: { [weak self](data) in
                
                for element :FZAlbumModel in data {
                    self?.photos.append(element)
                }
                DispatchQueue.main.async {
                    self?.titleBtn.setTitle(self?.assetCollection?.localizedTitle, for: UIControl.State.normal)
                    self?.setIconInRight()
                    self?.collectionView.reloadData()
//                    let indexPath :IndexPath = IndexPath.init(item: self?.photos.count ?? 1 - 1, section: 0)
//                    self?.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
                }
            })
        }
    }
    
}
// MARK: - UITableViewDelegate UITableViewDataSource
extension FZAlbumViewController :UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modulesData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as? FZAlbumModulesCell
        
        let assetCollection = modulesData[indexPath.row]
        let assets = PHAsset.fetchAssets(in: assetCollection, options: nil)
        
        cell?.nameLabel.text = assetCollection.localizedTitle
        cell?.numberLabel.text = "(\(String(assets.count)))"
        cell?.selectionStyle = .none
        if let asset = assets.lastObject {
            
            let options = PHImageRequestOptions()
            options.resizeMode = PHImageRequestOptionsResizeMode.fast
            options.isSynchronous = true
            
            PHImageManager.default().requestImage(for: asset, targetSize: thumbnailSize, contentMode: PHImageContentMode.aspectFill, options: options) { (image:UIImage?, _) in
                cell?.leftImageView.image = image
            }
        }
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.assetCollection = modulesData[indexPath.row]
        self.tableView.isHidden = true
        self.rotationTitleBtnImage()
        canSelectPhoto = true
        selectPhotos.removeAll()
        loadPhotosData()
    }
}




extension FZAlbumViewController :UICollectionViewDelegate{
    
    
}

// MARK: - UICollectionViewDataSource
extension FZAlbumViewController :UICollectionViewDataSource{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! FZAlbumPhotoCell
        
        cell.delegate = self
        cell.isSelected = false
        
        let assetModel = photos[indexPath.row]
        
        if assetModel.thumbnailImage == nil {
            
            let options = PHImageRequestOptions()
            options.resizeMode = PHImageRequestOptionsResizeMode.fast
            options.isSynchronous = true
            
            PHImageManager.default().requestImage(for: assetModel.asset, targetSize: thumbnailSize, contentMode: PHImageContentMode.aspectFill, options: options, resultHandler: { (image:UIImage?, _) in
                
                assetModel.thumbnailImage = image
            })
        }
        
        cell.updateAssetModel(assetModel, isOneChoose: false)
        cell.updateMaskView(canSelectPhoto,assetModel)
        return cell
    }
}

// MARK: - FZAlumbPhotoCellDelegate
extension FZAlbumViewController :FZAlumbPhotoCellDelegate {
    
    func epPhotoTagBtnHandle(_ assetModel: FZAlbumModel) {
        
        if assetModel.isSelected == false {
            
            if selectPhotos.count >= self.maxImagesCount {
                UIAlertView.init(title: nil, message: "您最多能选择\(self.maxImagesCount)张照片", delegate: nil, cancelButtonTitle: "我知道了").show()
                return
            }
            
            assetModel.isSelected = true
            selectPhotos.append(assetModel)
            
            assetModel.selectedSerialNumber = selectPhotos.count
            if selectPhotos.count >= self.maxImagesCount {
                canSelectPhoto = false
                collectionView.reloadData()
            } else{
                canSelectPhoto = true
                if let row = photos.index(where: { $0 === assetModel }) {
                    collectionView.reloadItems(at: [IndexPath.init(row: row, section: 0)])
                }
            }
        }else {
            
            assetModel.isSelected = false
            canSelectPhoto = true
            let reloadAll = selectPhotos.count >= self.maxImagesCount ? true :false
            var indexPaths = [IndexPath]()

            if let row = photos.index(where: { $0 === assetModel }) {
                indexPaths.append(IndexPath.init(row: row, section: 0))
            }
            
            if let index = selectPhotos.index(where: { $0 === assetModel }) {
                selectPhotos.remove(at: index)
            }
            
            if selectPhotos.count > 0 {
                for index in 0...(selectPhotos.count - 1) {
                    let asset = selectPhotos[index]
                    if asset.selectedSerialNumber != index + 1 {
                        asset.selectedSerialNumber = index + 1
                        if let row = photos.index(where: { $0 === asset }) {
                            indexPaths.append(IndexPath.init(row: row, section: 0))
                        }
                    }
                }
            }
            if reloadAll {
                collectionView.reloadData()
            } else{
                collectionView.reloadItems(at: indexPaths)
            }
        }

        self.nextBtn.alpha = selectPhotos.count > 0 ? 1.0 : 0.6
        self.nextBtn.isUserInteractionEnabled = selectPhotos.count > 0
    }
    
    func epImageViewHandle(_ assetModel: FZAlbumModel) {
        
        if let row = photos.index(where: { $0 === assetModel }) {
            let detailVC = FZAlbumDetailController.init(row, self)
            detailVC.previewArray = selectPhotos
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// mark FZAlbumDetailControllerDelegate
extension FZAlbumViewController :FZAlbumDetailControllerDelegate{
    func epAlbumDetailGetModelIndex(_ model: FZAlbumModel) -> Int {
        
        if let row = photos.index(where: { $0 === model }) {
            return row
        }
        return 0
    }
    
    func epAlbumDetailDragEnd(_ finalPhotosRank: [FZAlbumModel]) {
        selectPhotos = finalPhotosRank
        for item in selectPhotos {
            
            if let row = photos.index(where: { $0 === item }) {

                let model = photos[row]
                model.selectedSerialNumber = item.selectedSerialNumber
            }
        }
        self.collectionView.reloadData()
        
    }
    
    func epAlbumDatailGetPreviewArray() -> [FZAlbumModel] {
        return selectPhotos
    }
    
    func epAlbumDetailDoneEvent(_ button: UIButton) {
        nextBtnEvent(sender: button)
    }
    
   
    func epAlbumDetailGetPhotoCount() -> Int {
        return photos.count
    }
    
    func epAlbumDetailGetPhotoByCurrentIndex(_ currentIndex: Int) -> FZAlbumModel {
        
        return photos[currentIndex]
    }
    
    func epAlbumDetailSelectedBtnEvent(_ assetModel: FZAlbumModel?) {
        
        if let assetModel = assetModel {
            epPhotoTagBtnHandle(assetModel)
        }
    }
}

