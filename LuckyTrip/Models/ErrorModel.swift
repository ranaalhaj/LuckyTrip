

import Foundation

// MARK: - ErrorModel
class ErrorModel: Codable {
    var message: String
    var errors: Errors

    init(message: String, errors: Errors) {
        self.message = message
        self.errors = errors
    }
}

// MARK: - Errors
class Errors: Codable {
    var firstName, lastName, email, password: [String]?
    var country, platform: [String]?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email, password, country, platform
    }

    init(firstName: [String]?, lastName: [String]?, email: [String]?, password: [String]?, country: [String]?, platform: [String]?) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.country = country
        self.platform = platform
    }
}
