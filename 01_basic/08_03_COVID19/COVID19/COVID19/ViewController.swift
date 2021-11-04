//
//  ViewController.swift
//  COVID19
//
//  Created by Jeonggi Hong on 2021/11/03.
//

import UIKit

import Alamofire
import Charts

class ViewController: UIViewController {

    @IBOutlet weak var totalCaseLabel: UILabel!
    @IBOutlet weak var newCaseLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchCovidOverview(completionHandler: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(result):
                debugPrint("success \(result)")
            case let .failure(error):
                debugPrint("error \(error)")
            }
        })
    }

    func fetchCovidOverview(
        completionHandler: @escaping (Result<CityCovidOverView, Error>) -> Void
    ) {
        let url = "https://api.corona-19.kr/korea/country/new/"
        let param = [
            "serviceKey": "PLVhSKZrWMqt2NJRsy1pUbcFgoH4kidX3"
        ]
        
        // API 호출
        AF.request(url, method: .get, parameters: param)
            .responseData(completionHandler: { response in
                switch response.result {
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(CityCovidOverView.self, from: data)
                        completionHandler(.success(result))
                    } catch {
                        completionHandler(.failure(error))
                    }
                case let .failure(error):
                    completionHandler(.failure(error))
                }
            })
        
    }

}

