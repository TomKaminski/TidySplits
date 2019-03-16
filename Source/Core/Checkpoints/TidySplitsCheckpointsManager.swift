public class TidySplitsCheckpointsManager {
  private var checkpoints: [String: TidySplitsCheckpoint] = [:]
  
  public func addCheckpoint(key: String, checkpoint: TidySplitsCheckpoint) {
    checkpoints.updateValue(checkpoint, forKey: key)
  }
  
  public func getCheckpoint(key: String) -> TidySplitsCheckpoint? {
    return checkpoints[key]
  }
  
  public func removeCheckpoint(for key: String) -> TidySplitsCheckpoint? {
    return checkpoints.removeValue(forKey: key)
  }
  
  public func remapExistingCheckpoints() {
  }
}
