//
//  Encodable+Extension.swift
//  Monita
//

import Foundation

extension Encodable {
    var dictionary: Parameter? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? Parameter }
    }
}
