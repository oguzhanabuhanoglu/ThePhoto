//
//  Extensions.swift
//  ThePhoto
//
//  Created by Oğuzhan Abuhanoğlu on 6.01.2024.
//

import Foundation

//encode edilen datayı [string : any] dictionary yapacak.firestore verilerini işlemek için.
extension Encodable {
    func asDictionary() -> [String : Any]? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String : Any]
        return json
    }
}

extension Decodable {
    init?(with dictionary : [String : Any]){
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) else {
            return nil
        }
        guard let result = try? JSONDecoder().decode(Self.self, from: data) else {
            return nil
        }
        self = result
    }
}

extension DateFormatter {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

extension String {
    static func dateString(from date: Date) -> String? {
        let formatter = DateFormatter.formatter
        let string = formatter.string(from: date)
        return string
    }
}
