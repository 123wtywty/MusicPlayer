//
//  MusicListView.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-30.
//  Copyright © 2020 Gary Wu. All rights reserved.
//


import Foundation
import Cocoa
import SwiftUI


struct MusicListView : NSViewControllerRepresentable{
    
    @ObservedObject var data = AppManager.default.viewingMusicListManager
    func makeNSViewController(context: Context) -> NSViewController {
        return ListView()
    }
    
    func updateNSViewController(_ nsViewController: NSViewController, context: Context) {
        
        if data.needUpdate{
            let view = nsViewController as? ListView
            view?.setData(data: self.data.musicList)
            data.needUpdate = false
        }
        
        if let index = data.needJumpTo{
            let view = nsViewController as? ListView
            view?.scrollToRow(number: index)
            self.data.needJumpTo = nil
        }
        
        
    }
}



fileprivate class ListView: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    //    static let shared = ListView()
    
    var data : [Music] = []
    
    public func setData(data: [Music]){
        self.data = data
        self.tableView.reloadData()
    }
    
    private var obPool : [NSKeyValueObservation] = []
    
    var rowHeight = 73
    
    
    var initialized = false
    @objc dynamic let scrollView = NSScrollView()
    @objc dynamic let tableView = NSTableView()
    
    override func loadView() {
        
        print(#function)
        self.view = NSView()
        
    }
    
    override func viewDidLayout() {
        
        if !initialized {
            initialized = true
            print("need init")
            setupView()
            setupTableView()
            
            self.scrollView.hasHorizontalScroller = false
//            self.scrollView.hasVerticalScroller = false
        }
    }
    
    
    func setupView() {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func setupTableView() {
        
        self.tableView.rowHeight = CGFloat(self.rowHeight)
        self.tableView.backgroundColor = .white
        //        self.tableView.gridStyleMask = .solidHorizontalGridLineMask
        
        self.view.addSubview(scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0))
        
        tableView.frame = scrollView.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.headerView = nil
        scrollView.backgroundColor = NSColor.clear
        scrollView.drawsBackground = false
        tableView.backgroundColor = NSColor.clear
        tableView.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
        tableView.selectionHighlightStyle = .none
        
        
        let col = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "col"))
        //        col.minWidth = 200
        tableView.addTableColumn(col)
        
        scrollView.documentView = tableView
        scrollView.hasHorizontalScroller = false
        scrollView.hasVerticalScroller = true
        
        
        //        tableView.addObserver(self, forKeyPath: #keyPath(NSTabView.frame), options: .new, context: nil)
        self.obPool.append(observe(\.tableView.frame, changeHandler: { _, _ in
            self.tableView.reloadData()
        }))
        
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let cell = NSTableCellView()
        
        let view = NSHostingView(rootView: MusicListCell().environmentObject(self.data[row].wrapper)
            .frame(width: self.tableView.frame.width - 14, height: .none))
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        cell.addSubview(view)
        
        cell.addConstraint(NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: cell, attribute: .centerY, multiplier: 1, constant: 0))
        cell.addConstraint(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: cell, attribute: .centerX, multiplier: 1, constant: 0))
        
        
        return cell
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let rowView = NSTableRowView()
        rowView.isEmphasized = false
        
        return rowView
    }
    
    
    func scrollToRow(number: Int){
        self.tableView.scrollRowToVisible(number)
        //        let rowRect = tableView.rect(ofRow: number)
        //        var scrollOrigin = rowRect.origin
        //        let clipView = tableView.superview as? NSClipView
        //
        //        let tableHalfHeight = NSHeight(clipView!.frame)*0.5
        //        let rowRectHalfHeight = NSHeight(rowRect)*0.5
        //
        //        scrollOrigin.y = (scrollOrigin.y - tableHalfHeight) + rowRectHalfHeight
        //        let scrollView = clipView!.superview as? NSScrollView
        //        if(scrollView!.responds(to: #selector(NSScrollView.flashScrollers))){
        //            scrollView!.flashScrollers()
        //        }
        //        clipView!.animator().setBoundsOrigin(scrollOrigin)
    }
    
}
