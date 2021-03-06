//
//  NeutrinoPeersInteractor.swift
//  SwiftLightning
//
//  Created by Howard Lee on 2018-05-13.
//  Copyright (c) 2018 BiscottiGelato. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol NeutrinoPeersBusinessLogic {
  func fetchCurrentPeers(request: NeutrinoPeers.CurrentPeers.Request)
  func writePeers(request: NeutrinoPeers.WritePeers.Request)
}


protocol NeutrinoPeersDataStore {
  //var name: String { get set }
}


class NeutrinoPeersInteractor: NeutrinoPeersBusinessLogic, NeutrinoPeersDataStore {
  var presenter: NeutrinoPeersPresentationLogic?
  
  
  // MARK: Current Peers
  
  func fetchCurrentPeers(request: NeutrinoPeers.CurrentPeers.Request) {
    var result: Result<[String]>
    
    do {
      // Read LND.conf and find all instances of addrpeers
      let peerAddrs = try LNManager.findNeutrinoPeers()
      result = .success(peerAddrs)
    } catch {
      result = .failure(error)
    }
    
    let response = NeutrinoPeers.CurrentPeers.Response(result: result)
    presenter?.presentCurrentPeers(response: response)
  }
  
  
  // MARK: Update Peers by Writing
  
  func writePeers(request: NeutrinoPeers.WritePeers.Request) {
    var result: Result<Void>
    
    do {
      // Read LND.conf and find all instances of addrpeers
      _ = try LNManager.findNeutrinoPeers(andReplaceWith: request.peers)
      result = .success(())
    } catch {
      result = .failure(error)
    }
    
    let response = NeutrinoPeers.WritePeers.Response(result: result)
    presenter?.presentWritePeers(response: response)
  }
}
