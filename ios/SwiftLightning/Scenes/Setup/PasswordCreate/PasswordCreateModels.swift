//
//  PasswordCreateModels.swift
//  SwiftLightning
//
//  Created by Howard Lee on 2018-04-17.
//  Copyright (c) 2018 BiscottiGelato. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum PasswordCreate
{
  enum ValidatePasswords {
    struct Constants {
      static let minNumChar = 8
      static let maxNumChar = 64
    }
    
    enum ValidatePasswordStatusEnum: String {
      case needMoreCharacters = "8 characters minimum"
      case tooManyCharacters = "64 characters maximum"
      case passwordOk = " "  // HACK: This is to prevent the textfield from collapsing
    }
    
    enum ValidateConfirmStatusEnum: String {
      case needsConfirmation = "confirm password"
      case passwordMismatch = "password confirmation mismatched"
      case confirmationOk = " "  // HACK: This is to prevent the textfield from collapsing
    }
    
    struct Request  {
      var passwordText: String
      var confirmText: String
    }
    
    struct Response {
      var passwordFieldStatus: ValidatePasswordStatusEnum
      var confirmFieldStatus: ValidateConfirmStatusEnum
    }
    
    struct ViewModel {
      var passwordFieldLabelText: String
      var passwordFieldLabelColor: UIColor
      var confirmFieldLabelText: String
      var confirmFieldLabelColor: UIColor
      var proceedButtonEnabled: Bool
    }
  }
  
  
  enum SeedWalletError: Error {
    case PasswordConfirmFailed(String)
    case GenerateSeedInvalidMnemonics(String)
  }
  
  
  enum SeedWallet {
    
    struct Request  {
      var passwordText: String
      var confirmText: String
    }
    
    struct Response {
      var result: Result<Void>
    }
    
    struct ViewModel {
      var errorTitle: String?
      var errorMsg: String?
    }
  }
}
