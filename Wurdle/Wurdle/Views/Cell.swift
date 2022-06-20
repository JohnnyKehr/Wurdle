//
//  Cell.swift
//  Wurdle
//
//  Created by jokehr on 6/20/22.
//

import SwiftUI

enum CellMatch {
    case yes, no, somewhereElse, unknown
    
    var description: String {
        switch self {
            case .yes: return "yes"
            case .no: return "no"
            case .somewhereElse: return "somewhereElse"
            case .unknown: return "unknown"
        }
    }
}

private extension CellMatch {
    var color: Color {
        switch self {
        case .unknown, .no: return .gray
        case .somewhereElse: return .yellow
        case .yes: return .green
        }
    }
}

struct Cell: View {
    var match: CellMatch
    var character: Character?

    var body: some View {
        RoundedRectangle(cornerRadius: 10.0)
            .foregroundColor(match.color)
            .aspectRatio(1.0, contentMode: .fit)
            .overlay {
                Text(overlayText())
                    .foregroundColor(.black)
            }
    }
    
    private func overlayText() -> String {
        if let character = character {
            return String(character)
        }
        return ""
    }
}

struct Cell_Previews: PreviewProvider {
    static var previews: some View {
        Cell(match: .unknown, character: Character("A"))
    }
}
