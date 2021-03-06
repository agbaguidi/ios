//
//  GeneralHelper.swift
//  
//
//  Created by Antonino Urbano on 2015-07-17.
//
//

import UIKit

class GeneralHelper {

    static func warnUser(message: String) {
        let alert = UIAlertView()
        alert.message = message
        alert.addButtonWithTitle("OK".localizedString)
        alert.show()
    }

    static func warnUserWithErrorMessage(message: String) {
        let alert = UIAlertView()
        alert.message = message
        alert.title = "error".localizedString
        alert.addButtonWithTitle("OK".localizedString)
        alert.show()
    }

    static func warnUserWithSucceedMessage(message: String) {
        let alert = UIAlertView()
        alert.message = message
        alert.title = "success".localizedString
        alert.addButtonWithTitle("OK".localizedString)
        alert.show()
    }

}
