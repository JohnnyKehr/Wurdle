//
//  Row.swift
//  Wurdle
//
//  Created by jokehr on 6/20/22.
//

import SwiftUI

struct Row: View {
    @ObservedObject var model: Model
    
    private let rowIndex: Int
    private let isActive: Bool
    
    private var currentWordArray: [Character] {
        let word: String
        if isActive {
            word = model.currentWord
        } else {
            if rowIndex < model.submittedWords.count {
                word = model.submittedWords[rowIndex]
            } else {
                word = ""
            }
        }
        return Array(word.uppercased())
    }
    
    init(rowIndex: Int, isActive: Bool, model: Model) {
        self.rowIndex = rowIndex
        self.isActive = isActive
        self.model = model
    }

    var body: some View {
        HStack {
            ForEach(0..<5, id: \.self) { column in
                Cell(match: model.cellMatches[rowIndex][column] , character: character(forIndex: column))
            }
        }
    }
    
    private func character(forIndex index: Int) -> Character? {
        guard index < currentWordArray.count else { return nil }
        return currentWordArray[index]
    }
}

struct Row_Previews: PreviewProvider {
    static var previews: some View {
        Row(rowIndex: 0, isActive: true, model: Model(successWord: "biker"))
    }
}
