//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Crypto
import Foundation

public protocol HKDFOutput: Codable, Hashable {
    associatedtype HashFunction: Crypto.HashFunction = SHA256

    static var outputSize: Int { get }
    static var mode: HKDF.Mode { get }
    static var defaultSalt: Data? { get }
    static var defaultInfo: Data? { get }

    static func calculate(from material: Data, salt: Data?, info: Data?) throws -> Self

    init(derivedKey: Data) throws
}

extension HKDFOutput {
    public static var defaultSalt: Data? { nil }
    public static var defaultInfo: Data? { nil }
    public static var mode: HKDF.Mode { .default }

    public static func calculate(from material: Data, salt: Data? = nil, info: Data? = nil) throws -> Self {
        try HKDF.deriveSecrets(material: material, salt: salt, info: info)
    }
}
