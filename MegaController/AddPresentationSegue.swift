//
//  AddPresentationSegue.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/17/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

import UIKit

class AddPresentationSegue: UIStoryboardSegue, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

	override func perform() {
		destination.modalPresentationStyle = .overFullScreen
		destination.transitioningDelegate = self
		super.perform()
	}

	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return self
	}

	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return self
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		if transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) is AddViewController {
			let addView = transitionContext.view(forKey: UITransitionContextViewKey.to)
			addView!.alpha = 0
			transitionContext.containerView.addSubview(addView!)
			UIView.animate(withDuration: 0.4, animations: {
				addView!.alpha = 1.0
				}, completion: { didComplete in
					transitionContext.completeTransition(didComplete)
			})
		} else if transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) is AddViewController {
			let addView = transitionContext.view(forKey: UITransitionContextViewKey.from)
			UIView.animate(withDuration: 0.4, animations: {
				addView!.alpha = 0.0
				}, completion: { didComplete in
					transitionContext.completeTransition(didComplete)
			})
		}
	}

	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.4
	}
}
