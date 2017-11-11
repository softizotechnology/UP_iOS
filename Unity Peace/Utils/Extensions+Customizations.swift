

import UIKit
import MBProgressHUD

public extension UIDevice {
    
    enum DeviceCategory {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case iPad
    }
    func deviceCategory() ->  DeviceCategory{
        let height = UIScreen.main.bounds.size.height
        switch height {
        case 480:
            return .iPhone4
        case 568:
            return .iPhone5
        case 667:
            return .iPhone6
        case 736:
            return .iPhone6Plus
        default:
            return .iPad
        }
    }
}

public extension UITextField {
    func isEmpty () -> Bool {
        return !self.hasText
    }
    
    func containsEmail () -> Bool {
        if let text = self.text {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: text)
        } else {
            return false
        }
    }
    
    func containsPhoneNumber () -> Bool {
        if let text = self.text {
            let pnRegEx = "^\\d{3}-\\d{3}-\\d{4}$"
            let pnTest = NSPredicate(format:"SELF MATCHES %@", pnRegEx)
            return pnTest.evaluate(with: text)
        } else {
            return false
        }
    }
    
    func setLeftView() {
        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 10.0, height: 10))
        self.leftView = view1
        self.leftViewMode = .always
    }
    
    func setUpDoneAccessoryButton () {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.resignFirstResponder))
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolbar.items = [flexibleSpace,doneButton]
        self.inputAccessoryView = toolbar
    }
    
    func setUpNextAccessoryButton () {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: self.getLocalizedString("Next"), style: .plain, target: self, action: #selector(self.resignFirstResponder))
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolbar.items = [flexibleSpace, doneButton]
        self.inputAccessoryView = toolbar
    }
    
    
    func setUpRightDownArrow () {
       self.setUpRightView(withImageName: "IcnDownArrow")
    }
    
    func setUpRightView(withImageName : String) {
        let downArrowImage = UIImage(named : withImageName)
        let downArrowImageView  = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        downArrowImageView.contentMode = .left
        downArrowImageView.image = downArrowImage
        self.rightView = downArrowImageView
        self.rightViewMode = .always

    }
    
}

