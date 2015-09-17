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
		destinationViewController.modalPresentationStyle = .OverFullScreen
		destinationViewController.transitioningDelegate = self
		super.perform()
	}

	func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return self
	}

	func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return self
	}

	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		if transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) is AddViewController {
			let addView = transitionContext.viewForKey(UITransitionContextToViewKey)
			addView!.alpha = 0
			transitionContext.containerView()!.addSubview(addView!)
			UIView.animateWithDuration(0.4, animations: {
				addView!.alpha = 1.0
				}, completion: { didComplete in
					transitionContext.completeTransition(didComplete)
			})
		} else if transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) is AddViewController {
			let addView = transitionContext.viewForKey(UITransitionContextFromViewKey)
			UIView.animateWithDuration(0.4, animations: {
				addView!.alpha = 0.0
				}, completion: { didComplete in
					transitionContext.completeTransition(didComplete)
			})
		}
	}

	func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
		return 0.4
	}
}
