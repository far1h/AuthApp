//
//  KeyChainWrapper.swift
//  AuthApp
//
//  Created by Farih Muhammad on 04/11/2025.
//

import Foundation
import Security

/// A tiny, generic Keychain helper that stores any Codable value.
struct Keychain<T: Codable> {

    // MARK: - Create / Update
    /// Saves (or overwrites) a value for the given key.
    static func set(_ value: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(value)

            // Build the query
            let query: [CFString: Any] = [
                kSecClass:            kSecClassGenericPassword,
                kSecAttrAccount:      key,
                kSecValueData:        data
            ]

            // Delete existing data (if any), then add
            SecItemDelete(query as CFDictionary) // Delete existing data (if any)

            let status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                print("Error loading item to keychain \(status)")
            }
        } catch {
            print("Error encoding data: \(error)")
        }
    }

    // MARK: - Read
    /// Retrieves a value for the given key, or nil if not found/decoding fails.
    static func get(_ key: String) -> T? {
        let query: [CFString: Any] = [
            kSecClass:            kSecClassGenericPassword,
            kSecAttrAccount:      key,
            kSecReturnData:       kCFBooleanTrue as Any,
            kSecMatchLimit:       kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == errSecSuccess, let data = item as? Data {
            do {
                let value = try JSONDecoder().decode(T.self, from: data)
                return value
            } catch {
                print("Error decoding data: \(error)")
            }
        }
        return nil
    }

    // MARK: - Delete
    /// Deletes any value stored for the given key. Returns true on success.
    static func delete(_ key: String) -> Bool {
        let query: [CFString: Any] = [
            kSecClass:       kSecClassGenericPassword,
            kSecAttrAccount: key
        ]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}



