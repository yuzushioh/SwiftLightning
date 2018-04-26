//
//  ChannelOpenInteractor.swift
//  SwiftLightning
//
//  Created by Howard Lee on 2018-04-23.
//  Copyright (c) 2018 BiscottiGelato. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ChannelOpenBusinessLogic
{
  func channelConfirm(request: ChannelOpen.ChannelConfirm.Request)
}

protocol ChannelOpenDataStore
{
  var nodePubKey: String { get }
  var nodeIP: String { get }
  var nodePort: Int { get }
  var fundingAmt: Bitcoin { get }
  var initPayAmt: Bitcoin { get }
  var confSpeed: OnChainConfirmSpeed { get }
}

class ChannelOpenInteractor: ChannelOpenBusinessLogic, ChannelOpenDataStore {
  
  var presenter: ChannelOpenPresentationLogic?
  var worker: ChannelOpenWorker?
  
  
  // MARK: Data Store
  
  private var _nodePubKey: String?
  private var _nodeIP: String?
  private var _nodePort: Int?
  private var _fundingAmt: Bitcoin?
  private var _initPayAmt: Bitcoin?
  private var _confSpeed: OnChainConfirmSpeed?
  
  var nodePubKey: String {
    guard let returnValue = _nodePubKey else {
      SLLog.fatal("nodePubKey in Data Store = nil")
    }
    return returnValue
  }
  
  var nodeIP: String {
    guard let returnValue = _nodeIP else {
      SLLog.fatal("nodeIP in Data Store = nil")
    }
    return returnValue
  }
  
  var nodePort: Int {
    guard let returnValue = _nodePort else {
      SLLog.fatal("nodePort in Data Store = nil")
    }
    return returnValue
  }
  
  var fundingAmt: Bitcoin {
    guard let returnValue = _fundingAmt else {
      SLLog.fatal("fundingAmt in Data Store = nil")
    }
    return returnValue
  }
  
  var initPayAmt: Bitcoin {
    guard let returnValue = _initPayAmt else {
      SLLog.fatal("initPayAmt in Data Store = nil")
    }
    return returnValue
  }
  
  var confSpeed: OnChainConfirmSpeed {
    guard let returnValue = _confSpeed else {
      SLLog.fatal("confSpeed in Data Store = nil")
    }
    return returnValue
  }
  
  
  // MARK: Channel Opening Confirm
  
  func channelConfirm(request: ChannelOpen.ChannelConfirm.Request)
  {
    // Validate and Convert Node Pub Key
    let isNodePubKeyValid = LNManager.validateNodePubKey(request.nodePubKey)
    _nodePubKey = request.nodePubKey
    
    // Validate and Convert Port IP
    let ipPort = LNManager.parsePortIPString(request.nodeIPPort)
    _nodeIP = ipPort.ipString
    _nodePort = ipPort.port
    let isNodeIPValid = _nodeIP != nil
    let isNodePortValid = _nodePort != nil
    
    // TODO: Calculate Fee involved for desired Conf Speed
    _confSpeed = request.confSpeed
    
    // Validate and Convert Funding Amount
    var isFundingAmtValid = false
    
    // TODO: Need to know what the text field value means. Satoshi? Bits? USD? etc
    if let fundingAmt = Bitcoin(inSatoshi: request.fundingAmt) {
      _fundingAmt = fundingAmt
      isFundingAmtValid = true
    }
    
    // TODO: Check for sufficient on-chain funds
    
    // Validate and Convert Initial Payment
    var isInitPayAmtValid = false
    
    // TODO: Need to know what the text field value means. Satoshi? Bits? USD? etc
    if let initPayAmt = Bitcoin(inSatoshi: request.fundingAmt), initPayAmt <= fundingAmt {
      _initPayAmt = initPayAmt
      isInitPayAmtValid = true
    }
    
    // Store to DataStore if A-OK
    if !(isNodePubKeyValid && isNodeIPValid && isNodePortValid && isFundingAmtValid && isInitPayAmtValid) {
      _nodePubKey = nil
      _nodeIP = nil
      _nodePort = nil
      _fundingAmt = nil
      _initPayAmt = nil
    }
    
    // Report field valid status to Presenter
    let response = ChannelOpen.ChannelConfirm.Response(isPubKeyValid: isNodePubKeyValid,
                                                       isIPValid: isNodeIPValid,
                                                       isPortValid: isNodePortValid,
                                                       isFundingValid: isFundingAmtValid,
                                                       isInitPayValid: isInitPayAmtValid)
    presenter?.presentChannelConfirm(response: response)
  }
}
