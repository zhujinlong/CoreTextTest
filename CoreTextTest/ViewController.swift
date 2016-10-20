
import UIKit

class TestView: UIView {
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        
        UIColor.red.set()
        context.fill(bounds)
        
        let rectPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 180, height: 280))
        
        let clipPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 60, height: 60))
        rectPath.append(clipPath.reversing())
        
        context.addPath(rectPath.cgPath)
        UIColor.white.set()
        context.fillPath(using: CGPathFillRule.winding)
        
        context.textMatrix = CGAffineTransform.identity
        context.saveGState()
        context.translateBy(x: 0, y: bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let attributedSring = NSMutableAttributedString(string: "aaaaaadhelloworldhelloworldhelloworldhelloworldhelloworldhelloworldhelloworldhelloworldhelloworldhelloworldhelloworldhelloworldhelloworldhelloworldhelloworldhelloworldhelloworldhelloworldhelloworldhelloworldzzzzzz")
        
        attributedSring.beginEditing()
        let summaryColor = UIColor.black.cgColor
        
        let font = UIFont.systemFont(ofSize: 10)
        let fontRef = CTFontCreateWithName(font.fontName as CFString?, 10, nil)
        attributedSring.addAttribute(kCTFontAttributeName as String, value: fontRef,range: NSMakeRange(0, attributedSring.length))
        attributedSring.addAttribute(kCTForegroundColorAttributeName as String, value: summaryColor, range: NSMakeRange(0, attributedSring.length))
        attributedSring.endEditing()
        
        //this not works, throw exception 'NSInvalidArgumentException', reason: '-[UIBezierPath count]: unrecognized selector sent to instance 0x6180000aa440
        //0x6180000aa440 is object clipPath
        //let cfDict: CFDictionary = [kCTFrameClippingPathsAttributeName as String : clipPath as CFTypeRef] as CFDictionary
        
        let keys: [CFString] = [kCTFrameClippingPathsAttributeName]
        let values: [CFTypeRef] = [clipPath]
        
        let keysPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: keys.count)
        keysPointer.initialize(to: keys)
        
        let valuesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: values.count)
        valuesPointer.initialize(to: values)
        
        let cfDictionary = CFDictionaryCreate(kCFAllocatorDefault, keysPointer, valuesPointer, 1, nil, nil)
        
        let framesetter = CTFramesetterCreateWithAttributedString(attributedSring)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attributedSring.length), rectPath.cgPath, cfDictionary)
        CTFrameDraw(frame, context)
    }
    
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = TestView()
        v.frame = CGRect(x: 50, y: 50, width: 200, height: 300)
        
        view.backgroundColor = .yellow
        view.addSubview(v)
    }

}

