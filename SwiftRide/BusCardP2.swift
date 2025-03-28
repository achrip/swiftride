//
//  BusCard.swift
//  Page2
//
//  Created by Ferdinand Lunardy on 26/03/25.
//
import SwiftUI
import Foundation

struct BusCardDataP2: Identifiable, Decodable {
    let id: UUID
    let number: Int
    var name: String
    let license: String
    let colorName: String
    var color: Color {
        ColorMapper.map(colorName)
    }

    
    enum CodingKeys: String, CodingKey {
        case number = "busNumber"
        case name = "busName"
        case license = "licensePlate"
        case colorName = "busColor"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID()
        number = try container.decode(Int.self, forKey: .number)
        name = try container.decode(String.self, forKey: .name)
        license = try container.decode(String.self, forKey: .license)
        colorName = try container.decode(String.self, forKey: .colorName)
    }
}

func getBusCardsP2() -> [BusCardDataP2] {
    guard let url = Bundle.main.url(forResource: "BusName", withExtension: "json") else {
        print("Bus Name JSON file not found")
        return []
    }
    
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let busCardDataP2 = try decoder.decode([BusCardDataP2].self, from: data)
        return busCardDataP2
    } catch {
        print("Error decoding Bus Stop JSON: \(error)")
            return []
    }
}

struct ColorMapper {
    static func map(_ name: String) -> Color {
        switch name.lowercased() {
        case "yellow": return .yellow
        case "red": return .red
        case "green": return .green
        case "blue": return .blue
        case "orange": return .orange
        case "mint": return .mint
        case "indigo": return .indigo
        case "cyan": return .cyan
        case "purple": return .purple
        case "pink": return .pink
        case "gray": return .gray
        case "black": return .black
        case "white": return .white
        default: return .blue
        }
    }
}


struct BusCardP2: View {
    private let busCardDataP2: [BusCardDataP2] = getBusCardsP2()
    @Binding var isNavToPage3: Bool
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(busCardDataP2) { cardData in
                    HStack {
                        Image(systemName: "bus")
                            .foregroundColor(cardData.color)
                            .font(.system(size: 40))
                            .onTapGesture {
                                isNavToPage3 = true
                            }
                        VStack(alignment: .leading) {
                            Text(cardData.name)
                                .fontWeight(.bold)
                            HStack {
                                Text("No.\(cardData.number)")
                                    .accessibilityLabel("No. \(cardData.number)")
                                    .font(.caption)
                                Text(cardData.license)
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal)
        }
    }
}

#Preview {
    BusCardP2(isNavToPage3: .constant(false))
}
