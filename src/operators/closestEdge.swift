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

extension MotionObservableConvertible where T == UIPanGestureRecognizer {

  public func closestEdge(in bounds: CGRect) -> MotionObservable<CGPoint> {
    return asStream()._map {
      var point = $0.location(in: $0.view)
      var velocity = $0.velocity(in: $0.view)

      if point.x < bounds.midX && point.y < bounds.midY {
        // top-left
        if point.y < point.x {
          point.y = bounds.minY
        } else {
          point.x = bounds.minX
        }
      } else if point.x < bounds.midX && point.y >= bounds.midY {
        // bottom-left
        if bounds.height - point.y < point.x {
          point.y = bounds.maxY
        } else {
          point.x = bounds.minX
        }
      } else if point.x > bounds.midX && point.y < bounds.midY {
        // top-right
        if point.y < bounds.width - point.x {
          point.y = bounds.minY
        } else {
          point.x = bounds.maxX
        }
      } else if point.x > bounds.midX && point.y >= bounds.midY {
        // bottom-right
        if bounds.height - point.y < bounds.width - point.x {
          point.y = bounds.maxY
        } else {
          point.x = bounds.maxX
        }
      }

      return point
    }
  }
}