public extension UIViewController {
    func showAlertWithTitle(_ title: String?, msg: String?, positiveTitle: String?, negativeTitle: String?, positiveHandler: (() -> Void)? = nil, negativeHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let positiveAction = UIAlertAction(title: positiveTitle, style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            if let _ = positiveHandler {
                positiveHandler!()
            }
        })
        alert.addAction(positiveAction)
        let negativeAction = UIAlertAction(title: negativeTitle, style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            if let _ = negativeHandler {
                negativeHandler!()
            }
        })
        alert.addAction(negativeAction)
        self.present(alert, animated: true, completion:nil)
    }
    
    func showAlert(_ title: String?, msg: String?, dismissBtnTitle: String?, dismissHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let positiveAction = UIAlertAction(title: dismissBtnTitle, style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            if let _ = dismissHandler {
                dismissHandler!()
            }
        })
        alert.addAction(positiveAction)
        self.present(alert, animated: true, completion:nil)
    }
    
    func handleError (error : NSError) {
        self.showAlert("Error!", msg: error.localizedDescription, dismissBtnTitle: "Dismiss")
    }
    
    func setUpBackButton () {
        let backButton = UIBarButtonItem(image: UIImage(named: "IconBack"), style: .plain, target: self, action: #selector(self.pop))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func pop () {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func setUpCloseButton () {
        let closeButton = UIBarButtonItem(image: UIImage(named: "IconClose"), style: .plain, target: self, action: #selector(self.dismissController))
        self.navigationItem.leftBarButtonItem = closeButton
    }
    
    func dismissController () {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func runOnUIThread(_ block: @escaping () -> Void) {
        DispatchQueue.main.async(execute: block)
    }
    
    func showProgress () {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    func hideProgress () {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    

    func callNumber(phoneNumber:String) {
        if let phoneCallURL: URL = URL(string:"tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    application.openURL(phoneCallURL)
                }
            }else {
                self.showAlert("Error!", msg: "Call Not Supported.", dismissBtnTitle: "Ok")
            }
        }
    }
    
    /*
    func openURL (url : String?) {
        let vc = INWebViewController(nibName: "INWebViewController", bundle: nil)
        vc.url = url
        let nvc = INNavigationController(rootViewController: vc)
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.rootViewController().present(nvc, animated: true, completion: nil)
    }
    
    func openURL (url : String?, screenTitle : String?) {
        let vc = INWebViewController(nibName: "INWebViewController", bundle: nil)
        vc.title = screenTitle
        vc.url = url
        let nvc = INNavigationController(rootViewController: vc)
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.rootViewController().present(nvc, animated: true, completion: nil)
    }
    
    
    
    func showOptionsSelection (options : [String], completion :((Int) -> Void)?) {
        let vc = ShowOptionsViewController(nibName: "ShowOptionsViewController", bundle: nil)
        vc.options = options
        vc.finishBlock = completion
        let nvc = INNavigationController(rootViewController: vc)
        self.present(nvc, animated: true, completion: nil)
    }
 */
}


public extension UIView {
    func makeCornerRound () {
        self.layer.cornerRadius = 5.0
    }
    
    func makeCornerOval () {
        self.layer.cornerRadius = self.bounds.size.height / 2.0
    }
    
    func runOnUIThread(_ block: @escaping () -> Void) {
        DispatchQueue.main.async(execute: block)
    }
    
    func setBorder(width: CGFloat, color : UIColor){
        self.layer.borderWidth = 1.0
        self.layer.borderColor = color.cgColor
    }
    
    func makeRound () {
        self.layer.cornerRadius = self.bounds.size.width / 2.0
    }
    
    func putShadow () {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 1, height: 5)
        self.layer.shadowRadius = 10.0
    }
    
    func createGradientLayer(colors : [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        gradientLayer.colors = colors
        gradientLayer.cornerRadius = self.frame.width / 2
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

    
    func centreArcPerpendicular(text str: String, context: CGContext, radius r: CGFloat, angle theta: CGFloat, colour c: UIColor, font: UIFont, clockwise: Bool){
        // *******************************************************
        // This draws the String str around an arc of radius r,
        // with the text centred at polar angle theta
        // *******************************************************
        
        let l = str.characters.count
        let attributes = [NSFontAttributeName: font]
        
        let characters: [String] = str.characters.map { String($0) } // An array of single character strings, each character in str
        var arcs: [CGFloat] = [] // This will be the arcs subtended by each character
        var totalArc: CGFloat = 0 // ... and the total arc subtended by the string
        
        // Calculate the arc subtended by each letter and their total
        for i in 0 ..< l {
            arcs += [chordToArc(characters[i].size(attributes: attributes).width, radius: r)]
            totalArc += arcs[i]
        }
        
        // Are we writing clockwise (right way up at 12 o'clock, upside down at 6 o'clock)
        // or anti-clockwise (right way up at 6 o'clock)?
        let direction: CGFloat = clockwise ? -1 : 1
        let slantCorrection = clockwise ? -CGFloat(Double.pi / 2) : CGFloat(Double.pi / 2)
        
        // The centre of the first character will then be at
        // thetaI = theta - totalArc / 2 + arcs[0] / 2
        // But we add the last term inside the loop
        var thetaI = theta - direction * totalArc / 2
        
        for i in 0 ..< l {
            thetaI += direction * arcs[i] / 2
            // Call centerText with each character in turn.
            // Remember to add +/-90º to the slantAngle otherwise
            // the characters will "stack" round the arc rather than "text flow"
            centre(text: characters[i], context: context, radius: r, angle: thetaI, colour: c, font: font, slantAngle: thetaI + slantCorrection)
            // The centre of the next character will then be at
            // thetaI = thetaI + arcs[i] / 2 + arcs[i + 1] / 2
            // but again we leave the last term to the start of the next loop...
            thetaI += direction * arcs[i] / 2
        }
    }
    
    func chordToArc(_ chord: CGFloat, radius: CGFloat) -> CGFloat {
        // *******************************************************
        // Simple geometry
        // *******************************************************
        return 2 * asin(chord / (2 * radius))
    }
    
    func centre(text str: String, context: CGContext, radius r:CGFloat, angle theta: CGFloat, colour c: UIColor, font: UIFont, slantAngle: CGFloat) {
        // *******************************************************
        // This draws the String str centred at the position
        // specified by the polar coordinates (r, theta)
        // i.e. the x= r * cos(theta) y= r * sin(theta)
        // and rotated by the angle slantAngle
        // *******************************************************
        
        // Set the text attributes
        let attributes = [NSForegroundColorAttributeName: c,
                          NSFontAttributeName: font]
        // Save the context
        context.saveGState()
        // Undo the inversion of the Y-axis (or the text goes backwards!)
        context.scaleBy(x: 1, y: -1)
        // Move the origin to the centre of the text (negating the y-axis manually)
        context.translateBy(x: r * cos(theta), y: -(r * sin(theta)))
        // Rotate the coordinate system
        context.rotate(by: -slantAngle)
        // Calculate the width of the text
        let offset = str.size(attributes: attributes)
        // Move the origin by half the size of the text
        context.translateBy (x: -offset.width / 2, y: -offset.height / 2) // Move the origin to the centre of the text (negating the y-axis manually)
        // Draw the text
        str.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
        // Restore the context
        context.restoreGState()
    }
    
    func drawRotatedText(_ text: String, at p: CGPoint, angle: CGFloat, font: UIFont, color: UIColor) {
        // Draw text centered on the point, rotated by an angle in degrees moving clockwise.
        let attrs = [NSFontAttributeName: font, NSForegroundColorAttributeName: color]
        let textSize = text.size(attributes: attrs)
        let c = UIGraphicsGetCurrentContext()!
        c.saveGState()
        // Translate the origin to the drawing location and rotate the coordinate system.
        c.translateBy(x: p.x, y: p.y)
        c.rotate(by: angle * .pi / 180)
        // Draw the text centered at the point.
        text.draw(at: CGPoint(x: -textSize.width / 2, y: -textSize.height / 2), withAttributes: attrs)
        // Restore the original coordinate system.
        c.restoreGState()
    }


    
}

public extension NSObject {
    func getString(_ object: NSDictionary?, key: String) -> String? {
        return object?[key] as? String
    }
    
    func getInt(_ object: NSDictionary?, key: String) -> Int {
        let val = object?[key as NSString] as? Int
        if nil == val {
            return 0
        }
        return val!
    }
    
    func getInt64(_ object: NSDictionary?, key: String) -> Int64 {
        let val = object?[key as NSString] as? Int64
        if nil == val {
            return 0
        }
        return val!
    }
    
    func getDouble(_ object: NSDictionary?, key: String) -> Double {
        let val = object?[key as NSString] as? Double
        if nil == val {
            return 0
        }
        return val!
    }
    
    func getFloat(_ object: NSDictionary?, key: String) -> Float {
        let val = object?[key as NSString] as? Float
        if nil == val {
            return 0
        }
        return val!

    }

    
    func getBool(_ object: NSDictionary?, key: String) -> Bool {
        let val = object? [key as NSString] as? Bool
        if nil == val {
            return false
        }
        return val!
    }
    
    func getBoolFromString(_ object: NSDictionary?, key: String) -> Bool {
        let val = object? [key as NSString] as? String
        if nil == val {
            return false
        }
        let isBlock = Int(val! as String)
        return isBlock != 0
    }
    
    func getObject(_ object: NSDictionary?, key: String) -> NSDictionary? {
        return object?[key as NSString] as? NSDictionary
    }
    
    func getArray(_ object: NSDictionary?, key: String) -> [NSDictionary]? {
        return object?[key as NSString] as? [NSDictionary]
    }
    
    func getLocalizedString( _ key: String) -> String {
        return NSLocalizedString(key, comment: key)
    }
    
    func isStringEmpty (string : String?) -> Bool {
        if string == nil || string == "" {
            return true
        }
        return false
    }
}

extension UITextView
{
    func addImage(imageName: String)
    {
        let attachment:NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        attachment.bounds = CGRect(x: -100, y: -100, width: 100, height: 80)
        let attachmentString:NSAttributedString = NSAttributedString(attachment: attachment)
        let myString:NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
        myString.replaceCharacters(in: NSRange(location : 0, length : 1), with: attachmentString)
        self.attributedText = myString
    }
}

class Util {
    
    class func stringForDate (aDate : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.string(from: aDate)
        return date
    }
    
    class func dateFromString (dateString : String ) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from: dateString)
    }

    class func webDateFromString (dateString : String ) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: dateString)
    }
    
    class func dateTimestringForDate (aDate : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        let date = dateFormatter.string(from: aDate)
        return date
    }

    class func openURL (url : String?) {
        
    }
    
    class func getLocalizedString( _ key: String) -> String {
        return NSLocalizedString(key, comment: key)
    }
    
    class func serverTime(timeString : String?) -> String{
        guard let _ = timeString else {
            return ""
        }
        let components = timeString!.components(separatedBy: "T")
        if components.count == 2 {
            let t = components.first
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: t!)
            
            let time = components[1].components(separatedBy: ".").first
            return Util.stringForDate(aDate: date!) + " " + time!
        }
        return ""
        
    }

}

