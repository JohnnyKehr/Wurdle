//
//  ContentView.swift
//  Wurdle
//
//  Created by jokehr on 6/20/22.
//

import SwiftUI

enum GameState {
    case inProgress, success, fail
}

class Model: ObservableObject {
    @Published var currentWord: String = ""
    @Published var submittedWords: [String] = []
    @Published var gameState: GameState = .inProgress
    @Published var cellMatches: [[CellMatch]] = Array(repeating: Array(repeating: CellMatch.unknown, count: 5), count: 5)
    @Published var activeRow = 0
    
    private let successWord: String
    init(successWord: String) {
        self.successWord = successWord
    }
    
    func submitWord() {
        guard currentWord.count == 5 else {
            print("word not long enough")
            // TODO: error state?
            return
        }
        let submittedWord = currentWord
        submittedWords.append(submittedWord)
        if submittedWord == successWord {
            gameState = .success
        } else if submittedWords.count == 5 {
            gameState = .fail
        } else {
            currentWord = ""
        }
        generateCellMatches(forSubmittedWord: submittedWord)
        updateActiveRow()
    }
    
    private func generateCellMatches(forSubmittedWord submittedWord: String) {
        print("generating cell matches")
        let rowOfSubmittedWord = submittedWords.count - 1
        
        let submittedChars = Array(submittedWord.lowercased())
        let successChars = Array(successWord.lowercased())
        
        print("submitted: \(submittedChars)")
        print("success: \(successChars)")
        
        for (i, char) in submittedChars.enumerated() {
            let charsEqual = char == successChars[i]
            
            let matchResult: CellMatch
            if charsEqual {
                matchResult = .yes
            } else if successChars.contains(char) {
                matchResult = .somewhereElse
            } else {
                matchResult = .no
            }
            cellMatches[rowOfSubmittedWord][i] = matchResult
        }
        print("submittedWords: \(submittedWords)")
        print("cellMatches: \(cellMatches[rowOfSubmittedWord])")
    }
    
    private func updateActiveRow() {
        switch gameState {
        case .inProgress:
            activeRow += 1
        default:
            print("game over, not updating active row")
            activeRow = -1
        }
    }
}

struct TextFieldLimitModifier: ViewModifier {
    @Binding var value: String
    var limit: Int
    
    func body(content: Content) -> some View {
        content
            .onReceive(value.publisher.collect()) {
                value = String($0.prefix(limit))
            }
    }
}

extension View {
    func limitInputLength(value: Binding<String>, limit: Int) -> some View {
        modifier(TextFieldLimitModifier(value: value, limit: limit))
    }
}

struct ContentView: View {
    @StateObject var model = Model(successWord: "biker")
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            if model.gameState == .success {
                Text("you win!")
            } else if model.gameState == .fail {
                Text("you lose!")
            } else {
                Text("wurdle")
            }
            TextField("", text: $model.currentWord)
                .opacity(0)
                // TODO: for some reason this tanks the performance and the app won't run
                // .limitInputLength(value: $model.currentWord, limit: 5)
                .focused($isFocused).onAppear {
                    // ugly
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isFocused = true
                    }
                }
                .onSubmit {
                    print("Submit")
                    isFocused = false
                    model.submitWord()
                    isFocused = model.gameState == .inProgress
                }
            ForEach(0..<5, id: \.self) { index in
                Row(rowIndex: index, isActive: index == model.activeRow, model: model)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
