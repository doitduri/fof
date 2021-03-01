//
//  MemeImageModel.swift
//  makeus
//
//  Created by 김두리 on 2021/03/01.
//

import Foundation
import Combine
import SwiftUI


class MemeFeed: ObservableObject, RandomAccessCollection {
    typealias Element = MemeImage
    
    @Published var memeImages = [MemeImage]()
    @Published var meme = [UIImage]()
    
    var startIndex: Int { memeImages.startIndex }
    var endIndex: Int { memeImages.endIndex }
    var loadStatus = LoadStatus.ready(nextPage: 1)
    
    var urlBase = "https://test.fofapp.shop/meme/recommend?size=10&page="
    
    init() {
        fetchMeme()
    }
    
    subscript(position: Int) -> MemeImage {
        return memeImages[position]
    }
    
    func fetchMeme(currentItem: MemeImage? = nil) {
        if !shouldLoadMoreData(currentItem: currentItem) {
            return
        }
        guard case let .ready(page) = loadStatus else {
            return
        }
        
        loadStatus = .loading(page: page)
        let urlString = "\(urlBase)\(page)"
        
        var url = URLRequest(url: URL(string: urlString)!)
        url.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEyLCJlbWFpbCI6ImRvaXRkdXJpQGdtYWlsLmNvbSIsImlhdCI6MTYxNDU5NTYxMywiZXhwIjoxNjQ2MTMxNjEzLCJzdWIiOiJ1c2VySW5mbyJ9.Wfsy-jZzV3bicU9dW24iLkPJLJ2N5il4iGX4Iy-z-Cc", forHTTPHeaderField: "x-access-token")
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: parseDataFromResponse(data:response:error:))
        task.resume()
    }
    
    func shouldLoadMoreData(currentItem: MemeImage? = nil) -> Bool {
        guard let currentItem = currentItem else {
            return true
        }
        
        for n in (memeImages.count - 4)...(memeImages.count-1) {
            if n >= 0 && currentItem.memeIdx == memeImages[n].memeIdx {
                return true
            }
        }
        return false
    }
    
    func parseDataFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        
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
        
        let newMemes = parseMemesFromData(data: data)
        print("new memes : \(newMemes)")
        
        DispatchQueue.main.async {
            self.memeImages.append(contentsOf: newMemes)
            if newMemes.count == 0 {
                self.loadStatus = .done
            } else {
                guard case let .loading(page) = self.loadStatus else {
                    fatalError("loadSatus is in a bad state")
                }
                self.loadStatus = .ready(nextPage: page + 1)
                
            }
        }
    }
    
    func parseMemesFromData(data: Data) -> [MemeImage] {
        var response: MemeApiResponse
        do {
            response = try JSONDecoder().decode(MemeApiResponse.self, from: data)
           
        } catch {
            print("Error parsing the JSON: \(error)")
            return []
        }
        
        if !response.isSuccess {
            print("Status is not ok: \(response.code)")
            return []
        }
        
        
        return response.data
    }
    
    enum LoadStatus {
        case ready (nextPage: Int)
        case loading (page: Int)
        case parseError
        case done
    }
    
}

class MemeApiResponse: Codable {
    var data: [MemeImage]
    var isSuccess: Bool
    var code: Int
    var message: String
}

class MemeImage: Identifiable, Codable {
    let memeIdx: Int
    let userIdx: Int
    let profileImage: String?
    let nickname: String
    let imageUrl: String
    let Tag: String
}


/*
class Test: XCTestCase {
    func testDecodeDataModel() {
        let e = expectation(description: "finished expectation")
               let decoder = JSONDecoder()
               let cancellable = Just(data)
                   .decode(type: Response.self, decoder: decoder)
                   .map { $0.data }
                   .sink(receiveCompletion: { (completion) in
                       // handle completion..
                   }, receiveValue: { dataArray in
                       print(dataArray.count) // here you can work with your [DataModel] array
                       e.fulfill()
                   })
               wait(for: [e], timeout: 1)
    }
}
*/