extension Date {
    func getDaysInMonth() -> Int{
        let calendar = Calendar.current
        
        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        return numDays
    }
}

extension String {
    
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }
    
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func matchesPattern(pattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern,
                                                options: NSRegularExpression.Options(rawValue: 0))
            let range: NSRange = NSMakeRange(0, self.characters.count)
            let matches = regex.matches(in: self, options: NSRegularExpression.MatchingOptions(), range: range)
            return matches.count > 0
        } catch _ {
            return false
        }
    }
}

//MARK: Customization

class BorderedTextField: UITextField {
    override func awakeFromNib() {
        self.setup()
    }
    
    func setup(){
        self.setLeftView()
        self.setBorder(width: 1.0, color: Constants.DefaultBorderColor)
        self.makeCornerRound()
    }
}

class RoundedCornerButton : UIButton {
    override func awakeFromNib() {
        self.setup()
    }
    
    func setup(){
        self.makeCornerRound()
        switch UIDevice.current.deviceCategory() {
        case .iPhone4, .iPhone5:
            self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        default:
            self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        }
    }
}

class TitleLabel : UILabel {
    override func awakeFromNib() {
        self.setup()
    }
    
    func setup(){
        switch UIDevice.current.deviceCategory() {
        case .iPhone4, .iPhone5:
            self.font = UIFont.systemFont(ofSize: 13)
        default:
            self.font = UIFont.systemFont(ofSize: 15)
        }
    }
}

