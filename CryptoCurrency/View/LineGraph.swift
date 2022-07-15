//
//  LineGraph.swift
//  LineGraphExample
//
//  Created by Sümeyye Kazancı on 12.07.2022.
//

import SwiftUI

struct LineGraph: View {
    var data: [Double]
    @State var currentPlot = ""
    @State var offset: CGSize = .zero
    @State var showPlot = false
    @State var translation: CGFloat = 0
    var body: some View {
        GeometryReader { proxy in
            let width = (proxy.size.width) / CGFloat(data.count - 1)
            let height = proxy.size.height
            let maxPoint = data.max() ?? 0
            let minPoint = data.min() ?? 0
            // Creating points from data
            let points = data.enumerated().compactMap {
                item -> CGPoint in
                let progress = (item.element - minPoint) / (maxPoint - minPoint)
                let pathHeight = progress * (height - 50)
                let pathWidth = CGFloat(item.offset) * width
                return CGPoint(x: pathWidth, y: -pathHeight + height)
            }
            ZStack {
                //
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLines(points)
                }
                .strokedPath(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                .fill(
                    LinearGradient(colors: [
                        Color.blue,
                        Color.green ]
                    , startPoint: .leading, endPoint: .trailing)
                
                )
                
                lineGraphBackground()
                .clipShape(
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLines(points)
                        path.addLine(to: CGPoint(x: proxy.size.width, y: height))
                        path.addLine(to: CGPoint(x: 0, y: height))
                    }
                )
//                .padding(.top,8)
            }
            .overlay (VStack(spacing:0) {
                Text(currentPlot)
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .padding(.vertical,6)
                    .padding(.horizontal,10)
                    .background(Color.green,in: Capsule())
                    .offset(x: translation < 10 ? 30 : 0)
                    .offset(x: translation > (proxy.size.width - 60) ? -30 : 0)
                Rectangle()
                    .fill(Color.green)
                    .frame(width: 1, height: 40)
                    .padding(.top)
                Circle()
                    .fill(Color.green)
                    .frame(width: 22,height: 22)
                    .overlay(
                        Circle()
                            .fill(Color.white)
                            .frame(width: 10, height: 10)
                    )
                Rectangle()
                    .fill(Color.green)
                    .frame(width: 1, height: 45)
            }
                .frame(width: 80,height: 170)
                .offset(y: 70)
                .offset(offset)
                .opacity(showPlot ? 1 : 0)
                      , alignment: .bottomLeading)
            .contentShape(Rectangle())
            .gesture(DragGesture().onChanged({ value in
                withAnimation {showPlot = true}
                let translation = value.location.x - 40
                
                // Getting index
                let index = max(min(Int((translation / width).rounded() + 1),data.count - 1),0)
                currentPlot = "\(data[index])"
                self.translation = translation
                offset = CGSize(width: points[index].x - 40, height: points[index].y - height)
            })
            .onEnded({ value in
                withAnimation {showPlot = false}
            }))
        }
        .overlay(
            VStack(alignment: .leading) {
                let max = data.max() ?? 0
                Text("max \(Int(max))")
                    .font(.caption.bold())
                Spacer()
                Text("0")
                    .font(.caption.bold())
            }
                .frame(maxWidth: .infinity, alignment: .leading)
        )
        .padding(.horizontal,10)
    }
    
    @ViewBuilder
    func lineGraphBackground() -> some View {
        LinearGradient(colors: [
            Color.green.opacity(0.4),
            Color.green.opacity(0.2),
            Color.green.opacity(0.1),
            Color.clear
        ], startPoint: .top, endPoint: .bottom)
    }
}

struct LineGraph_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
