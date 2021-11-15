//
//  BeerListViewController.swift
//  Brewery
//
//  Created by Jeonggi Hong on 2021/11/15.
//

import UIKit

class BeerListViewController: UITableViewController {
    
    var beerList = [Beer]()
    
    var currentPage = 1
    
    var dataTasks = [URLSessionTask]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UINavigationBar
        title = "브루어리"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // UITableView 설정
        tableView.register(BeerListCell.self, forCellReuseIdentifier: "BeerListCell")
        tableView.rowHeight = 150
        
        // 스크롤
        tableView.prefetchDataSource = self
        
        // 페이지에서 시작
        fetchBeer(of: currentPage)
    }
}

// UITableView DataSource, Delegate
extension BeerListViewController: UITableViewDataSourcePrefetching {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeerListCell", for: indexPath) as! BeerListCell
        
        let beer = beerList[indexPath.row]
        cell.configure(with: beer)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBeer = beerList[indexPath.row]
        let detailViewController = BeerDetailViewController()
        
        detailViewController.beer = selectedBeer
        self.show(detailViewController, sender: nil)
    }
    
    // 페이징
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard currentPage != 1 else { return }
        
        indexPaths.forEach {
            if ($0.row + 1)/25 + 1 == currentPage {
                self.fetchBeer(of: currentPage)
            }
        }
    }
    
}

// Data Fetching
private extension BeerListViewController {
    func fetchBeer(of page: Int) {
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?page=\(page)"),
                dataTasks.firstIndex(where: { $0.originalRequest?.url == url }) == nil else { return }
        // 불러 왔던것은 request 진행하지 않도록
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil,
                  let self = self,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let beers = try? JSONDecoder().decode([Beer].self, from: data) else {
                      print("ERROR: URLSession data tase \(error?.localizedDescription ?? "" )")
                      return
            }
            
            switch response.statusCode {
            case (200...299): // 성공
                self.beerList += beers
                self.currentPage += 1
                
                // 왜 넣는 것인가? 반드시 메인스레드에서 사용되어야 한다. -> 다음챕터에 정리 GCD 알아보기
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case(400...499): // 클라이언트 에러
                print("""
                    ERROR : Client ERROR \(response.statusCode)
                    Response: \(response)
                """)
            case(500...599): // 서버 에러
                print("""
                    ERROR : Server ERROR \(response.statusCode)
                    Response: \(response)
                """)
            default:
                print("""
                    ERROR : \(response.statusCode)
                    Response: \(response)
                """)
            }
            
        }
        
        // 반드시 실행
        dataTask.resume()
        
        // 차곡차곡 저장
        dataTasks.append(dataTask)
    }
}
