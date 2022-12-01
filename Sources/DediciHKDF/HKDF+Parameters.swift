//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Crypto
import Foundation

extension HKDF {
    public struct Parameters<HashFunction: Crypto.HashFunction>: Hashable, Codable {
        public let material: Data
        public let salt: Data
        public let info: Data
        public let outputSize: Int
        public let mode: Mode

        public init(
            from material: Data,
            salt: Data,
            info: Data,
            outputSize: Int,
            mode: Mode = .default
        ) {
            self.material = material
            self.salt = salt
            self.info = info
            self.outputSize = outputSize
            self.mode = mode
        }
    }
}
