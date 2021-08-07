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
    var iconUrl:[String]?
}

class ViewController: UIViewController {

    @IBOutlet weak var weatherIcon: UIImageView!
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
        
        searchBar.resignFirstResponder()
        guard let searchPlace = searchBar.text?.replacingOccurrences(of: " ", with: "%20") else{
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
                    info.iconUrl = current["weather_icons"] as! [String]?
                }
                
                
                print("Location =\(info.locationName)")
                print("Temp_c =\(info.temp_c)")
                
                
                if (info.locationName != nil) && (info.temp_c != nil){
                    DispatchQueue.main.async {
                        self?.cityLabel.text = info.locationName!
                        self?.temperatureLabel.text = "\(info.temp_c!)"
                        
                        if info.iconUrl != nil {
                            if !info.iconUrl!.isEmpty{
                                self?.loadIcon(strUrl: info.iconUrl![0])
                            }
                        }
                    }
                    
                }
               
                
            }catch let jsonError{
                print(jsonError)
            }
        }
        
        task.resume()
        
    }
    
    func loadIcon(strUrl:String) {
       print("try load icon=\(strUrl)")
        
        guard let url = URL(string: strUrl) else {
            print("wrong url")
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.weatherIcon.image = image
                        }
                }
            }

        }
    }
}
