//
//  MainViewController.swift
//  rssApp
//
//  Created by Mikhail Danilov on 15.01.2021.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let setTitleNormal = "Normal"
        static let setTitleNoColor = "noColor"
        static let setTitleBlur = "Blur"
        static let constraint66: CGFloat = 66
        static let constraint32: CGFloat = 32
        static let constraint30: CGFloat = 30
        static let constraint80: CGFloat = 80
        static let constraint2: CGFloat = 2
        static let constraint1: CGFloat = 1
    }
        

    private (set) var presenter: MainPresenterProtocol?
    private var rssItems = [RssItem]()
    
    private let tableView: UITableView = {
        let table = UITableView()
        
        return table
    }()
    
    private let panelButtons: UIView = {
        let panel = UIView()
        panel.backgroundColor = .white
        
        return panel
    }()
    
    private let lineSpace: UIView = {
        let v = UIView()
        v.backgroundColor = .gray
        
        return v
    }()
    private let buttonNormal: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle(Constants.setTitleNormal, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        
        return button
    }()
    
    private let buttonNoColor: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle(Constants.setTitleNoColor, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        
        return button
    }()
    
    private let buttonBlur: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle(Constants.setTitleBlur, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        presenter?.getNews()
    }
    
    func setup(presenter: MainPresenterProtocol) {
        self.presenter = presenter
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func loadView() {
        super.loadView()
        
        view.addSubview(tableView)
        view.addSubview(lineSpace)
        view.addSubview(panelButtons)
        panelButtons.addSubview(buttonNormal)
        panelButtons.addSubview(buttonNoColor)
        panelButtons.addSubview(buttonBlur)
        
        panelButtons.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(Constants.constraint66)
        }
        
        buttonNormal.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Constants.constraint32)
            $0.height.equalTo(Constants.constraint30)
            $0.width.equalTo(Constants.constraint80)
            $0.top.equalToSuperview().offset(Constants.constraint2)
        }
        buttonNormal.addTarget(self, action: #selector(tapNormal), for: .touchUpInside)
        
        
        buttonNoColor.snp.makeConstraints {
            $0.left.equalTo(buttonNormal.snp.right).offset(Constants.constraint32)
            $0.height.equalTo(Constants.constraint30)
            $0.width.equalTo(Constants.constraint80)
            $0.top.equalToSuperview().offset(Constants.constraint2)
        }
        buttonNoColor.addTarget(self, action: #selector(tapNoColor), for: .touchUpInside)
           
        
        buttonBlur.snp.makeConstraints {
            $0.left.equalTo(buttonNoColor.snp.right).offset(Constants.constraint32)
            $0.height.equalTo(Constants.constraint30)
            $0.width.equalTo(Constants.constraint80)
            $0.top.equalToSuperview().offset(Constants.constraint2)
        }
        buttonBlur.addTarget(self, action: #selector(tapBlur), for: .touchUpInside)
        
        lineSpace.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(panelButtons.snp.top).offset(-Constants.constraint2)
            $0.height.equalTo(Constants.constraint1)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(lineSpace.snp.top).offset(-Constants.constraint2)
        }
    }
    
    @objc func tapNoColor(sender: UIButton!) {
        presenter?.setFilterState(filterState: .noColor)
    }
    
    @objc func tapNormal(sender: UIButton!) {
        presenter?.setFilterState(filterState: .normal)
    }
    @objc func tapBlur(sender: UIButton!) {
        presenter?.setFilterState(filterState: .blur)
    }
}

extension MainViewController: MainViewProtocol{
    
    func setRss(rssItems: [RssItem]) {
        self.rssItems = rssItems
        tableView.reloadData()
    }
    
    func updateTableView() {
        tableView.reloadData()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rssItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RssTableViewCell()
        let rssitem = rssItems[indexPath.row]
        if let filter = presenter?.filterState {
          cell.setup(title: rssitem.title, imgUrls: rssitem.imagesFromDescription, filter: filter)
        }
        return cell
    }
}
