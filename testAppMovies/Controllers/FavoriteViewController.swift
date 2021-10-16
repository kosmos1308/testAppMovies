//
//  FavoriteViewController.swift
//  testAppMovies
//
//  Created by pavel on 14.10.21.
//

import UIKit
import CoreData

class FavoriteViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    private let likeMovieTableView = UITableView()
    private let cellId = "cell"
    
    var fetchResultController: NSFetchedResultsController<Film>!
    let dataStoreManager = DataStoreManager()
    var likeMoviesArray = [Film]()
    
    private var deleteAllButton = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .systemBackground
        setupTableView()
        reloadTableView()
        showRemoveAllMovieButton()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        let context = dataStoreManager.persistentContainer.viewContext //обращаемся к контексту
        let fetchRequest: NSFetchRequest<Film> = Film.fetchRequest() //делаем запрос
    
        //сохраняем
        do {
            likeMoviesArray = try context.fetch(fetchRequest)
            reloadTableView()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    //MARK: - create tableView
    func setupTableView() {
        let heightNavBar = Int(navigationController?.navigationBar.bounds.height ?? 0)
        
        likeMovieTableView.frame = CGRect(x: 0, y: Int(heightNavBar), width: Int(view.bounds.width), height: Int(view.bounds.height - CGFloat(heightNavBar)))
        likeMovieTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        likeMovieTableView.delegate = self
        likeMovieTableView.dataSource = self
        view.addSubview(likeMovieTableView)
    }
    
    
    //MARK: - reload tableView
    func reloadTableView() {
        likeMovieTableView.reloadData()
    }
    
    
    //MARK: - show button "Remove all" + action
    func showRemoveAllMovieButton() {
        deleteAllButton = UIBarButtonItem(title: "Remove all", style: .done, target: self, action: #selector(clickRemoveAllButton))
        navigationItem.leftBarButtonItem = deleteAllButton
    }
    
    
    @objc func clickRemoveAllButton() {
        print("deleteAll")
        //show alert
        let alert = UIAlertController(title: "", message: "Do you want to delete all movies?", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "YES", style: .default) { action in
            self.deleteAllMovies() //delete all like movies
        }
        let no = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        alert.addAction(yes)
        alert.addAction(no)
        present(alert, animated: true, completion: nil)
    }
    
    
    func deleteAllMovies() {
        //save context
        let context = self.dataStoreManager.persistentContainer.viewContext //обращаемся к контексту
        let fetchRequest: NSFetchRequest<Film> = Film.fetchRequest() //делаем запрос
        
        //delete
        if let allMovies = try? context.fetch(fetchRequest) {
            for movie in allMovies {
                context.delete(movie) //delete all movies
            }
        }
        
        //save
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        likeMovieTableView.reloadData()
    }
}


//MARK: - UITableViewDataSource, UITableViewDelegate
extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return likeMoviesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = likeMovieTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = likeMoviesArray[indexPath.row].name

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("indexPath", indexPath)
            
            //save context
            let context = self.dataStoreManager.persistentContainer.viewContext //обращаемся к контексту
            let fetchRequest: NSFetchRequest<Film> = Film.fetchRequest() //делаем запрос
            
            let nameDelMovie = likeMoviesArray[indexPath.row]
            
            // delete
            if let movie = try? context.fetch(fetchRequest) {
                for movieDel in movie {
                    if nameDelMovie == movieDel {
                        context.delete(movieDel)
                        print("context", context)
                    }
                }
                likeMovieTableView.reloadData()
            }
            //save
            dataStoreManager.saveContext()
        }
    }
}
