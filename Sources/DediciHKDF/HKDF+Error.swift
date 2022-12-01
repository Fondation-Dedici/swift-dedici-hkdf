//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Crypto
import Foundation

extension HKDF {
    public enum Error: Swift.Error {
        case failedToGenerateOutput
        case missingDefaultInfo
        case missingDefaultSalt
        case generatedOutputTooShort(expectedLength: Int, actualLength: Int)
        case requestedOutputSizeIsTooBig(
            hashFunctionName: String,
            maxOutputSize: Int,
            requestedOutputSize: Int
        )
    }
}
