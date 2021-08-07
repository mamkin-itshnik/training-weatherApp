//
//  ViewController.swift
//  weatherApp
//
//  Created by Анастасия on 07.08.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }


}

extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchPlace = searchBar.text else{
            return
        }
        let urlString = "http://api.weatherstack.com/current?access_key=1dd0154d53f7e880f24fedc47fdd31cb&query=\(searchPlace)"
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url){
            (data,response,error) in
            
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers )
                
                
            }catch let jsonError{
                print(jsonError)
            }
        }
        
        
    }
}
