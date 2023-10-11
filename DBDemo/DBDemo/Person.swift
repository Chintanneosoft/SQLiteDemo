import Foundation

class Person{
    var id: Int
    var name: String = ""
    var exp: String = ""
    
    init(id: Int,name:String, exp:String){
        self.id = id
        self.name = name
        self.exp = exp
    }
}
