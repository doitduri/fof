//
//  ImageModels.swift
//  makeus
//
//  Created by 김두리 on 2021/03/01.
//

import Foundation

class MemeFeed: ObservableObject, RandomAccessCollection {
    typealias Element = MemeListItem
    
    @Published var memeListItems = [MemeListItem]()
    
    var startIndex: Int { memeListItems.startIndex }
    var endIndex: Int { memeListItems.endIndex }
    var loadStatus = LoadStatus.ready(nextPage: 1)
    
    var urlBase = "https://newsapi.org/v2/everything?q=apple&apiKey=6ffeaceffa7949b68bf9d68b9f06fd33&language=en&page=1"
    
    init(){
        loadMoreArticles()
    }
    
    subscript(position: Int) -> MemeListItem {
        return memeListItems[position]
    }
    
    func loadMoreArticles(currentItem: MemeListItem? = nil) {
        if !shouldLoadMoreData(currentItem: currentItem){
            return
        }
        guard case let .ready(page) = loadStatus else {
            return
        }
        
        loadStatus = .loading(page: page)
        let urlString = "\(urlBase)\(page)"
        
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: parseArticlesFromResponse(data:response:error:))
                task.resume()
    }
    
    func shouldLoadMoreData(currentItem: MemeListItem? = nil) -> Bool {
          guard let currentItem = currentItem else {
              return true
          }
          
        for n in (memeListItems.count-4)...(memeListItems.count-1) {
              if n >= 0 && currentItem.id == memeListItems[n].id {
                  return true
              }
          }
          return false
      }
    
    func parseArticlesFromResponse(data: Data?, response: URLResponse?, error: Error?) {
          guard error == nil else {
              print("Error: \(error!)")
              loadStatus = .parseError
              return
          }
          guard let data = data else {
              print("No data found")
              loadStatus = .parseError
              return
          }
          
          let newArticles = parseArticlesFromData(data: data)
          DispatchQueue.main.async {
              self.memeListItems.append(contentsOf: newArticles)
              if newArticles.count == 0 {
                  self.loadStatus = .done
              } else {
                  guard case let .loading(page) = self.loadStatus else {
                      fatalError("loadSatus is in a bad state")
                  }
                  self.loadStatus = .ready(nextPage: page + 1)
              }
          }
      }
    func parseArticlesFromData(data: Data) -> [MemeListItem] {
            var response: MemeApiResponse
            do {
                response = try JSONDecoder().decode(MemeApiResponse.self, from: data)
            } catch {
                print("Error parsing the JSON: \(error)")
                return []
            }
            
//            if response.status != "ok" {
//                print("Status is not ok: \(response.status)")
//                return []
//            }
            
            return response.articles ?? []
        }
        
        enum LoadStatus {
            case ready (nextPage: Int)
            case loading (page: Int)
            case parseError
            case done
        }
}

class MemeApiResponse: Codable {
    var articles: [MemeListItem]?
}


class MemeListItem: Identifiable, Codable {
    var albumId: Int
    var id: Int
    var title: String
    var url: String
    var thumbnailUrl: String
    
    enum CodingKeys: String, CodingKey {
        case albumId, title, id, url, thumbnailUrl
    }
}
