//
//  ProvidersTableViewController.swift
//  AuthorizeMeDemo
//
//  Created by Radislav Crechet on 5/23/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit
import AuthorizeMe

class ProvidersTableViewController: UITableViewController {
    
    private var systemProvider: Provider?
    private var webProvider: Provider?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)!
        var title = cell.textLabel!.text!
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                systemProvider = FacebookSystemProvider()
            case 1:
                webProvider = FacebookWebProvider()
            case 2:
                systemProvider = TwitterSystemProvider()
            case 3:
                webProvider = TwitterWebProvider()
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                webProvider = GoogleWebProvider()
            case 1:
                webProvider = InstagramWebProvider()
            case 2:
                webProvider = LinkedInWebProvider()
            default:
                break
            }
        default:
            break
        }
        
        let provider = systemProvider != nil ? systemProvider : webProvider
        
        if provider == nil {
            let alertController = AlertService.alert(withTitle: "Error", message: "Problem with provider")
            self.present(alertController, animated: true)
            
            return
        }
        
        tableView.isUserInteractionEnabled = false
        
        provider!.authorize { [unowned self] session, error in
            self.tableView.isUserInteractionEnabled = true
            
            self.systemProvider = nil
            self.webProvider = nil
         
            var message: String?
            
            if let session = session {
                message = "\(session.user.name)"
            } else if let error = error,
                error != .cancel {
                
                title = "Error"
                message = "Problem with \(error)"
            }
            
            if let message = message {
                let alertController = AlertService.alert(withTitle: title, message: message)
                self.present(alertController, animated: true)
            }
        }
    }
    
}
