//
//  Home.swift
//  CryptoCurrency
//
//  Created by Sümeyye Kazancı on 14.07.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct Home: View {
    @State var currentCoin = "BTC"
    @Namespace var animation
    @StateObject var cryptoViewModel = CryptoViewModel()
    var body: some View {
        VStack {
            if let coins = cryptoViewModel.coins,let coin = cryptoViewModel.currentCoin {
                HStack(spacing: 15) {
                    AnimatedImage(url: URL(string: coin.image))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Bitcoin")
                            .font(.callout)
                        Text("BTC")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                CoinsTabView(coins: coins)
                
                GraphView(coin: coin)
            }else {
                ProgressView()
                    .tint(Color.green)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: Coins Segments
    @ViewBuilder
    func CoinsTabView(coins: [CryptoModel]) -> some View {
        ScrollView(.horizontal,showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(coins) { coin in
                    Text(coin.symbol.uppercased())
                        .foregroundColor(currentCoin == coin.symbol.uppercased() ? .white : .gray)
                        .padding(.vertical,6)
                        .padding(.horizontal,10)
                        .background {
                            if currentCoin == coin.symbol.uppercased() {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.gray)
                                    .matchedGeometryEffect(id: "SEGMENTEDTAB", in: animation)
                            }
                        }
                        .onTapGesture {
                            cryptoViewModel.currentCoin = coin
                            withAnimation {
                                currentCoin = coin.symbol.uppercased()
                            }
                        }
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 15,style: .continuous)
                    .stroke(Color.white.opacity(0.4),lineWidth: 2)
            }
        }
        .padding(.vertical)
    }
    
    //MARK: Line Graph
    @ViewBuilder
    func GraphView(coin: CryptoModel) -> some View {
        GeometryReader{ _ in
            LineGraph(data: coin.last7DaysChange.price)
        }
        .padding(.vertical,30)
        .padding(.horizontal,10)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}
