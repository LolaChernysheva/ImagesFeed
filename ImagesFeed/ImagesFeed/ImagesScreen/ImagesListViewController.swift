//
//  ImagesListViewController.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 15.11.2023.
//  
//

import UIKit

protocol ImagesListViewProtocol: AnyObject {
    func displayData(data: ImagesListScreenModel, reloadData: Bool)
    func showActivityIndicator()
    func hideActivityIndicator()
}

final class ImagesListViewController: UIViewController {
    
    typealias Cell = ImagesListScreenModel.TableData.Cell
    typealias Section = ImagesListScreenModel.TableData.Section
    
    private var screenModel: ImagesListScreenModel = .empty {
        didSet {
            setup()
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var presenter: ImagesListPresenterProtocol!
    
    //MARK: - Lifrcycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setup()
        configureTableView()
    }
    
    
    private func setup() {
        view.backgroundColor = screenModel.backbroundColor
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        setupTableViewConstarints()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
    }
    
    private func setupTableViewConstarints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func tableDataCell(indexPath: IndexPath) -> Cell {
        let section = screenModel.tableData.sections[indexPath.section]
        switch section {
        case let .simpleSection(cells):
            return cells[indexPath.row]
        }
    }
}

//MARK: - table view delegate, datasource

extension ImagesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = tableDataCell(indexPath: indexPath)
        let cell: UITableViewCell
        
        switch cellType {
        case let .imageCell(model):
            guard let imageCell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell else { return UITableViewCell() }
            imageCell.viewModel = model
            cell = imageCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch screenModel.tableData.sections[section] {
        case let .simpleSection(cells):
            return cells.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = tableDataCell(indexPath: indexPath)
        switch cellType {
        case let .imageCell(model):
            model.completion()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == presenter.photos.count {
            presenter.fetchPhotosNextPage()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
         screenModel.tableData.sections.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        height(for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        height(for: indexPath)
    }
    
    private func height(for indexPath: IndexPath) -> CGFloat {
        let cellType = tableDataCell(indexPath: indexPath)
        switch cellType {
        case let .imageCell(model):
            let height = model.height(width: tableView.frame.width )
            return height
        }
    }
}

//MARK: - ImagesListViewProtocol

extension ImagesListViewController: ImagesListViewProtocol {
    func displayData(data: ImagesListScreenModel, reloadData: Bool) {
        screenModel = data
        if reloadData {
            tableView.reloadData()
        }
    }
    
    func showActivityIndicator() {
        UIBlockingProgressHUD.show()
    }
    
    func hideActivityIndicator() {
        UIBlockingProgressHUD.dismiss()
    }
}