class ValueLabel : UILabel {
    override func awakeFromNib() {
        self.setup()
    }
    
    func setup(){
        switch UIDevice.current.deviceCategory() {
        case .iPhone4, .iPhone5:
            self.font = UIFont.systemFont(ofSize: 12.0)
        default:
            self.font = UIFont.systemFont(ofSize: 14.0)
        }
    }
}

class ValueMediumLabel : UILabel {
    override func awakeFromNib() {
        self.setup()
    }
    
    func setup(){
        switch UIDevice.current.deviceCategory() {
        case .iPhone4, .iPhone5:
            self.font = UIFont(name: "HelveticaNeue-Medium", size: 12)!
        default:
            self.font = UIFont(name: "HelveticaNeue-Medium", size: 14)!
        }
    }
}


class ValueSmallLabel : UILabel {
    override func awakeFromNib() {
        self.setup()
    }
    
    func setup(){
        switch UIDevice.current.deviceCategory() {
        case .iPhone4, .iPhone5:
            self.font = UIFont.systemFont(ofSize: 10.0)
        default:
            self.font = UIFont.systemFont(ofSize: 12.0)
        }
    }
}


class ValueBoldLabel : UILabel {
    override func awakeFromNib() {
        self.setup()
    }
    
    func setup(){
        switch UIDevice.current.deviceCategory() {
        case .iPhone4, .iPhone5:
            self.font = UIFont.boldSystemFont(ofSize: 12.0)
        default:
            self.font = UIFont.boldSystemFont(ofSize: 14.0)
        }
    }
}

class DashboardLabel : UILabel {
    override func awakeFromNib() {
        self.setup()
    }
    
    func setup(){
        switch UIDevice.current.deviceCategory() {
        case .iPhone4, .iPhone5:
            self.font = UIFont.systemFont(ofSize: 12.0)
        default:
            self.font = UIFont.systemFont(ofSize: 16.0)
        }
    }
}

class DashboardGreenLabel : UILabel {
    override func awakeFromNib() {
        self.setup()
    }
    
    func setup(){
        switch UIDevice.current.deviceCategory() {
        case .iPhone4, .iPhone5:
            self.font = UIFont.systemFont(ofSize: 20.0)
        default:
            self.font = UIFont.systemFont(ofSize: 25.0)
        }
    }
}

class MenuView : UIView {
    override func awakeFromNib() {
        self.setUp()
    }
    
    func setUp() {
        self.makeCornerRound()
        self.backgroundColor = UIColor(red: 75.0/255.0, green: 115/255.0, blue: 190/255.0, alpha: 1)
    }
}


class TextField: UITextField {
    override var placeholder: String? {
        didSet {
            let placeholderString = NSAttributedString(string: placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.white])
            self.attributedPlaceholder = placeholderString
        }
    }
}

class InputTextField : UITextField {
    
    enum TextMode {
        case Black
        case Red
        case Gray
        case Blue
    }
    
    var mode : TextMode = .Gray {
        didSet {
            switch mode {
            case .Black:
                self.textColor = .black
            case .Gray:
                self.textColor = Constants.GrayColor
            case .Red:
                self.textColor = Constants.RedColor
            case .Blue:
                self.textColor = Constants.BlueColor
            }
        }
    }
    
    override func awakeFromNib() {
        self.setup()
    }
    
