//
//  MainPresenter.swift
//  rssApp
//
//  Created by Mikhail Danilov on 15.01.2021.
//

import Foundation

enum FilterState {
    case normal
    case noColor
    case blur
}

protocol MainViewProtocol: AnyObject {
    func setRss(rssItems: [RssItem])
    func updateTableView()
}

protocol MainPresenterProtocol: AnyObject {
    func getNews()
    func setFilterState(filterState: FilterState)
    var filterState: FilterState { get }
}

final class MainPresenter: MainPresenterProtocol {

    // MARK: Constants
    let url = "https://habr.com/ru/rss/hubs?count=3"
    
    // MARK: Properties
    weak var view: MainViewProtocol?
    var router: MainRouterProtocol?
    private let  rssService: RssService
    var filterState = FilterState.normal
    
    init(view: MainViewProtocol, router: MainRouterProtocol, rssService: RssService) {
        self.view = view
        self.router = router
        self.rssService = rssService
    }
    
    // MARK: Methods
    func getNews() {
        rssService.getRssNews(url: url, completion: { [weak self] (items, status, error)  in
            if status {
                self?.view?.setRss(rssItems: items)
            }
        })
    }
    
    func setFilterState(filterState: FilterState) {
        self.filterState = filterState
        view?.updateTableView()
    }
}
