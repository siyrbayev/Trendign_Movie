//
//  CoreDataManager.swift
//  Trendign_Movie
//
//  Created by ADMIN ODoYal on 16.05.2021.
//

import Foundation
import CoreData

class MovieEntityCoreDataManager {
    static let shared = MovieEntityCoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {}
    
    func save() {
        let context = persistentContainer.viewContext
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func addMovie(_ movie: TrendingMovieEntity.Movie) {
        let context = persistentContainer.viewContext
        context.perform {
            let newMovie = MovieEntity(context: context)
            newMovie.id = Int64(movie.id)
            newMovie.title =  movie.title
            newMovie.overview = movie.overview
            newMovie.backdropPath = movie.backdrop
            newMovie.rating = movie.rating ?? 0.0
            newMovie.posterPath = movie.poster
        }
        save()
    }
    
    func addMovie(_ movie: MovieDetailsEntity) {
        let context = persistentContainer.viewContext
        context.perform {
            let newMovie = MovieEntity(context: context)
            newMovie.id = Int64(movie.id ?? 0)
            newMovie.title =  movie.title
            newMovie.overview = movie.overview
            newMovie.backdropPath = movie.backdrop
            newMovie.rating = movie.rating ?? 0.0
            newMovie.posterPath = movie.poster
        }
        save()
    }
    
    func findMovie(with id: Int) -> MovieEntity? {
        let context = persistentContainer.viewContext
        let requestResult: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        requestResult.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let movies = try context.fetch(requestResult)
            if movies.count > 0 {
                assert(movies.count == 1, "It means DB has dublicates")
                return movies[0]
            }
            
            
        } catch {
            print(error)
        }
        return nil
    }
    
    func deleteMovie(with id: Int) {
        let context = persistentContainer.viewContext
        let movie = findMovie(with: id)
        if let movie = movie {
            context.delete(movie)
            save()
        }
    }
  
    func allMovies() -> [TrendingMovieEntity.Movie] {
        let context = persistentContainer.viewContext
        let requestResult: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        

        let movies = try? context.fetch(requestResult)
    
        return movies?.map({ TrendingMovieEntity.Movie.init(movie: $0) }) ?? []
    }
}
