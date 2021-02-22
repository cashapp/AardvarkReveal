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

import UIKit

final class ViewController: UIViewController {

    override func loadView() {
        view = View()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "AardvarkReveal Demo"
    }

}

// MARK: -

extension ViewController {

    final class View: UIView {

        // MARK: - Life Cycle

        override init(frame: CGRect) {
            super.init(frame: frame)

            instructionLabel.text = "Press and hold with two fingers to compose a bug report."
            instructionLabel.font = .preferredFont(forTextStyle: .largeTitle)
            instructionLabel.numberOfLines = 0
            instructionLabel.textAlignment = .center
            instructionLabel.textColor = .label
            addSubview(instructionLabel)

            backgroundColor = .systemBackground
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: - Private Properties

        private let instructionLabel: UILabel = .init()

        // MARK: - UIView

        override func layoutSubviews() {
            let layoutBounds = bounds.insetBy(dx: 24, dy: 24)
            instructionLabel.bounds.size = instructionLabel.sizeThatFits(layoutBounds.size)
            instructionLabel.center = .init(x: bounds.midX, y: bounds.midY)
        }

    }

}

