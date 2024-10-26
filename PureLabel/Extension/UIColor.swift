//
//  UIColor.swift
//  PureLabel
//
//  Created by 송채영 on 9/25/24.
//

import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    static let bgColor = UIColor(hex:"#F6F3F3")
    static let lightGray = UIColor(hex:"#D5D5D5")
    static let textGray = UIColor(hex:"#BEBEBE")
    static let errRed = UIColor(hex:"#D34B3B")
    static let buttonBgColor = UIColor(hex: "#4B4B4B")
    static let buttonBgColor_inactive = UIColor(hex: "#D9D9D9")
    static let textButtonColor = UIColor(hex: "#999999")
    static let textBlack = UIColor(hex: "#201F21")
    static let textDarkBrown = UIColor(hex: "#525252")
    static let white = UIColor(hex: "#ffffff")
    static let black = UIColor(hex: "#000000")
    static let lightDarkBrown = UIColor(hex: "#636366")
    static let imgBgColor = UIColor(hex: "#F1EDED")
    static let profileBgColor = UIColor(hex: "#929292")
    static let subBgColor = UIColor(hex: "#F1EDED")
    
    
    //무드보드 선택 컬러
    static let green = UIColor(hex: "#459A57")
    static let orange = UIColor(hex: "#F2A140")
    static let red = UIColor(hex: "#D34B3B")
    
    static let color0 = UIColor(hex: "#6C6C6C", alpha: 0.8)
    
    static let rankingColorList : [UIColor] = [green,orange,red]
}
