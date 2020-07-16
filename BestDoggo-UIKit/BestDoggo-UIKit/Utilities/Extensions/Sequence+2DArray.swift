//
//  Sequence+2DArray.swift
//  BestDoggo-UIKit
//
//  Created by Chris McLearnon on 16/07/2020.
//  Copyright © 2020 chrismclearnon. All rights reserved.
//

import Foundation

extension Sequence {
    func clump(by clumpsize:Int) -> [[Element]] {
        let slices : [[Element]] = self.reduce(into:[]) {
            memo, cur in
            if memo.count == 0 {
                return memo.append([cur])
            }
            if memo.last!.count < clumpsize {
                memo.append(memo.removeLast() + [cur])
            } else {
                memo.append([cur])
            }
        }
        return slices
    }
}
