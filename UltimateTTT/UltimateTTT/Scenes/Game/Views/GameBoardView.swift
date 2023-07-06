//
//  GameBoardView.swift
//  UltimateTTT
//
//  Created by Justin Hoang on 7/6/23.
//

import SwiftUI

struct GameBoardView: View {
    let gridSize = 3
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let cellWidth = geometry.size.width / CGFloat(gridSize)
                let cellHeight = geometry.size.height / CGFloat(gridSize)
                
                // vertical lines
                for i in 1..<gridSize {
                    let x = CGFloat(i) * cellWidth
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                }
                
                // horizontal lines
                for i in 1..<gridSize {
                    let y = CGFloat(i) * cellHeight
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
            }
            .stroke(Color.black, lineWidth: 5)
            
            VStack(spacing: 0) {
                ForEach(0..<3) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<3) { column in
                            GridView()
                        }
                    }
                }
            }
        }
    }
}

struct GridView: View {
    let subGridSize = 3
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let subCellWidth = geometry.size.width / CGFloat(subGridSize)
                let subCellHeight = geometry.size.height / CGFloat(subGridSize)
                
                // vertical lines
                for i in 1..<subGridSize {
                    let x = CGFloat(i) * subCellWidth
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                }
                
                // horizontal lines
                for i in 1..<subGridSize {
                    let y = CGFloat(i) * subCellHeight
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
            }
            .stroke(Color.black, lineWidth: 2)
        }
    }
}

struct GameBoardView_Previews: PreviewProvider {
    static var previews: some View {
        GameBoardView()
    }
}
