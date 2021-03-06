//
//  AppDelegate.swift
//  bbqFinderJSONConverter
//
//  Created by Richard Moult on 25/09/2016.
//  Copyright © 2016 RichardMoult. All rights reserved.
//

import Cocoa
import Foundation


struct BBQ {
    let title: String
    let facilities: String
    let lat: Double
    let lon: Double
    let address: String
}


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {

        printOutMeetMeMelbourne()

    }


    func printOutMeetMeMelbourne() {
        guard let jsonResult = dictionaryFromJsonResourceName(fileName: "MeetMe_Melbourne") else { return }

        if let bbqList = jsonResult["bbqList"] as? NSArray {

            let bbqDictionaryList = bbqList.flatMap { $0 as? NSDictionary }

            var bbqs = [BBQ]()

            for bbq in bbqDictionaryList {

                let title = bbq["name"] as! String
                let facility = ""
                let lat = bbq["latitude"] as! Double
                let lon = bbq["longitude"] as! Double
                let address = ""
                let barbeque = BBQ(title: title.capitalized, facilities: facility, lat: lat, lon: lon, address: address)
                bbqs.append(barbeque)
            }
            printBBQList(bbqs: bbqs)
        }

    }
// MeetMe_Melbourne


    private func printBBQList(bbqs: [BBQ]) {

        for bbq in bbqs {
            print("BBQ(title:\"\(bbq.title)\", facilities:\"\(bbq.facilities)\", lat: \(bbq.lat), lon: \(bbq.lon), address: \"\(bbq.address)\"),")
        }
    }




    func applicationWillTerminate(_ aNotification: Notification) {
    }



    private func printOutCanberraBbqList() {

        printOutJsonWithProperties(fileName: "Canberra", titleKey: "DIVISION_NAME", latKey: "lat_gda94", lonKey: "lon_gda94", addressKey: "LOCATION_DESCRIPTION")
    }


    private func printOutGreaterDandenongBbqList() {

        printOutJsonWithProperties(fileName: "GreaterDandenong", titleKey: "site_name", latKey: "lat_gda94", lonKey: "lon_gda94", addressKey: "location")
    }


    private func printOutGreaterGeelongBbqList() {

        printOutJsonWithProperties(fileName: "GreaterGeelong", titleKey: "descriptio", latKey: "lat_gda94", lonKey: "lon_gda94", addressKey: "address")
    }

    private func printOutNoosaBbqList() {

        printOutJsonWithProperties(fileName: "noosa", titleKey: "name", latKey: "lat_gda94", lonKey: "lon_gda94", addressKey: "")
    }


    private func printOutAlphineShireBbqList() {

        printOutJsonWithProperties(fileName: "AlpineShire", titleKey: "park_name", latKey: "lat_gda94", lonKey: "lon_gda94", addressKey: "", facilitiesKey: "facilities")
    }



    private func printOutTasmaniaGlenorchyBbqList() {

        printOutJsonWithProperties(fileName: "TasmaniaGlenorchy", titleKey: "location", latKey: "lat_gda94", lonKey: "lon_gda94", addressKey: "address")
    }


    
    // MARK: Ballarat

    private func printOutBallaratBbqList() {

        printOutJsonWithProperties(fileName: "Ballarat", titleKey: "Site Name", latKey: "lat", lonKey: "long", addressKey: "Feature Location")
    }

    private func printOutJsonWithProperties(fileName: String,
                                            titleKey: String,
                                            latKey: String,
                                            lonKey: String,
                                            addressKey: String,
                                            facilitiesKey: String?=nil) {

        guard let jsonResult = dictionaryFromJsonResourceName(fileName: fileName) else { return }

        if let features = jsonResult["features"] as? Array<NSDictionary>
        {
            var bbqs = [BBQ]()

            for feature in features {

                let bbqCoords = coordsForBBqJson(bbqJson: feature)

                if let properties = feature["properties"] as? NSDictionary
                {
                    let title = properties[titleKey] as! String

                    //let lat = Double(properties[latKey] as! String)!
                    //let lon = Double(properties[lonKey] as! String)!
                    let lat = bbqCoords.lat
                    let lon = bbqCoords.lon

                    var address = ""
                    if addressKey.characters.count > 0 {
                        if let jsonAddress = properties[addressKey] as? String {
                            address = jsonAddress.replacingOccurrences(of: "\r\n", with: ", ")
                        }
                    }
                    var facilities = ""
                    if facilitiesKey != nil {
                        if let facilityString = properties[facilitiesKey!] as? String {
                            facilities = facilityString
                            facilities = facilities.replacingOccurrences(of: ", BBQ", with: "")
                            facilities = facilities.replacingOccurrences(of: "BBQ", with: "")
                        }
                    }

                    bbqs.append( BBQ(title: title, facilities: facilities, lat: lat, lon: lon, address:address) )
                }
            }

            printBBQList(bbqs: bbqs)
            
        }

    }

    private func coordsForBBqJson(bbqJson:NSDictionary) -> (lat:Double, lon:Double) {

        guard let geometry = bbqJson["geometry"] as? NSDictionary else { return (0,0) }
        guard let coordinates = geometry["coordinates"] as? NSArray else { return (0,0) }

        if let coords = coordinates[0] as? NSArray {
            guard let lat = coords[1] as? Double else { return (0,0) }
            guard let lon = coords[0] as? Double else { return (0,0) }
            return (lat, lon)
        }

        guard let lat = coordinates[1] as? Double else { return (0,0) }
        guard let lon = coordinates[0] as? Double else { return (0,0) }
        return (lat, lon)
    }
    /*
     {"type":"Feature","geometry":{"type":"Point","coordinates":[146.957552951263,-36.7288378575838]},"properties":{"facilities":"BBQ","park_name":"Apex Park","icon":"leaf","marker_colour":"green", "image_url":"","image_width":"500","image_height":"334"}}

 */


    // MARK: Melbourne CBD


    private func printOutMelbourneCBDBbqList() {

        guard let jsonResult = dictionaryFromJsonResourceName(fileName: "MelbourneCBD") else { return }

        if let bbqsJson : NSArray = jsonResult["data"] as? NSArray
        {
            let bbqs = bbqsJson.flatMap { convertMelbourneJsonToBBQ(bbqArray: $0 as! NSArray) }
            printBBQList(bbqs: bbqs)
        }
    }


    private func dictionaryFromJsonResourceName(fileName: String) -> NSDictionary? {

        let path = Bundle.main.path(forResource: fileName, ofType: "json")

        do {
            let jsonData = try NSData(contentsOfFile: path!, options: .mappedIfSafe)

            if let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: jsonData as Data, options: .mutableContainers) as? NSDictionary
            {
                return jsonResult
            }
        }
        catch {
            
        }
        return nil
    }


    private func convertMelbourneJsonToBBQ(bbqArray: NSArray) -> BBQ? {

        guard let title = bbqArray[8] as? String else { return nil }
        guard let coords = bbqArray[9] as? Array<AnyObject> else { return nil }

        let lat = Double(coords[1] as! String)!
        let lon = Double(coords[2] as! String)!
        return BBQ(title: title, facilities: "", lat: lat, lon: lon, address: "")
    }

}

