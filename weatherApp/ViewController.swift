//
//  ViewController.swift
//  weatherApp
//
//  Created by Анастасия on 07.08.2021.
//

import UIKit

struct weatherInfo{
    var locationName:String?
    var temp_c:Double?
}

class ViewController: UIViewController {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }


}

extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchPlace = searchBar.text else{
            print("empty text")
            return
        }
        let urlString = "http://api.weatherstack.com/current?access_key=1dd0154d53f7e880f24fedc47fdd31cb&query=\(searchPlace)"
        guard let url = URL(string: urlString) else {
            print("Wrong url")
            return
        }
        var info = weatherInfo()
        
        let task = URLSession.shared.dataTask(with: url){[weak self]
            (data,response,error) in
            
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers ) as! [String:AnyObject]
                
                if let location = json["location"] {
                    info.locationName = location["name"] as? String ?? "unknown"
                }
                if let current = json["current"]{
                    info.temp_c = current["temperature"] as? Double
                }
                
                
                print("Location =\(info.locationName)")
                print("Temp_c =\(info.temp_c)")
                
                
                if (info.locationName != nil) && (info.temp_c != nil){
                    DispatchQueue.main.async {
                        self?.cityLabel.text = info.locationName!
                        self?.temperatureLabel.text = "\(info.temp_c!)"
                    }
                    
                }
               
                
            }catch let jsonError{
                print(jsonError)
            }
        }
        
        task.resume()
        
    }
}
