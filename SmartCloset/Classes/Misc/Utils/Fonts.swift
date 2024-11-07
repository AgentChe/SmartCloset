//
//  Fonts.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

struct Fonts {
    // MARK: SofiaSans
    struct SofiaSans {
        static func black(size: CGFloat) -> UIFont {
            UIFont(name: "SofiaSans-Black", size: size)!
        }
        
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "SofiaSans-Bold", size: size)!
        }
        
        static func extraBold(size: CGFloat) -> UIFont {
            UIFont(name: "SofiaSans-ExtraBold", size: size)!
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "SofiaSans-Medium", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "SofiaSans-Regular", size: size)!
        }
        
        static func semiBold(size: CGFloat) -> UIFont {
            UIFont(name: "SofiaSans-SemiBold", size: size)!
        }
    }
}
