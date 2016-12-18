/*
 Copyright 2016-present The Material Motion Authors. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation

extension ExtendableMotionObservable where T: UIPanGestureRecognizer {

  /**
   Adds the current translation to the initial position and emits the result while the gesture
   recognizer is active.
   */
  func translated<P: ScopedReadable>(from initialPosition: P, in view: UIView) -> MotionObservable<CGPoint> where P.T == CGPoint {
    var cachedInitialPosition: CGPoint?
    return _nextOperator { value, next in
      if value.state == .began || (value.state == .changed && cachedInitialPosition == nil)  {
        cachedInitialPosition = initialPosition.read()
      } else if value.state != .began && value.state != .changed {
        cachedInitialPosition = nil
      }
      if let cachedInitialPosition = cachedInitialPosition {
        let translation = value.translation(in: view)
        next(CGPoint(x: cachedInitialPosition.x + translation.x,
                     y: cachedInitialPosition.y + translation.y))
      }
    }
  }

  /**
   Adds the current translation to the initial position and emits the result while the gesture
   recognizer is active.
   */
  func translation(in view: UIView) -> MotionObservable<CGPoint> {
    var cachedInitialPosition: CGPoint?
    return _map { value in
      value.translation(in: view)
    }
  }
}