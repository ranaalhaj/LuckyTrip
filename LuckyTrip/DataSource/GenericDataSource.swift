
import Foundation
class GenericDataSource<T> : NSObject {
    var data: DynamicValue<[T]> = DynamicValue([])
     
}
