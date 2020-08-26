//
//  GRAdMobProtocol.swift
//  MyDailyTasks
//
//  Created by Adebayo Ijidakinro on 4/30/20.
//  Copyright © 2020 Ade. All rights reserved.
//

import Foundation
import GoogleMobileAds
import RxSwift
import SwiftyBootstrap

protocol GRAdMobProtocol: UIViewController, GADUnifiedNativeAdLoaderDelegate, GADUnifiedNativeAdDelegate {
    
    var adLoader:GADAdLoader? { get set }
    
    var loaderSubject:PublishSubject<GADUnifiedNativeAd>? { get set }
    
    var canLoadMoreAds:Bool? { get set }
    
}

extension GRAdMobProtocol {
    
    func initializeLoader () {
        
        self.adLoader = GADAdLoader(
            adUnitID: "ca-app-pub-3940256099942544/3986624511",
            rootViewController: self,
            adTypes: [ GADAdLoaderAdType.unifiedNative ],
            options: nil)
        self.adLoader?.delegate = self
        self.canLoadMoreAds = false
    }
    
    func loadRequest () {
        self.adLoader?.load(GADRequest())
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        nativeAd.delegate = self
        self.loaderSubject?.onNext(nativeAd)
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        self.canLoadMoreAds = true
    }
    
}
