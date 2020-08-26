//
//  RefreshableController.swift
//  SwiftModulesDemo
//
//  Created by ash on 2020/8/25.
//  Copyright © 2020 cc. All rights reserved.
//

import UIKit
import Kingfisher

class RefreshableCell: UITableViewCell {
    
    // MARK:- UI
    fileprivate let picView = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(picView)
        picView.layer.masksToBounds = true
        picView.contentMode = .scaleAspectFit
        picView.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.size.width, height: 250)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RefreshableController: UIViewController, Refreshable {
    
    // UI
    fileprivate var tableView = UITableView(frame: .zero)
    
    let viewModel = RefreshableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
    override func cc_setupUI() {
        tableView.register(cellWithClass: RefreshableCell.self)
        tableView.rowHeight = 270
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
    }
    
    override func cc_bindViewModel() {
        
        // 仅添加headerView
//        _ = rx.headerRefresh(rviewModel, tableView)
        // 仅添加footerView
//        _ = rx.footerRefresh(viewModel, tableView)
        
        rx.refresh(viewModel, tableView)
        .map { (type) -> Bool in
            return type == .header ? true: false
        }
        .bind(to: viewModel.refreshSubject, viewModel.loadDataSubject)
        .disposed(by: rx.disposeBag)
        
        viewModel.dataSources.subscribe(onNext: { [weak self] (_) in
            self?.tableView.reloadData()
        }).disposed(by: rx.disposeBag)
        
        viewModel.cc.refreshStatus.accept(.beginHeaderRefresh)

    }
    
    deinit {
        print("deinit -- RefreshableController")
    }
}

extension RefreshableController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSources.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: RefreshableCell.self)
        let model = viewModel.dataSources.value[indexPath.row]
        cell.picView.kf.setImage(with: .network(ImageResource.init(downloadURL: URL.init(string: model.url)!)))
        return cell
    }
    
    
}

// 常用配置
struct RefreshConfig {
    
    static let normalHeader = RefreshableHeaderConfig(
        hideState: true,
        hideLastUpdatedTime: true
    )
    
    static let whiteHeader = RefreshableHeaderConfig(
        stateColor: .white,
        hideState: true,
        hideLastUpdatedTime: true,
        activityIndicatorViewStyle: UIActivityIndicatorView.Style.medium
    )
    
//    static let diyHeader = RefreshableHeaderConfig(type: RefreshHeaderType.diy(type: DIYHeader.self))
//
//    static let diyFooter = RefreshableFooterConfig(type: RefreshFooterType.diy(type: DIYAutoFooter.self))
}

