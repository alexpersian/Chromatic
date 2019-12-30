//
//  JSONDecoder+Helpers.swift
//  Chromatic
//
//  Created by Alex Persian on 12/30/19.
//  Copyright © 2019 alexpersian. All rights reserved.
//

import Alamofire

enum DecoderError: Error {
    case responseError
    case missingData
    case decodingFailed
}

extension JSONDecoder {
    func decodeResponse<T: Decodable>(from response: DataResponse<Data>) -> Result<T> {
        guard response.error == nil else {
            return .failure(DecoderError.responseError)
        }

        guard let responseData = response.data else {
            return .failure(DecoderError.missingData)
        }

        do {
            let item = try decode(T.self, from: responseData)
            return .success(item)
        } catch {
            return .failure(DecoderError.decodingFailed)
        }
    }
}
