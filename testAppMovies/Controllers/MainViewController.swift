//
//  MainViewController.swift
//  testAppMovies
//
//  Created by pavel on 14.10.21.
//


// heart delete
// heart save
// change tableView
// 

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    //collectionView
    private var collectionView: UICollectionView?

    //coreData
    let dataStoreManager = DataStoreManager()
    
    //network
    let networkManager = NetworkManager()
    var movies: Movies?
    
    var likeMoviesArray = [Film]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupCollectionView()
        getData()
    }
    
    
    //MARK: - create collectionView
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let heightNavBar = Int(navigationController?.navigationBar.bounds.height ?? 0)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: heightNavBar, width: Int(view.bounds.width), height: Int(view.bounds.height - CGFloat(heightNavBar))), collectionViewLayout: layout)
        guard let collectionView = collectionView else { return }
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        //constrints
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    
    //MARK: - get Data
    func getData() {
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=8eb2689e82bb66f2ff69c2a52ef25833"
        networkManager.request(urlString: urlString) { [weak self] (result) in
            switch result {
            case .success(let popularMovies):
                self?.movies = popularMovies
                self?.collectionView?.reloadData()
                popularMovies.results.map { movies in
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    //MARK: - click like action
    @objc func likeButtonTaped(sender: UIButton) {
        if sender.currentImage == UIImage(named: "heart") {
            sender.setImage(UIImage(named: "red-heart"), for: .normal)
            saveMovies(tag: sender.tag) //save likeMovie
        } else if sender.currentImage == UIImage(named: "red-heart") {
            sender.setImage(UIImage(named: "heart"), for: .normal)
            updateMovies(tag: sender.tag) //delete(update) movie
        }
    }
    
    
    //MARK: - save context
    func saveMovies(tag: Int) {
        //добираемся до context
        let context = dataStoreManager.persistentContainer.viewContext

        //добираемся до сущности, которую указывали при создании
        guard let entity = NSEntityDescription.entity(forEntityName: "Film", in: context) else {return}
        
        //добираемся до объекта
        let movie = Film(entity: entity, insertInto: context)
        guard let likeMovie = movies?.results[tag].title else {return}
        movie.name = likeMovie
        
        // сохраняем(записываем) контекст
        do {
            try context.save()
            likeMoviesArray.append(movie)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    //MARK: - update(delete) context
    func updateMovies(tag: Int) {
        let context = dataStoreManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Film> = Film.fetchRequest() //запрос
        let nameDelMovie = movies?.results[tag].title
        
        // delete
        if let movies = try? context.fetch(fetchRequest) {
            for movieDel in movies {
                if nameDelMovie == movieDel.name {
                    context.delete(movieDel)
                }
            }
        }
        //пересохраняем
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}


//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.movies?.results.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
        cell.layer.cornerRadius = 10
        cell.contentView.backgroundColor = .lightGray
        
        cell.configureLabel(label: movies?.results[indexPath.item].title ?? "")
        cell.configureButton(tag: indexPath.item)
        cell.getButton().addTarget(self, action: #selector(likeButtonTaped(sender:)), for: .touchUpInside)
             
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: Int(view.bounds.width), height: 60)
    }
}
