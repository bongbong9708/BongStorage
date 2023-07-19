//
//  File.swift
//  
//
//  Created by 이상봉 on 2023/07/19.
//

import Foundation
import SwiftUI

extension Color {
    public init(r: CGFloat, g: CGFloat, b: CGFloat, opacity: CGFloat = 1) {
        self.init(red: r/255, green: g/255, blue: b/255, opacity: opacity)
    }
}
