//
//  OAuth2Grant.swift
//  Example Project
//
//  Created by David Jennes on 03/07/2019.
//  Copyright © 2019 Appwise. All rights reserved.
//

import p2_OAuth2

enum OAuth2Grant {
	static let grant = OAuth2PasswordGrant(settings: env(
		.dev([
			"client_id": "",
			"client_secret": "",
			"token_uri": "https://test.development.appwi.se/oauth/token"
		]),
		.stg([
			"client_id": "",
			"client_secret": "",
			"token_uri": "https://test.staging.appwi.se/oauth/token"
		]),
		.prd([
			"client_id": "",
			"client_secret": "",
			"token_uri": "https://test.production.appwi.se/oauth/token"
		])
	))
		.then {
			$0.clientConfig.secretInBody = false
			#if DEBUG
			$0.logger = OAuth2DebugLogger(.trace)

			OAuth2Grant.loadTokensFromEnvironment(into: $0)
			#endif
		}

	static var haveValidCredentials: Bool {
		return grant.refreshToken != nil
	}

	private static func loadTokensFromEnvironment(into grant: OAuth2Base) {
		guard let token = TestData.string(.refreshToken) else { return }
		grant.refreshToken = token
	}
}
