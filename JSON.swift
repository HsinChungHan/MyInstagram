//
//  JSON.swift
//  Instagram
//
//  Created by 辛忠翰 on 12/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import UIKit

struct TopLevel: Codable {
    let users: Users
}

struct Users: Codable {
    let the9SNAKFk33SZIlFcNWHZJaDoMO3D2, hgARgMfUWVTAA2FUM4ZmfXizmAz1: The9SNAKFk33SZIlFcNWHZJaDoMO3D2

    enum CodingKeys: String, CodingKey {
        case the9SNAKFk33SZIlFcNWHZJaDoMO3D2 = "9SNAKFk33sZIlFcNWHZJaDoMO3d2"
        case hgARgMfUWVTAA2FUM4ZmfXizmAz1 = "HgARgMfUWVTAA2FUM4zmfXizmAz1"
    }
}

struct The9SNAKFk33SZIlFcNWHZJaDoMO3D2: Codable {
    let email, password, profileImageUrl, userName: String
}

// MARK: Convenience initializers

extension TopLevel {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(TopLevel.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }

    init?(url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension Users {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Users.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }

    init?(url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension The9SNAKFk33SZIlFcNWHZJaDoMO3D2 {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(The9SNAKFk33SZIlFcNWHZJaDoMO3D2.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }

    init?(url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}


