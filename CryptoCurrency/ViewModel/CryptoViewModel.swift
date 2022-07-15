//
//  CryptoViewModel.swift
//  CryptoCurrency
//
//  Created by Sümeyye Kazancı on 14.07.2022.
//

import SwiftUI

class CryptoViewModel: ObservableObject {
    @Published var coins: [CryptoModel]?
    @Published var currentCoin: CryptoModel?
    
    init() {
        Task {
            do {
                try await fetchData()
            }catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    // MARK: Fetch CryptoData
    func fetchData() async throws{
        guard let url = url else {
            return
        }
        
        let session = URLSession.shared
        let response = try await session.data(from: url)
        let json = try JSONDecoder().decode([CryptoModel].self, from: response.0)
        
        await MainActor.run(body: {
            self.coins = json
            if let firstCoin = json.first {
                self.currentCoin = firstCoin
            }
        })
    }
}

