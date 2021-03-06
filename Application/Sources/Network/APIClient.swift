//
//  APIClient.swift
//  Example Project
//
//  Created by David Jennes on 04/01/2017.
//  Copyright © 2019 Appwise. All rights reserved.
//

import Alamofire
import AppwiseCore
import Nuke
import NukeAlamofirePlugin

final class APIClient: Client {
	typealias RouterType = APIRouter

	static let shared = APIClient()

	private(set) lazy var sessionManager: SessionManager = SessionManager().then {
		let retrier = OAuth2RetryHandler(oauth2: OAuth2Grant.grant)
		$0.adapter = retrier
		$0.retrier = retrier
	}

	private(set) lazy var nuke: Nuke.ImagePipeline = Nuke.ImagePipeline {
		$0.dataLoader = NukeAlamofirePlugin.AlamofireDataLoader(manager: self.sessionManager)
	}

	func nukeOptions(placeholder: Image? = nil, transition: ImageLoadingOptions.Transition? = nil, failureImage: Image? = nil, failureImageTransition: ImageLoadingOptions.Transition? = nil, contentModes: ImageLoadingOptions.ContentModes? = nil) -> ImageLoadingOptions {
		var options = ImageLoadingOptions(placeholder: placeholder, transition: transition, failureImage: failureImage, failureImageTransition: failureImageTransition, contentModes: contentModes)
		options.pipeline = nuke
		return options
	}
}
