//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation

extension HKDF {
    public enum Mode: String, Hashable, Codable {
        case `default`
        case textSecureV2

        var offset: Int {
            switch self {
            case .default: return 1
            case .textSecureV2: return 0
            }
        }

        var maxBlocksCount: Int {
            switch self {
            case .default: return Int(UInt8.max) - 1
            case .textSecureV2: return Int(UInt8.max)
            }
        }
    }
}
