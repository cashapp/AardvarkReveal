//
//  Copyright 2021 Square, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Aardvark
import AardvarkMailUI
import AardvarkReveal
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - UIWindowSceneDelegate

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let viewController = ViewController()
        let navigationController = UINavigationController(rootViewController: viewController)

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window

        setUpRevealBugReportGesture()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        log("Scene did become active")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        log("Scene will resign active")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        log("Scene will enter the foreground")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        log("Scene did enter the background")
    }

    // MARK: - Private Properties

    private var bugReporter: ARKBugReporter?

    private var revealAttachmentGenerator: RevealAttachmentGenerator?

    // MARK: - Private Methods

    private func setUpRevealBugReportGesture() {
        let revealAttachmentGenerator = RevealAttachmentGenerator()
        self.revealAttachmentGenerator = revealAttachmentGenerator

        let bugReporter = ARKEmailBugReporter(
            emailAddress: "fake-email@aardvarkbugreporting.src",
            logStore: ARKLogDistributor.default().defaultLogStore
        )

        // In order to include the Reveal attachment, we'll use a custom prompt that is delayed until the attachment has
        // been generated.
        bugReporter.promptingDelegate = self

        let gestureRecognizer = Aardvark.add(
            bugReporter: bugReporter,
            triggeringGestureRecognizerClass: UILongPressGestureRecognizer.self
        )
        gestureRecognizer?.numberOfTouchesRequired = 2
    }

}

// MARK: -

extension SceneDelegate: ARKEmailBugReporterPromptingDelegate {

    func showBugReportingPrompt(
        for configuration: ARKEmailBugReportConfiguration,
        completion: @escaping ARKEmailBugReporterCustomPromptCompletionBlock
    ) {
        // To help avoid getting the Reveal bundle in an inconsistent state, we'll disable user interaction while the
        // bundle is being generated.
        self.window?.isUserInteractionEnabled = false

        revealAttachmentGenerator?.captureCurrentAppState(completionQueue: .main) { attachment in
            self.window?.isUserInteractionEnabled = true

            if let attachment = attachment {
                configuration.additionalAttachments.append(attachment)
            }

            self.presentPrompt(for: configuration, completion: completion)
        }
    }

    private func presentPrompt(
        for configuration: ARKEmailBugReportConfiguration,
        completion: @escaping ARKEmailBugReporterCustomPromptCompletionBlock
    ) {
        let alertController = UIAlertController(
            title: "What Went Wrong?",
            message: "Please briefly summarize the issue you just encountered. You’ll be asked for more details later.",
            preferredStyle: .alert
        )

        alertController.addAction(
            .init(
                title: "Compose Report",
                style: .default,
                handler: { _ in
                    if let textField = alertController.textFields?.first {
                        configuration.prefilledEmailSubject = textField.text ?? ""
                    }
                    completion(configuration)
                }
            )
        )

        alertController.addAction(
            .init(
                title: "Cancel",
                style: .cancel,
                handler: { _ in
                    completion(nil)
                }
            )
        )

        alertController.addTextField { textField in
            textField.autocapitalizationType = .sentences
            textField.autocorrectionType = .yes
            textField.spellCheckingType = .yes
            textField.returnKeyType = .done
        }

        window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }

}
