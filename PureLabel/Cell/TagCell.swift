//
//  TagCell.swift
//  PureLabel
//
//  Created by 송채영 on 9/28/24.
//

import UIKit
import SnapKit
import Then

class TagCell: UICollectionViewCell {
    
    static let cellIdentifier = "tagCell"
    
    override var isSelected: Bool{
            didSet{
                if isSelected{
                    tagLabel.backgroundColor = UIColor.textDarkBrown
                    tagLabel.textColor = UIColor.white
                    
                }
                else{
                    tagLabel.backgroundColor = UIColor.bgColor
                    tagLabel.textColor = UIColor.textDarkBrown
                    
                }
            }
        }
    
    
    lazy var tagLabel = cellPaddingLabel().then{
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textAlignment = .center
        $0.layer.cornerRadius = 14
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.textDarkBrown.cgColor
        $0.backgroundColor = .bgColor
    }
    
   
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.contentView.addSubview(tagLabel)
        
        self.snp.makeConstraints{ make in
            make.width.height.equalTo(tagLabel)
        }
        self.contentView.snp.makeConstraints{ make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        tagLabel.snp.makeConstraints{ make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBtnAttribute(title:String,color: UIColor){
        tagLabel.text = title
        tagLabel.textColor = .black
        
    }
}

class cellPaddingLabel: UILabel {
    var padding = UIEdgeInsets(top: 4, left: 12, bottom: 4, right:12)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
            var contentSize = super.intrinsicContentSize
            contentSize.height += padding.top + padding.bottom
            contentSize.width += padding.left + padding.right
            
            return contentSize
        }
}