    func setup(){
        switch UIDevice.current.deviceCategory() {
        case .iPhone4, .iPhone5:
            self.font = UIFont.boldSystemFont(ofSize: 12.0)
        default:
            self.font = UIFont.boldSystemFont(ofSize: 14.0)
        }
    }
    
    override var placeholder: String? {
        didSet {
            let placeholderString = NSAttributedString(string: placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.black])
            self.attributedPlaceholder = placeholderString
        }
    }
}

class Constants: NSObject {
    
    static let NavigationBarTintColor = UIColor(red: 65/255.0, green: 160/255.0, blue: 235/255.0, alpha: 1.0)
    static let DefaultBorderColor = UIColor(red: 254/255.0, green: 207/255.0, blue: 124/255.0, alpha: 1)
    static let RedColor = UIColor(red: 231/255.0, green: 77/255.0, blue: 61/255.0, alpha: 1)
    static let BlueColor = UIColor(red: 3/255.0, green: 168/255.0, blue: 244/255.0, alpha: 1)
    static let GrayColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
    static let SemiTransparentGrayColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 0.5)
    static let GreenColor = UIColor(red: 6/255.0, green: 198/255.0, blue: 174/255.0, alpha: 1)
    static let DefaultOrangeColor = UIColor(red: 243/255.0, green: 135/255.0, blue: 50/255.0, alpha: 1)
    
}

extension Date {
    
    public var timeAgo: String {
        let components = self.dateComponents()
        
        if components.year! > 0 {
            if components.year! < 2 {
                return NSDateTimeAgoLocalizedStrings("NT_LAST_YEAR")
            } else {
                return stringFromFormat("%%d %@years ago", withValue: components.year!)
            }
        }
        
        if components.month! > 0 {
            if components.month! < 2 {
                return NSDateTimeAgoLocalizedStrings("NT_LAST_MONTH")
            } else {
                return stringFromFormat("%%d %@months ago", withValue: components.month!)
            }
        }
        
        // TODO: localize for other calanders
        if components.day! >= 7 {
            let week = components.day!/7
            if week < 2 {
                return NSDateTimeAgoLocalizedStrings("NT_LAST_WEEK")
            } else {
                return stringFromFormat("%%d %@weeks ago", withValue: week)
            }
        }
        
        if components.day! > 0 {
            if components.day! < 2 {
                return NSDateTimeAgoLocalizedStrings("NT_YESTERDAY")
            } else  {
                return stringFromFormat("%%d %@days ago", withValue: components.day!)
            }
        }
        
        if components.hour! > 0 {
            if components.hour! < 2 {
                return NSDateTimeAgoLocalizedStrings("NT_AN_HOUR_AGO")
            } else  {
                return stringFromFormat("%%d %@hours ago", withValue: components.hour!)
            }
        }
        
        if components.minute! > 0 {
            if components.minute! < 2 {
                return NSDateTimeAgoLocalizedStrings("NT_A_MINUTE_AGO")
            } else {
                return stringFromFormat("%%d %@minutes ago", withValue: components.minute!)
            }
        }
        
        if components.second! > 0 {
            if components.second! < 5 {
                return NSDateTimeAgoLocalizedStrings("NT_JUST_NOW")
            } else {
                return stringFromFormat("%%d %@seconds ago", withValue: components.second!)
            }
        }
        
        return ""
    }
    
    fileprivate func dateComponents() -> DateComponents {
        let calander = Calendar.current
        return (calander as NSCalendar).components([.second, .minute, .hour, .day, .month, .year], from: self, to: Date(), options: [])
    }
    
    fileprivate func stringFromFormat(_ format: String, withValue value: Int) -> String {
        let localeFormat = String(format: format, getLocaleFormatUnderscoresWithValue(Double(value)))
        return String(format: NSDateTimeAgoLocalizedStrings(localeFormat), value)
    }
    
    fileprivate func getLocaleFormatUnderscoresWithValue(_ value: Double) -> String {
        guard let localeCode = Locale.preferredLanguages.first else {
            return ""
        }
        
        // Russian (ru) and Ukrainian (uk)
        if localeCode == "ru" || localeCode == "uk" {
            let XY = Int(floor(value)) % 100
            let Y = Int(floor(value)) % 10
            
            if Y == 0 || Y > 4 || (XY > 10 && XY < 15) {
                return ""
            }
            
            if Y > 1 && Y < 5 && (XY < 10 || XY > 20) {
                return "_"
            }
            
            if Y == 1 && XY != 11 {
                return "__"
            }
        }
        
        return ""
    }
    
}

func NSDateTimeAgoLocalizedStrings(_ key: String) -> String {
    
    return NSLocalizedString(key, comment: "")
}





