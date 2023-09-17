//
//  AppCoordinator.swift
//  PlentyPost
//
//  Created by Abdelrahman Salah on 16/09/2023.
//

import SwiftUI
import Combine

struct Item: Codable {
    let id: UUID
    let name: String
}
// View
struct ItemListView: View {
    @ObservedObject var viewModel: ItemListViewModel

    var body: some View {
        List(viewModel.items, id: \.id) { item in
            Text(item.title)
        }
    }
}


class ItemListViewModel: ObservableObject {
    @Published var items: [Post] = []
    private var cancellables: Set<AnyCancellable> = []

    private let itemRepository: ItemRepository

    init(itemRepository: ItemRepository) {
        self.itemRepository = itemRepository
        fetchItems()
    }

    func fetchItems() {
        itemRepository.fetchItems()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] item in
                self?.items = item.posts
            })
            .store(in: &cancellables)
    }
}

class AppCoordinator {
//    func start() -> some View {
//        let networkService = NetworkService()
//        let itemRepository = NetworkItemRepository(networkService: networkService)
//        let viewModel = ItemListViewModel(itemRepository: itemRepository)
//        let view = ItemListView(viewModel: viewModel)
//        return view
//    }
}

class NetworkItemRepository: ItemRepository {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchItems() -> AnyPublisher<Welcome, Error> {
        return networkService.fetchData()
    }
}


protocol ItemRepository {
    func fetchItems() -> AnyPublisher<Welcome, Error>
}

class NetworkService {
    func fetchData() -> AnyPublisher<Welcome, Error> {
        let url = URL(string: "https://dummyjson.com/posts")!
        return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap({ res in
                guard let response = res.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode <= 300 else {
                    throw NetworkingError.invalidStatusCode
                }
                let decoder = JSONDecoder()
                guard let fetchedData = try? decoder.decode(Welcome.self, from: res.data) else{
                    throw NetworkingError.failedToDecode
                }
                return fetchedData
            })
            .eraseToAnyPublisher()
    }
}




extension NetworkService {
    enum NetworkingError: LocalizedError {
        case custom(error: Error)
        case failedToDecode
        case invalidStatusCode

        var errorDescription: String? {
            switch self{
            case .custom(error: let error):
                return error.localizedDescription
            case .failedToDecode:
                return "Failed to decode response"
            case .invalidStatusCode:
                return "Request fails within an invalid range"
            }
        }
    }
}

struct AlbumsModel: Codable {
    let userID, id: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title
    }
}


struct Welcome: Codable {
    let posts: [Post]
    let total, skip, limit: Int
}

// MARK: - Post
struct Post: Codable {
    let id: Int
    let title, body: String
    let userID: Int
    let tags: [String]
    let reactions: Int

    enum CodingKeys: String, CodingKey {
        case id, title, body
        case userID = "userId"
        case tags, reactions
    }
}
