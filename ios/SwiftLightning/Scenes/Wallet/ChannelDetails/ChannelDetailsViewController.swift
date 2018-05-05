//
//  ChannelDetailsViewController.swift
//  SwiftLightning
//
//  Created by Howard Lee on 2018-05-04.
//  Copyright (c) 2018 BiscottiGelato. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ChannelDetailsDisplayLogic: class {
  func displayRefresh(viewModel: ChannelDetails.Refresh.ViewModel)
  func displayError(viewModel: ChannelDetails.ErrorVM)
}

class ChannelDetailsViewController: UIViewController, ChannelDetailsDisplayLogic {
  var interactor: ChannelDetailsBusinessLogic?
  var router: (NSObjectProtocol & ChannelDetailsRoutingLogic & ChannelDetailsDataPassing)?
  
  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  
  // MARK: Setup
  
  private func setup() {
    let viewController = self
    let interactor = ChannelDetailsInteractor()
    let presenter = ChannelDetailsPresenter()
    let router = ChannelDetailsRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }

  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    refreshView()
  }
  
  
  // MARK: Refresh Views
  
  @IBOutlet weak var nodeView: SLFormNodeView!
  @IBOutlet weak var channelPointView: SLFormLabelView!
  @IBOutlet weak var channelCapacityView: SLFormChSummaryView!
  
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var leftButton: SLBarButton!
  @IBOutlet weak var rightButton: SLBarButton!
  @IBOutlet weak var buttonView: UIView!
  
  
  private func refreshView() {
    let request = ChannelDetails.Refresh.Request()
    interactor?.refresh(request: request)
  }
  
  func displayRefresh(viewModel: ChannelDetails.Refresh.ViewModel) {
    DispatchQueue.main.async {
      self.nodeView.nodePubKeyLabel.text = viewModel.channelVM.nodePubKey
      self.nodeView.ipAddressLabel.text = viewModel.channelVM.ipAddress ?? ""
      self.nodeView.portNumberLabel.text = viewModel.channelVM.port ?? ""
      self.nodeView.aliasNameLabel.text = viewModel.channelVM.alias ?? ""
      
      self.statusLabel.text = viewModel.channelVM.statusText
      self.statusLabel.textColor = viewModel.channelVM.statusColor
      
      self.channelPointView.textLabel.text = viewModel.channelVM.channelPoint
      self.channelCapacityView.canPayAmtLabel.text = viewModel.channelVM.canPayAmt
      self.channelCapacityView.canRcvAmtLabel.text = viewModel.channelVM.canRcvAmt
      
      self.leftButton.isHidden = viewModel.leftButtonHidden
      self.rightButton.isHidden = viewModel.rightButtonHidden
      
      if viewModel.leftButtonHidden, viewModel.rightButtonHidden {
        self.buttonView.isHidden = true
      } else {
        self.buttonView.isHidden = false
      }
    }
  }
  

  // MARK: Connect Channel
  
  @IBAction func connectTapped(_ sender: SLBarButton) {
  }
  
  
  // MARK: Close Channel
  
  @IBAction func closeChannel(_ sender: SLBarButton) {
  }
  
  
  // MARK: Error Display
  
  func displayError(viewModel: ChannelDetails.ErrorVM) {
    let alertDialog = UIAlertController(title: viewModel.errTitle,
                                        message: viewModel.errMsg, preferredStyle: .alert).addAction(title: "OK", style: .default)
    DispatchQueue.main.async {
      self.present(alertDialog, animated: true, completion: nil)
    }
  }
  
  
  // MARK: Close Cross Tapped
  
  @IBAction func closeCrossTapped(_ sender: UIBarButtonItem) {
    router?.routeToWalletMain()
  }
  
}