//
//  GestureConfigSidebarController.swift
//  ReceiverMac
//
//  Created by Marc D. Nichitiu on 12/11/21.
//  Copyright © 2021 MultiTouchFX. All rights reserved.
//

import Foundation
import Cocoa

class SideBarController: NSViewController {
	var isInit = false
    @IBOutlet weak var tableView: NSTableView!

	@IBAction func OpenGithub(_ sender: Any) {
		let url = URL(string: "https://github.com/mdnich/scitool")!
		if NSWorkspace.shared.open(url) {
			print("Browser Successfully opened")
		}
	}

    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        print("Config Initialized")
		initTable()
    }

	func initTable() {
		print("init")
		let indset = IndexSet(integer: 1)
		tableView.selectRowIndexes(indset, byExtendingSelection: false)
        isInit = true
	}

	func update() {
		print("update")
		let selectedItem = tableView.selectedRowIndexes.first
		print(selectedItem)
        MasterViewController.TabViewS.selectTabViewItem(at: (selectedItem ?? 0 ) - 1 )
	}
}

extension SideBarController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 4
    }
}

extension SideBarController: NSTableViewDelegate {
    fileprivate enum CellIdentifiers {
        static let Header = "Simulations"
        static let EquipotentialLines = "Equipotential Lines"
        static let Placeholder1 = "Nothing"
        static let Placeholder2 = "Nothing2"
    }

	func tableView(_ tableView: NSTableView, didSelectRowAt indexPath: IndexPath) {
		print("item: \(tableView.selectedRow)")
        update()
    }

	func tableViewSelectionDidChange(_ notification: Notification) {
        if isInit {
			update()
		}
	}

	func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return row != 0
	}

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cellIdentifier = ""

        if tableColumn == tableView.tableColumns[0] {
            if row == 0 {
                cellIdentifier = CellIdentifiers.Header
            } else if row == 1 {
                cellIdentifier = CellIdentifiers.EquipotentialLines
            } else if row == 2 {
                cellIdentifier = CellIdentifiers.Placeholder1
            } else if row == 3 {
                cellIdentifier = CellIdentifiers.Placeholder2
            }
        }

        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = cellIdentifier
            return cell
        }
        return nil
	}
}
