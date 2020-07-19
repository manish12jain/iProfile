//
//  String+Extension.swift
//  iProfile
//
//  Created by pc on 7/18/20.
//  Copyright © 2020 Manish Jain. All rights reserved.
//

import Foundation

extension String {
        func fromBase64() -> String? {
                guard let data = Data(base64Encoded: self) else {
                        return nil
                }
                return String(data: data, encoding: .utf8)
        }
        func toBase64() -> String {
                return Data(self.utf8).base64EncodedString()
        }
}
