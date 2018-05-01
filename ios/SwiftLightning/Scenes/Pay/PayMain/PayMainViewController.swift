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
  
  func updateInvalidity(addr: Bool?, amt: Bool?, route: Bool?)
  func displayConfirmPayment()
  func displayUpdate(viewModel: PayMain.UpdateVM)
  func displayAddressWarning(viewModel: PayMain.AddressVM)
  func displayAmountWarning(viewModel: PayMain.AmountVM)
  func displayWarning(viewModel: PayMain.WarningVM)
  func displayError(viewModel: PayMain.ErrorVM)
}


class PayMainViewController: SLViewController, PayMainDisplayLogic, UITextFieldDelegate {
  var interactor: PayMainBusinessLogic?
  var router: (NSObjectProtocol & PayMainRoutingLogic & PayMainDataPassing)?
  
  
  // MARK: IBOutlets
  
  @IBOutlet weak var headerView: SLFormHeaderView!
  @IBOutlet weak var addressEntryView: SLFormEntryView!
  @IBOutlet weak var amountEntryView: SLFormEntryView!
  @IBOutlet weak var descriptionEntryView: SLFormEntryView!
  
  @IBOutlet weak var formBottomConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var warningView: UIView!
  @IBOutlet weak var warningLabel: UILabel!
  @IBOutlet weak var sendButton: SLBarButton!
  
  var isAddressInvalid: Bool = false
  var isAmountInvalid: Bool = false
  var isRoutingInvalid: Bool = false
  
  
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
    keyboardConstraint = formBottomConstraint
    keyboardConstraintMargin = formBottomConstraint.constant
    
    addressEntryView.textField.delegate = self
    amountEntryView.textField.delegate = self
    descriptionEntryView.textField.delegate = self
    
    headerView.iconImageView.image = nil
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    addressEntryView.textField.becomeFirstResponder()
  }
  
  
  // MARK: Text Field Return
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
    case addressEntryView.textField:
      addressEntryView.textField.becomeFirstResponder()
    case amountEntryView.textField:
      amountEntryView.textField.becomeFirstResponder()
    case descriptionEntryView.textField:
      if sendButton.isEnabled { confirmPayment() }
    default:
      SLLog.assert("Unreognized textfield returned - \(textField)")
    }
    return true
  }
  
  
  // MARK: Text Field Did Change
  
  @objc private func textFieldDidChange(_ textField: UITextField) {
    updateInvalidity()
  }
  
  
  // MARK: Verify Text Field Entries
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    switch textField {
      
    case addressEntryView.textField:
      addressEntryView.textField.text = addressEntryView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
      let request = PayMain.ValidateAddress.Request(rawAddressString: addressEntryView.textField.text ?? "",
                                                   rawAmountString: amountEntryView.textField.text ?? "")
      interactor?.validateAddress(request: request)
      
    case amountEntryView.textField:
      amountEntryView.textField.text = amountEntryView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
      let request = PayMain.ValidateAmount.Request(rawAddressString: addressEntryView.textField.text ?? "",
                                                   rawAmountString: amountEntryView.textField.text ?? "")
      interactor?.validateAmount(request: request)
    
    case descriptionEntryView.textField:
      break
      
    default:
      SLLog.assert("Unreognized textfield returned - \(textField)")
    }
  }
  
  
  // MARK: Send Payment
  
  @IBAction func sendTapped(_ sender: SLBarButton) {
    confirmPayment()
  }
  
  private func confirmPayment() {
    let inputAddressString = addressEntryView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    let inputAmountString = amountEntryView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    
    let request = PayMain.ConfirmPayment.Request(rawAddressString: inputAddressString ?? "",
                                                 rawAmountString: inputAmountString ?? "")
    interactor?.confirmPayment(request: request)
  }
  
  func displayConfirmPayment() {
    DispatchQueue.main.async {
      self.router?.routeToPayConfirm()
    }
  }
  
  
  // MARK: Display Update
  
  func displayUpdate(viewModel: PayMain.UpdateVM) {
    DispatchQueue.main.async {
      if let address = viewModel.revisedAddress {
        self.addressEntryView.textField.text = address
      }
      
      if let amount = viewModel.revisedAmount {
        self.amountEntryView.textField.text = amount
      }
      
      if let description = viewModel.payDescription {
        self.descriptionEntryView.textField.text = description
      }
      
      if let paymentType = viewModel.paymentType {
        switch paymentType {
        case .lightning:
          self.headerView.iconImageView.image = UIImage(named: "BoltColored")
          self.headerView.headerLabel.text = "Lightning Payment"
        case .onChain:
          self.headerView.iconImageView.image = UIImage(named: "ChainColored")
          self.headerView.headerLabel.text = "On-Chain Payment"
        }
      }
      
      self.amountEntryView.balanceLabel.text = viewModel.balance
      
      // TODO: fee button color should change based on whether fee is within expected range
      self.amountEntryView.feeButton.setTitle(viewModel.fee, for: .normal)
    }
  }
  
  
  // MARK: Validity Tracking
  
  func updateInvalidity(addr: Bool? = nil, amt: Bool? = nil, route: Bool? = nil) {
    if let addr = addr { isAddressInvalid = addr }
    if let amt = amt { isAmountInvalid = amt }
    if let route = route { isRoutingInvalid = route }
    
    DispatchQueue.main.async {
      // Update button state
      if (self.isAddressInvalid || self.isAmountInvalid || self.isRoutingInvalid ||
         (self.addressEntryView.textField.text?.isEmpty ?? true) ||
         (self.amountEntryView.textField.text?.isEmpty ?? true)) {
        
        self.sendButton.isEnabled = false
        self.sendButton.backgroundColor = UIColor.disabledGray
        self.sendButton.shadowColor = UIColor.disabledGrayShadow
        self.sendButton.setTitleColor(UIColor.disabledText, for: .normal)
        
      } else {
        self.sendButton.isEnabled = true
        self.sendButton.backgroundColor = UIColor.medAquamarine
        self.sendButton.shadowColor = UIColor.medAquamarineShadow
        self.sendButton.setTitleColor(UIColor.normalText, for: .normal)
      }
    }
  }

  
  // MARK: Error Displays
  
  func displayAddressWarning(viewModel: PayMain.AddressVM) {
    DispatchQueue.main.async {
      self.addressEntryView.errorLabel.text = viewModel.errMsg
    }
  }
  
  func displayAmountWarning(viewModel: PayMain.AmountVM) {
    DispatchQueue.main.async {
      self.amountEntryView.errorLabel.text = viewModel.errMsg
    }
  }
  
  func displayWarning(viewModel: PayMain.WarningVM) {
    DispatchQueue.main.async {
      if viewModel.errMsg != "" {
        self.warningLabel.text = viewModel.errMsg
        self.warningView.isHidden = false
      } else {
        self.warningLabel.text = ""
        self.warningView.isHidden = true
      }
    }
  }
  
  func displayError(viewModel: PayMain.ErrorVM) {
    let alertDialog = UIAlertController(title: viewModel.errTitle, message: viewModel.errMsg, preferredStyle: .alert).addAction(title: "OK", style: .default)
    DispatchQueue.main.async {
      self.present(alertDialog, animated: true, completion: nil)
    }
  }

  
  // MARK: Dismiss
  
  @IBAction func closeCrossTapped(_ sender: UIBarButtonItem) {
    router?.routeToWalletMain()
  }
  
}
