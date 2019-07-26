//
//  ViewController.swift
//  MyAlbum
//
//  Created by 황병윤 on 20/05/2019.
//  Copyright © 2019 HBY. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, PHPhotoLibraryChangeObserver {
   
    func GetAlbums() {
        let options: PHFetchOptions = PHFetchOptions()
        let getAlbums : PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: options)
        // 앨범 정보
        print(getAlbums)
        for i in 0 ..< getAlbums.count{
            let assetCollection:PHAssetCollection = getAlbums[i] as! PHAssetCollection
            print(assetCollection.localizedTitle)
            print(assetCollection.estimatedAssetCount)
            // 위 글에서 특정앨범의 정보를 가져오는 fetchAssetsInAssetCollection 을 사용한다
            // PHFetchResult의 타입의 상수에 값을 저장한다
            // PHFetchResult 의 result 값에 count 가 있다
            let assetsFetchResult: PHFetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
            // 출력 시 기존 생성된 앨범들의 사진 및 비디오 수가 나옴
            print("assetsFetchResult.count=\(assetsFetchResult.count)")
        }
    }
  
//    
//    func getThumbnailWithIdentifier(AlbumsResult: PHAssetCollection, groesse: CGSize, completion: @escaping (_ image: UIImage?) -> Void) {
//            
//            // 앨범 타이틀을 이용해 특정 앨범의 사진들을 가져온다
//            let fetchOptions = PHFetchOptions()
//            fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
//            let manager = PHImageManager.default()
//            let assetsFetchResult: PHFetchResult = PHAsset.fetchAssets(in: AlbumsResult, options: fetchOptions)
//            if assetsFetchResult.count > 0 {
//                // 가져온 사진중 마지막 사진을 선택하고
//                if let imageAsset = assetsFetchResult.lastObject as? PHAsset {
//                    // 불러올 사진의 이미지 옵션값을 넣은 다음
//                    let requestOptions = PHImageRequestOptions()
//                    requestOptions.isSynchronous = false
//                    requestOptions.deliveryMode = .highQualityFormat
//                    //requestImageForAsset 을 이용해 이미지를 불러온다
//                    manager.requestImage(for: imageAsset, targetSize: groesse, contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, info) -> Void in
//                        completion(image)
//                    })
//                } else {
//                    completion(nil)
//                }
//            } else {
//                completion(nil)
//            }
//        }
//    }

    
    let options: PHFetchOptions = PHFetchOptions()
    let getAlbums : PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
    
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: fetchResult) else {
            return
        }
        
        fetchResult = changes.fetchResultAfterChanges
        
        OperationQueue.main.addOperation {
        self.collectionView.reloadSections(IndexSet(0...0))
        }
    }
    
    
    
    let cellIdentifier: String = "cell"
    var fetchResult: PHFetchResult<PHAsset>!
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getAlbums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as! PhotoCollectionViewCell
        
        //let asset: PHAsset = fetchResult.object(at: indexPath.item)

     
        
        // 앨범 정보
        
        let assetCollection: PHAssetCollection = getAlbums[indexPath.item]
        let assetsFetchResult: PHFetchResult = PHAsset.fetchAssets(in: assetCollection, options: options)
        
        // 출력 시 기존 생성된 앨범들의 사진 및 비디오 수가 나옴
        
        cell.nameLabel.text = assetCollection.localizedTitle!
        cell.numberLabel.text = String(assetsFetchResult.count)
        cell.photoView.layer.cornerRadius = 15
        cell.photoView.clipsToBounds = true

        if  PHAsset.fetchAssets(in: assetCollection, options: options).count > 0 {
            options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            let imageAsset = assetsFetchResult.lastObject ?? PHAsset.init()
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = false
            requestOptions.deliveryMode = .highQualityFormat
            imageManager.requestImage(for: imageAsset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: requestOptions, resultHandler: { image, _ in cell.photoView?.image = image })
        }
        cell.photoView.image = UIImage.init(named: "Icon-76.png")
        cell.accessibilityValue = String(indexPath.item)
        print(cell.accessibilityValue)
            // 위 글에서 특정앨범의 정보를 가져오는 fetchAssetsInAssetCollection 을 사용한다
            // PHFetchResult의 타입의 상수에 값을 저장한다
            // PHFetchResult 의 result 값에 count 가 있다
        
        
        return cell
    }
    
    func requestCollection() {
        let cameraRoll: PHFetchResult<PHAssetCollection> =  PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        
        let favorites: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
        
        
        guard let cameraRollCollection = cameraRoll.firstObject else {
            return
        }
        
        guard let favoritesCollection = favorites.firstObject else {
            return
        }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.fetchResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions )
        
        self.fetchResult = PHAsset.fetchAssets(in: favoritesCollection, options: fetchOptions)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let photoAurhorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        
        switch photoAurhorizationStatus {
        case .authorized:
            print("접근 허가됨")
            self.requestCollection()
            self.collectionView.reloadData()
        case .denied:
            print("접근 불허")
        case .notDetermined:
            print("아직 응답하지 않음")
            PHPhotoLibrary.requestAuthorization({ (status) in
                switch status {
                case .authorized:
                    print("사용자가 허용함")
                    self.requestCollection()
                    OperationQueue.main.addOperation {
                        self.collectionView.reloadData()
                    }
                    
                case .denied:
                    print("사용자가 불허함")
                default: break
                }
            })
        case .restricted:
            print("접근 제한")
        @unknown default:
            fatalError()
        }
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        guard let albumViewController: AlbumViewController = segue.destination as? AlbumViewController else {
            return
        }
        
        guard let cell: PhotoCollectionViewCell = sender as? PhotoCollectionViewCell else {
            return
        }
        
        guard let index: IndexPath = self.collectionView.indexPath(for: cell) else {
            return
        }
        
        albumViewController.titleToSet = cell.nameLabel.text
        albumViewController.numToSet = Int(cell.numberLabel.text!)!
        albumViewController.itemToSet = Int(cell.accessibilityValue!)!
        
        albumViewController.asset = self.fetchResult[index.item]
        //albumViewController.fetchResult = self.fetchResult
        
    }

}

