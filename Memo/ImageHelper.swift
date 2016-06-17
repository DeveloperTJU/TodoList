//
//  ImageHelper.swift
//  Memo
//
//  Created by tjise on 16/6/16.
//  Copyright © 2016年 hui. All rights reserved.
//

import Foundation


extension UIImage {
    func fixOrientation() -> UIImage {
        if (self.imageOrientation == .Up) {
            return self
        }
        var transform = CGAffineTransformIdentity
        switch (self.imageOrientation) {
        case .Down, .DownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
            break
        case .Left, .LeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
            break
        case .Right, .RightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
            break
        default:
            break
        }
        switch (self.imageOrientation) {
        case .UpMirrored, .DownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
            break
        case .LeftMirrored, .RightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
            break
        default:
            break
        }
        let ctx = CGBitmapContextCreate(nil, Int(self.size.width), Int(self.size.height),
                                                                   CGImageGetBitsPerComponent(self.CGImage), 0,
                                                                                                             CGImageGetColorSpace(self.CGImage),
                                                                                                             CGImageGetBitmapInfo(self.CGImage).rawValue)
        CGContextConcatCTM(ctx, transform)
        switch (self.imageOrientation) {
        case .Left, .LeftMirrored, .Right, .RightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage)
            break
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage)
            break
        }
        // And now we just create a new UIImage from the drawing context
        let cgimg = CGBitmapContextCreateImage(ctx)
        return UIImage(CGImage: cgimg!)
    }
}



extension UIImage {
    
    func resizableImage(name: String) -> UIImage {
        
        var normal = UIImage(named: name)!
        let imageWidth = normal.size.width * 0.5
        let imageHeight = normal.size.height * 0.5
        normal = resizableImageWithCapInsets(UIEdgeInsetsMake(imageHeight, imageWidth, imageHeight, imageWidth))
        
        return normal
    }
    
    func compressImage(image: UIImage, maxLength: Int) -> NSData? {
        
        let newSize = self.scaleImage(image, imageLength: 300)
        let newImage = self.resizeImage(image, newSize: newSize)
        
        var compress:CGFloat = 0.9
        var data = UIImageJPEGRepresentation(newImage, compress)
        
        while data?.length > maxLength && compress > 0.01 {
            compress -= 0.02
            data = UIImageJPEGRepresentation(newImage, compress)
        }
        
        return data
    }
    
    func  scaleImage(image: UIImage, imageLength: CGFloat) -> CGSize {
        
        var newWidth:CGFloat = 0.0
        var newHeight:CGFloat = 0.0
        let width = image.size.width
        let height = image.size.height
        
        if (width > imageLength || height > imageLength){
            
            if (width > height) {
                
                newWidth = imageLength;
                newHeight = newWidth * height / width;
                
            }else if(height > width){
                
                newHeight = imageLength;
                newWidth = newHeight * width / height;
                
            }else{
                
                newWidth = imageLength;
                newHeight = imageLength;
            }
            
        }
        return CGSize(width: newWidth, height: newHeight)
    }
    
    func resizeImage(image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}