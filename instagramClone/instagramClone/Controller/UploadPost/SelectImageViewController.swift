//
//  SelectImageViewController.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/21.
//

import UIKit
import Photos

class SelectImageViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var images = [UIImage]()
    var assets = [PHAsset]()
    var selectedImage: UIImage?
    var header: SelectPhotoHeader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cell classes
        collectionView.register(SelectPhotoCell.self)
        collectionView.register(SelectPhotoHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SelectPhotoHeader.defaultReuseIdentifier)
        
        // configure nav buttons
        configureNavigationButton()
        
        // fetch photos
        fetchPhotos()
    }
    
    // MARK: - UICollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // MARK: - UICollectionView DataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SelectPhotoCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        
            cell.photoImageView.image = images[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedImage = images[indexPath.row]
        
        collectionView.reloadData()
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SelectPhotoHeader.defaultReuseIdentifier, for: indexPath) as? SelectPhotoHeader else { return UICollectionReusableView()}
        
        self.header = header
        
        // 높은 품질의 이미지 얻어오는 방법
        if let selectedImage = selectedImage {
           
            // index selected image
            if let index = images.firstIndex(of: selectedImage) {
                
                // asset associated with selected image
                let selectedAsset = self.assets[index]
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                
                // request image
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil) { image, info in
                    
                    header.photoImageView.image = image
                    
                }
            }
            
        }
        return header
    }
    
    // MARK: - Handlers
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNext() {
        let uploadPostVC = UploadPostViewController()
        uploadPostVC.selectedImage = header?.photoImageView.image
        navigationController?.pushViewController(uploadPostVC, animated: true)
    }
    
    func configureNavigationButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }
    
    func getAssetFetchOptions() -> PHFetchOptions {
        let options = PHFetchOptions()
        
        // fetch limit
        options.fetchLimit = 30
        
        // sort photos by date
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        
        // set sort descriptor for options
        options.sortDescriptors = [sortDescriptor]
        
        return options
        
    }
    
    func fetchPhotos() {
        
        let allPhotos = PHAsset.fetchAssets(with: .image, options: getAssetFetchOptions())
        
        // fetch images on default thread
        DispatchQueue.global().async {
            
            // enumerate objects -> 객체와 인덱스를 함께,
            allPhotos.enumerateObjects { asset, count, stop in
              
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                // 이미지 데이터가 준비되거나 오류가 발생할 때까지 호출 스레드를 차단
                options.isSynchronous = true
                
                // request image representation for specified asset
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { image, info in
                    if let image = image {
                        
                        // append image to data source
                        self.images.append(image)
                        
                        // append asset to data source
                        self.assets.append(asset)
                        
                        // set selected image with first image
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                        
                        // reload collection view with images once count has completed -> 패치가 끝났는지 확인하는 것
                        if count == allPhotos.count - 1 {
                            
                            // reload collection view on main thread
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
}
