//
//  VeterinarianModels.swift
//  Helpet
//
//  Created by Nazlıcan Çay on 7.03.2023.
//

import CoreData

@objc(VeterinarianModels)

class VeterinarianModels : NSManagedObject
{
    @NSManaged var cd1 : Float
    @NSManaged var cd2 : Float
    @NSManaged var id : Int
    @NSManaged var name : String
   
}
