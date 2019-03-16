public class TidySplitsCheckpoint {
  var childType: TidySplitsChildPreferedDisplayType
  var childIndex: Int
  
  public init(childType: TidySplitsChildPreferedDisplayType, childIndex: Int) {
    self.childType = childType
    self.childIndex = childIndex
  }
}
