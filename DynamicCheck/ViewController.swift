//
//  ViewController.swift
//  DynamicCheck
//
//  Created by Alexey Agapov on 24.11.2022.
//

import UIKit

class ViewController: UIViewController {

    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var radialTouchGravityBehaviour = UIFieldBehavior.radialGravityField(position: .zero)
    lazy var collision = UICollisionBehavior(items: views)
    let views = [
        newPin(color: .red),
        newPin(color: .green),
        newPin(color: .blue)
    ]

    lazy var dynamicBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior(items: views)
        views.forEach {
            behavior.addLinearVelocity(
                .init(
                    x: CGFloat.greatestFiniteMagnitude,
                    y: CGFloat.greatestFiniteMagnitude
                ),
                for: $0
            )
        }
        behavior.allowsRotation = false
        behavior.elasticity = 0
        behavior.resistance = .greatestFiniteMagnitude
        behavior.density = 1
        return behavior
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))

        let switchView = UISwitch(frame: .zero, primaryAction: UIAction { _ in
            self.collision.translatesReferenceBoundsIntoBoundary.toggle()
        })

        switchView.center = CGPoint(x: view.center.x, y: 80)
        view.addSubview(switchView)
    }

    @objc private func tap() {
        views.forEach {
            $0.removeFromSuperview()
        }
        animator.removeAllBehaviors()
        createNew()
    }

    private func createNew() {
        views.forEach {
            view.addSubview($0)

            $0.frame = CGRect(x: 0, y: 0, width: .random(in: 80..<400), height: .random(in: 100..<300))
            $0.center = view.center
//                .applying(CGAffineTransform(translationX: CGFloat.random(in: -50..<50), y: CGFloat.random(in: -50..<50)))
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                $0.widthAnchor.constraint(equalToConstant: 30),
//                $0.heightAnchor.constraint(equalToConstant: 30)
//            ])
        }

        animator.addBehavior(collision)
        animator.addBehavior(dynamicBehavior)

//        radialTouchGravityBehaviour.minimumRadius = 100
//        radialTouchGravityBehaviour.falloff = 3
//        animator.addBehavior(radialTouchGravityBehaviour)
    }


//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        radialTouchGravityBehaviour.position = (touches.first?.location(in: view))!
//        animator.addBehavior(radialTouchGravityBehaviour)
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        radialTouchGravityBehaviour.position = (touches.first?.location(in: view))!
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        animator.removeBehavior(radialTouchGravityBehaviour)
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        animator.removeBehavior(radialTouchGravityBehaviour)
//    }
}

private func newPin(color: UIColor) -> UIView {
    let v = UIView()
    v.backgroundColor = color
    return v
}
