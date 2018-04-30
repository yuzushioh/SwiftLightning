//
//  PayMainViewController.swift
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

protocol PayMainDisplayLogic: class {
}


class PayMainViewController: UIViewController, PayMainDisplayLogic {
  var interactor: PayMainBusinessLogic?
  var router: (NSObjectProtocol & PayMainRoutingLogic & PayMainDataPassing)?
  
  
  // MARK: IBOutlets
  
  @IBOutlet weak var headerView: SLFormHeaderView!
  @IBOutlet weak var addressEntryView: SLFormEntryView!
  @IBOutlet weak var amountEntryView: SLFormEntryView!
  @IBOutlet weak var descriptionEntryView: SLFormEntryView!
  @IBOutlet weak var sendButton: SLBarButton!
  
  var isAddressInvalid: Bool = false
  var isAmountInvalid: Bool = false
  
  
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
    let interactor = PayMainInteractor()
    let presenter = PayMainPresenter()
    let router = PayMainRouter()
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
  }
  
  
  // MARK: Dismiss
  
  @IBAction func closeCrossTapped(_ sender: UIBarButtonItem) {
    
  }
  
  
  // MARK: Send Payment
  
  @IBAction func sendTapped(_ sender: SLBarButton) {
    let request = PayMain.ConfirmPayment.Request(rawAddressString: addressEntryView.textField.text ?? "",
                                                 rawAmountString: amountEntryView.textField.text ?? "")
    interactor?.confirmPayment(request: request)
  }
  
  func displayConfirmPayment(viewModel: PayMain.ConfirmPayment.ViewModel) {
    if let address = viewModel.revisedAddress {
      addressEntryView.textField.text = address
    }
    
    if let amount = viewModel.revisedAmount {
      amountEntryView.textField.text = amount
    }
    
    if viewModel.goToConfirm {
      DispatchQueue.main.async {
        self.router?.routeToPayConfirm()
      }
    }
  }
  
  func displayConfirmPaymentError(viewModel: PayMain.ConfirmPayment.ErrorVM) {
    let alertDialog = UIAlertController(title: viewModel.errTitle, message: viewModel.errMsg, preferredStyle: .alert).addAction(title: "OK", style: .default)
    DispatchQueue.main.async {
      self.present(alertDialog, animated: true, completion: nil)
    }
  }
  
  
  
  
  
  
  
  
  
  
}