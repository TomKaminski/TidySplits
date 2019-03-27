public protocol TidySplitsCheckpointControllerProtocol: TidySplitsChildControllerProtocol {
  var associatedCheckpointKey: String? { get set }
  
  func removeCheckpoint()
  func setupCheckpoint(with key: String)
}

public extension TidySplitsCheckpointControllerProtocol where Self: UIViewController {
  func removeCheckpoint() {
    if let key = associatedCheckpointKey, let splitCtrl = self.tidySplitController {
      _ = splitCtrl.checkpointsManager.removeCheckpoint(for: key)
    }
  }
  
  func setupCheckpoint(with key: String) {
    if let splitCtrl = self.tidySplitController, let index = splitCtrl.navigator.getIndex(for: self) {
      let checkpoint = TidySplitsCheckpoint(childType: self.prefferedDisplayType, childIndex: index)
      _ = splitCtrl.checkpointsManager.addCheckpoint(key: key, checkpoint: checkpoint)
      self.associatedCheckpointKey = key
    }
  }
}
