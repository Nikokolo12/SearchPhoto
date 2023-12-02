//
//  ViewController.swift
//  PhotoSearch
//
//  Created by Soto Nicole on 30.11.23.
//

import UIKit

struct Response: Codable{
     let total: Int
     let total_pages: Int
     let results: [Result]
}

struct Result: Codable {
     let id: String
     let urls: URLS
}

struct URLS: Codable{
     let regular: String
}

class ViewController: UIViewController, UISearchBarDelegate{
     var results = [Result]()
     
     var collectionView: UICollectionView?
     let searchBar = UISearchBar()
     
     override func viewDidLoad() {
          super.viewDidLoad()
          
          let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
          self.view.addGestureRecognizer(tapGesture)
          
          let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
          layout.sectionInset = UIEdgeInsets(top: 60, left: 10, bottom: 10, right: 10)
          layout.itemSize = CGSize(width: view.frame.size.width/2.2, height: view.frame.size.height/5)
          
          layout.scrollDirection = .vertical
          
          let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
          collectionView.backgroundColor = .systemBackground
          
          view.addSubview(collectionView)
          collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
          self.collectionView = collectionView
          collectionView.dataSource = self
          collectionView.delegate = self
         
          searchBar.delegate = self
          view.addSubview(searchBar)
          
     }
     
     override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
          collectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 30, width: view.frame.size.width, height: view.frame.size.height - 50)
          searchBar.frame = CGRect(x: 10, y: view.safeAreaInsets.top + 15, width: view.frame.size.width - 20, height: 40)
     }
     
     @objc func dismissKeyboard() {
          self.view.endEditing(true)
     }
     
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
          searchBar.resignFirstResponder()
          if let text = searchBar.text{
               results = []
               getPhotos(query: text)
          }
     }
     
     func getPhotos(query: String){
          let urlString = "https://api.unsplash.com/search/photos?page=1&query=\(query)&client_id=eki44gUqIYUrmjl7kIuaLav7XaieMnmWk77xe8h3WGs"
          guard let url = NSURL(string: urlString) else{ return }
          let task = URLSession.shared.dataTask(with: url as URL) {[weak self] data, _, error in
               guard let data = data, error == nil else { return }
               do {
                    let jsonResult = try JSONDecoder().decode(Response.self, from: data)
                    DispatchQueue.main.async{
                         self?.results = jsonResult.results
                         self?.collectionView?.reloadData()
                    }
               }
               catch {
                    print(error)
               }
          }
          task.resume()
     }
     
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
     
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return results.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let imageString = results[indexPath.row].urls.regular
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
          
          cell.loadPhotos(urlString: imageString)
          return cell
     }
     
     
}
