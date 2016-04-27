//: Playground - noun: a place where people can play

import UIKit

class Filter{
    var rgba = [UInt8](count:5, repeatedValue: 0)
}


let redFilter: Filter = Filter()
redFilter.rgba[0] = 255

let greenFilter: Filter = Filter()
greenFilter.rgba[1] = 45

let blueFilter: Filter = Filter()
blueFilter.rgba[2] = 255

let alphaFilter: Filter = Filter()
alphaFilter.rgba[3] = 50


let luminosityModifier = Filter()
luminosityModifier.rgba[4] = 20



class ImageProcessor{
    
    var filterSequenceList: [String] = []
    
    
    var filtersAvailable: [String: Filter] = [
        "redFilter": redFilter,
        "greenFilter": greenFilter,
        "blueFilter": blueFilter,
        "alphaFilter": alphaFilter,
        "luminosityModifier": luminosityModifier
    ]
    
    func addFilterToSequence(filterName: String){
        filterSequenceList.append(filterName)
    }
    
    func applyFilters(image: UIImage) -> UIImage{
        
        var filters: [Filter] = []
        
        for name in filterSequenceList{
            filters.append(filtersAvailable[name]!)
        }
        
        let rgbaImage = RGBAImage(image: image)!
        
        for y in 0..<rgbaImage.height{
            for x in 0..<rgbaImage.width{
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                
                for filter in filters{
                    for value in 0...4 {
                        
                        
                        if(filter.rgba[value] != 0 ){
                            
                            switch value{
                                
                            case 0:
                                
                                pixel.red = filter.rgba[value]
                                rgbaImage.pixels[index] = pixel
                                
                            case 1:
                                
                                pixel.green = filter.rgba[value]
                                rgbaImage.pixels[index] = pixel
                                
                            case 2:
                                
                                pixel.blue = filter.rgba[value]
                                rgbaImage.pixels[index] = pixel
                                
                            case 3:
                                
                                pixel.alpha = filter.rgba[value]
                                rgbaImage.pixels[index] = pixel
                                
                            case 4:
                                
                                let red = pixel.red
                                let green = pixel.green
                                let blue = pixel.blue
                                
                                let luminosityModifier = Double(filter.rgba[value])
                                
                                let relativeluminosity = Double(red) * 0.2126 + Double(green) * 0.7152 + Double(blue) * 0.0722
                                
                                let transformerRed = (relativeluminosity - Double(green) * 0.7152 - Double(blue) * 0.0722) / 0.2126
                                
                                let transformerGreen = (relativeluminosity - Double(red) * 0.2126 - Double(blue) * 0.0722 ) / 0.7152
                                
                                let transformerBlue = (relativeluminosity - Double(red) * 0.2126 - Double(green) * 0.7152 ) / 0.0722
                                
                                pixel.red = UInt8(transformerRed * luminosityModifier / 100 )
                                pixel.green = UInt8(transformerGreen * luminosityModifier / 100)
                                pixel.blue =  UInt8(transformerBlue * luminosityModifier / 100)
                                
                                rgbaImage.pixels[index] = pixel
                                
                            default:
                                
                                print("No image changes")
                                
                            }
                        }
                    }
                }
            }
        }
        let newImage = rgbaImage.toUIImage()!
        return newImage
    }
}

//--------------------------------------- Start using the class here--------------------------------


var processor: ImageProcessor = ImageProcessor()

// Use the addFilterToSequence function and pass in one of the strings mentioned below. Using a non-existing filter name will cause a runtime error
//"redFilter"
// "greenFilter"
// "blueFilter"
// "alphaFilter"
//"luminosityModifier"

//processor.addFilterToSequence("redFilter")
//processor.addFilterToSequence("blueFilter")
//processor.addFilterToSequence("luminosityModifier")
//processor.addFilterToSequence("greenFilter")
processor.addFilterToSequence("alphaFilter")

processor.filterSequenceList

var sampleImg = UIImage(named:"sample.png")
processor.applyFilters(sampleImg!)
