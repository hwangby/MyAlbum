//
//  AlbumViewController.swift
//  MyAlbum
//
//  Created by 황병윤 on 21/05/2019.
//  Copyright © 2019 HBY. All rights reserved.
//

import UIKit
import Photos

class AlbumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, PHPhotoLibraryChangeObserver {
   

    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    var titleToSet: String?
    var numToSet: Int?
    var itemToSet: Int?
    var asset: PHAsset!
    
    let options: PHFetchOptions = PHFetchOptions()
    let getAlbums : PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: fetchResult) else {
            return
        }
        
        fetchResult = changes.fetchResultAfterChanges
        
        OperationQueue.main.addOperation {
            self.albumCollectionView.reloadSections(IndexSet(0...0))
        }
    }
    

    
    
    let albumCellIdentifier: String = "albumCell"
    var fetchResult: PHFetchResult<PHAsset>!
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("fetchResult.count \(fetchResult.count)")
        //return fetchResult.count
        return numToSet!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let albumCell: AlbumCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.albumCellIdentifier, for: indexPath) as! AlbumCollectionViewCell
        
        //let asset: PHAsset = fetchResult.object(at: indexPath.item)
        
        
        let assetCollection: PHAssetCollection = getAlbums[indexPath.item]
        let assetsFetchResult: PHFetchResult = PHAsset.fetchAssets(in: assetCollection, options: options)
        //print(numToSet)
        //print(fetchResult.object(at: indexPath.item))
        if numToSet! > 0 {
        imageManager.requestImage(for: fetchResult.object(at: indexPath.item), targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in albumCell.albumView?.image = image })
        }
        
    
        
        return albumCell
    }
    
    func requestCollection() {
        let cameraRoll: PHFetchResult<PHAssetCollection> =  PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)


        guard let cameraRollCollection = cameraRoll.firstObject else {
            return
        }

        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        self.fetchResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = titleToSet
        
        print(getAlbums[itemToSet!])

        // Do any additional setup after loading the view.
        
        var album: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        switch itemToSet! {
        case 0:
            album = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
        case 1:
            album = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumPanoramas, options: nil)
        case 2:
            album = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        case 3:
            album = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumSlomoVideos, options: nil)
        case 4:
            album = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumScreenshots, options: nil)
        case 5:
            album = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumBursts, options: nil)
        case 6:
            album = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumVideos, options: nil)
        case 7:
            album = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumSelfPortraits, options: nil)
        case 8:
            album = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumAllHidden, options: nil)
        case 9:
            album = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumTimelapses, options: nil)
        case 10:
            album = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumRecentlyAdded, options: nil)
        case 11:
            album = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumAnimated, options: nil)
        case 12:
            album = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumLongExposures, options: nil)
        case 13:
            album = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumGeneric, options: nil)
        case 14:
            album = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumLivePhotos, options: nil)
        default:
            album = PHFetchResult.init()
        }
        
        
        guard let albumCollection = album.firstObject else {
            return
        }
        
        let albumFetchOptions = PHFetchOptions()
        albumFetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.fetchResult = PHAsset.fetchAssets(in: albumCollection, options: albumFetchOptions)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
