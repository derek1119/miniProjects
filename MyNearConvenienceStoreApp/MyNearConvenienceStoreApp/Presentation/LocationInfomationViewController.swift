//
//  LocationInfomationViewController.swift
//  MyNearConvenienceStoreApp
//
//  Created by Sh Hong on 2022/02/05.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa
import SnapKit

class LocationInfomationViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let locationManager = CLLocationManager()
    let mapView = MTMapView()
    let currentLocationButton = UIButton()
    let detailList = UITableView()
    let detailListBackgroundView = DetailListBackgroundView()
    let viewModel = LocationInfomationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        
        bind(viewModel)
        attribute()
        layout()
    }
    
    private func bind(_ viewModel: LocationInfomationViewModel) {
        detailListBackgroundView.bind(viewModel.detailListBackgroundViewModel)
        
        viewModel.setMapCenter
            .emit(to: mapView.rx.setMapCenterPoint)
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .emit(to: self.rx.presentAlert)
            .disposed(by: disposeBag)
        
        viewModel.detailListCellData
            .drive(detailList.rx.items) { tableView, row, data in
                let cell = tableView.dequeueReusableCell(withIdentifier: "DetailListCell", for: IndexPath(row: row, section: 0)) as! DetailListCell
                cell.setData(data)
                
                return cell
            }
            .disposed(by: disposeBag)
        
        viewModel.detailListCellData
            .map { $0.compactMap { $0.point } }
            .drive(self.rx.addPOIItems)
            .disposed(by: disposeBag)
        
        viewModel.scrollToSelectedLocation
            .emit(to: self.rx.showSelectedLocation)
            .disposed(by: disposeBag)
        
        detailList.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.detailListItemSelected)
            .disposed(by: disposeBag)
        
        currentLocationButton.rx.tap
            .bind(to: viewModel.currentLocationButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        title = "내 주변 편의점 찾기"
        view.backgroundColor = .white
        
        mapView.currentLocationTrackingMode = .onWithoutHeadingWithoutMapMoving
        
        currentLocationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        currentLocationButton.backgroundColor = .white
        currentLocationButton.layer.cornerRadius = 20
        
        detailList.register(DetailListCell.self, forCellReuseIdentifier: "DetailListCell")
        detailList.separatorStyle = .none
        detailList.backgroundView = detailListBackgroundView
    }
    
    private func layout() {
        [mapView, currentLocationButton, detailList]
            .forEach { view.addSubview($0) }
        
        mapView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.snp.centerY).offset(100)
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.bottom.equalTo(detailList.snp.top).offset(-12)
            make.leading.trailing.equalToSuperview().offset(12)
            make.width.height.equalTo(40)
        }
        
        detailList.snp.makeConstraints { make in
            make.centerX.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.top.equalTo(mapView.snp.bottom)
        }
    }
}

extension LocationInfomationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined,
            .authorizedAlways,
            .authorizedWhenInUse,
            .authorized :
            return
        default:
            viewModel.mapViewError.accept(MTMapViewError.locationAuthorizationDenied.localizedDescription)
            return
        }
    }
    
}

extension LocationInfomationViewController: MTMapViewDelegate {
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        #if DEBUG
        viewModel.currentLocation.accept(MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.394225, longitude: 127.110341)))
        #else
         viewModel.currentLocation.accept(location)
        #endif
    }
    
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
        viewModel.mapCenterPoint.accept(mapCenterPoint)
    }
    
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
         viewModel.selectPOIItem.accept(poiItem)
        return false
    }
    
    func mapView(_ mapView: MTMapView!, failedUpdatingCurrentLocationWithError error: Error!) {
         viewModel.mapViewError.accept(error.localizedDescription)
    }
}

extension Reactive where Base: MTMapView {
    var setMapCenterPoint: Binder<MTMapPoint> {
        return Binder(base) { base, point in
            base.setMapCenter(point, animated: true)
        }
    }
}

extension Reactive where Base: LocationInfomationViewController {
    var presentAlert: Binder<String> {
        return Binder(base) { base, message in
            let alertController = UIAlertController(title: "문제가 발생했어요.", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            
            alertController.addAction(action)
            
            base.present(alertController, animated: true, completion: nil)
        }
    }
    
    var showSelectedLocation: Binder<Int> {
        return Binder(base) { base, row in
            let indexPath = IndexPath(row: row, section: 0)
            base.detailList.selectRow(at: indexPath, animated: true, scrollPosition: .top)
        }
    }
    
    var addPOIItems: Binder<[MTMapPoint]> {
        return Binder(base) { base, points in
            let items = points
                .enumerated()
                .map { offset, point -> MTMapPOIItem in
                    let mapPOIItem = MTMapPOIItem()
                    
                    mapPOIItem.mapPoint = point
                    mapPOIItem.markerType = .redPin
                    mapPOIItem.showAnimationType = .springFromGround
                    mapPOIItem.tag = offset
                    
                    return mapPOIItem
                }
            base.mapView.removeAllPOIItems()
            base.mapView.addPOIItems(items)
        }
    }
}
