//
//  ProfileViewModel.swift
//  Knot
//
//  Created by Jessica Huynh on 2020-03-10.
//  Copyright © 2020 Jessica Huynh. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewModel: NSObject {
    let storageManager = StorageManager.instance
    var sections: [ProfileViewModelSection] = []
    
    enum SectionType {
        case accounts, deleteAccounts
    }
    
    override init() {
        super.init()
        
        sections.append(AccountsSection(accounts: storageManager.accounts))
        if !storageManager.accounts.isEmpty {
            sections.append(DeleteAccountsSection())
        }
    }
}

// MARK: - Table View Data Source
extension ProfileViewModel: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections[section].rowCount == 0 { return 1 }
        return sections[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        
        switch section.type {
        case .accounts:
            if section.rowCount == 0 {
                return tableView.dequeueReusableCell(withIdentifier: "LinkAccountCell")!
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountNumberCell", for: indexPath)
            let section = section as! AccountsSection
            let account = section.accounts[indexPath.row]
            
            cell.textLabel?.text = (account.institution.name)
            
            if let mask = account.mask {
                cell.textLabel?.text! += " (\(mask))"
            }
            
            cell.detailTextLabel?.text = section.accounts[indexPath.row].name
            cell.selectedBackgroundView = UITableViewCell.lightGrayBackgroundView
            
            return cell
            
        case .deleteAccounts:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeleteAccountsCell", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - View Model Data
protocol ProfileViewModelSection {
    var type: ProfileViewModel.SectionType { get }
    var title: String { get }
    var rowCount: Int { get }
}

extension ProfileViewModel {
    class AccountsSection: ProfileViewModelSection {
        var accounts: [Account]
        
        var type: ProfileViewModel.SectionType {
            return .accounts
        }
        
        var title: String {
            return "Accounts"
        }
        
        var rowCount: Int {
            return accounts.count
        }
        
        init(accounts: [Account]) {
            self.accounts = accounts
        }
    }

    class DeleteAccountsSection: ProfileViewModelSection {
        var type: ProfileViewModel.SectionType {
            return .deleteAccounts
        }
        
        var title: String {
            return " "
        }
        
        var rowCount: Int {
            return 1
        }
    }
}
