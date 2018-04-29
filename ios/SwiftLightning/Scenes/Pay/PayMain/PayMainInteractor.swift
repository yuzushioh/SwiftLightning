//
//  PayMainInteractor.swift
//  SwiftLightning
//
//  Created by Howard Lee on 2018-04-28.
//  Copyright (c) 2018 BiscottiGelato. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol PayMainBusinessLogic {
  
  func confirmPayment(request: PayMain.ConfirmPayment.Request)
}


protocol PayMainDataStore {
  
  //var name: String { get set }
}


class PayMainInteractor: PayMainBusinessLogic, PayMainDataStore {
  
  var presenter: PayMainPresentationLogic?
  var worker: PayMainWorker?
  
  // MARK: Confirm Payment
  
  func confirmPayment(request: PayMain.ConfirmPayment.Request) {
    
    
    
    
    
    
    
  }
}
