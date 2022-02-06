//
//  LocalNetworkStub.swift
//  MyNearConvenienceStoreAppTests
//
//  Created by Sh Hong on 2022/02/06.
//

import Foundation
import RxSwift
import Stubber

@testable import MyNearConvenienceStoreApp

class LocalNetworkStub: LocalNetwork {
    override func getLocation(by mapPoint: MTMapPoint) -> Single<Result<LocationData, URLError>> {
        return Stubber.invoke(getLocation, args: mapPoint)
    }
}
