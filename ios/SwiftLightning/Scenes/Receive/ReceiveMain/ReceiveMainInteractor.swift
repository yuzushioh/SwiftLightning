//
//  ReceiveMainInteractor.swift
//  SwiftLightning
//
//  Created by Howard Lee on 2018-04-21.
//  Copyright (c) 2018 BiscottiGelato. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ReceiveMainBusinessLogic
{
  func generateOnChain(request: ReceiveMain.GenerateOnChain.Request)
}

protocol ReceiveMainDataStore
{
}

class ReceiveMainInteractor: ReceiveMainBusinessLogic, ReceiveMainDataStore
{
  var presenter: ReceiveMainPresentationLogic?

  
  // MARK: Generate On Chain
  
  func generateOnChain(request: ReceiveMain.GenerateOnChain.Request) {
    LNServices.newAddress { (responder) in
      do {
        let onChainAddress = try responder()
        let result = Result<String>.success(onChainAddress)
        let response = ReceiveMain.GenerateOnChain.Response(result: result)
        self.presenter?.presentOnChain(response: response)
        
      } catch {
        let result = Result<String>.failure(error)
        let response = ReceiveMain.GenerateOnChain.Response(result: result)
        self.presenter?.presentOnChain(response: response)
      }
    }
  }
}