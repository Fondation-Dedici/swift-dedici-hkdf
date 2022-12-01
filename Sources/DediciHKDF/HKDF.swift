//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Crypto
import Foundation

public enum HKDF {
    public static func deriveSecrets<T>(
        material: Data,
        salt: Data? = nil,
        info: Data? = nil,
        outputType _: T.Type = T.self
    ) throws -> T where T: HKDFOutput {
        guard let salt = salt ?? T.defaultSalt else { throw Error.missingDefaultSalt }
        guard let info = info ?? T.defaultInfo else { throw Error.missingDefaultInfo }

        let parameters = Parameters<T.HashFunction>(
            from: material,
            salt: salt,
            info: info,
            outputSize: T.outputSize,
            mode: T.mode
        )

        return try .init(derivedKey: deriveSecrets(from: parameters))
    }

    public static func deriveSecrets<HashFunction>(
        from parameters: Parameters<HashFunction>
    ) throws -> Data where HashFunction: Crypto.HashFunction {
        let prk = derivePrk(from: parameters.material, using: parameters.salt, hashFunction: HashFunction.self)
        return try expand(
            prk: prk,
            info: parameters.info,
            outputSize: parameters.outputSize,
            hashFunction: HashFunction.self,
            mode: parameters.mode
        )
    }

    private static func derivePrk<HashFunction>(
        from material: Data,
        using salt: Data,
        hashFunction _: HashFunction.Type = HashFunction.self
    ) -> SymmetricKey where HashFunction: Crypto.HashFunction {
        let key = SymmetricKey(data: salt)
        let derivedKey = HMAC<HashFunction>.authenticationCode(for: material, using: key)
        return SymmetricKey(data: derivedKey)
    }

    private static func expand<HashFunction>(
        prk: SymmetricKey,
        info: Data,
        outputSize: Int,
        hashFunction _: HashFunction.Type = HashFunction.self,
        mode: Mode = .default
    ) throws -> Data where HashFunction: Crypto.HashFunction {
        let blockSize = HashFunction.Digest.byteCount
        let blocksCount = Int(ceil(Double(outputSize) / Double(blockSize)))
        guard blocksCount <= mode.maxBlocksCount else {
            throw Error.requestedOutputSizeIsTooBig(
                hashFunctionName: "\(HashFunction.self)",
                maxOutputSize: mode.maxBlocksCount * blockSize,
                requestedOutputSize: blocksCount * blockSize
            )
        }

        var output = Data()
        output.reserveCapacity(blocksCount * blockSize)
        var block = Data()
        block.reserveCapacity(blockSize)

        for blockIndex in mode.offset ..< (blocksCount + mode.offset) {
            block += info
            block += [UInt8(blockIndex)]

            let bytes = HMAC<HashFunction>.authenticationCode(for: block, using: prk)
            output += bytes
            block = Data(bytes)
        }

        guard output.count >= outputSize else {
            throw Error.generatedOutputTooShort(expectedLength: outputSize, actualLength: output.count)
        }

        return .init(output.prefix(outputSize))
    }
}
