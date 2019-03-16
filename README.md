# TidySplits

TidySplits is another approach to setup Split Layout. It was created because of small configuration options of Apple's original SplitViewController. TidySplits is built using Swift 4.2 and supports iOS 9+. 

### Why I made this?

Personally on my commercial project Apple's SplitViewController overwhelmed me. It was to hard to control transitions between Compact and Regular interface. Project's view controllers structure is 

  * SplitViewController -> 
    * NavigationController ->
      * TabBarController -> 
        * Many of...
        * TableViewControllers ->
         * FilteringController
         * Create/EditController (DetailContext on Regular devices) -> Shows on secondary navigation
         * TabBarDetailController (DetailContext on Regular devices) -> Shows on secondary navigation
    * NavigationController ->
         * TabBarController -> 
             * Many of...
             * TableViewControllers ->
                 * DetailController -> It can go deeper and deeper.
                 * FilteringController
                 * Create/EditController
             * CollectionControllers ->
                 * FilteringController
                 * Create/EditController
             * SomeCustomControllers
              
And this structure can go deeper and deeper, forever. So at some point of time I decided to create my own navigation. For now it works much better with our controllers structure.

## Installing

You can either install it via [CocoaPods](https://cocoapods.org/) or by copy-pasting TidySplits source code into your project.

To install it via CocoaPods just add this line to your pods file:

```
pod 'TidySplits' 
```

And then run from your console:

```
pod install
```

## Running the example project

After downloading whole project you can check how it works by running target 'TidySplitsExample'. This project contains simple example how TidySplits should be configured. It's super easy!

Example project has two important files: ExampleViewController.swift and MainSplitViewController.Swift, first is just created to show how some of navigation features works. Second is our start point of everything :).

## How to start using TidySplits

### Your SplitViewController is a base.

First of all, like in example project you have to create your SplitViewController which inherits from `TidySplitsUISplitViewController`

Controller from example code looks like following:

```swift
class ExampleSplitViewController: TidySplitsUISplitViewController, TidySplitsSplitViewDelegate {
  var shouldOmitDetailChildsForCompactMode: Bool {
    return false
  }
  
  override func viewDidLoad() {
    self.delegate = self
    super.viewDidLoad()
  }
  
  func getDetailsPlaceholder() -> TidySplitsChildControllerProtocol {
    let ctrl = ExampleViewController(.Detail)
    ctrl.view.backgroundColor = .green
    return ctrl
  }
  
  func getInitialPrimaryControllers() -> [TidySplitsChildControllerProtocol] {
    let ctrl = ExampleViewController(.Primary)
    ctrl.view.backgroundColor = .blue
    return [ctrl]
  }
  
  func getInitialDetailControllers() -> [TidySplitsChildControllerProtocol] {
    let ctrl = ExampleViewController(.Detail)
    ctrl.view.backgroundColor = .red
    return [ctrl]
  }
}
```

On `viewDidLoad` method you have to specify delegate. For simplify our controller is it's own delegate :). Delegate protocol declares required method's and properties for correct configuration.

```swift
public protocol TidySplitsSplitViewDelegate: class {
  
  /**
   Computed get only property which decides if we should omit details stack when transitioning from **regular** to **compact** layout.
   */
  var shouldOmitDetailChildsForCompactMode: Bool { get }

  /**
  Delegate method to define which controller (or controllers) starts primary stack.
  */
  func getInitialPrimaryControllers() -> [TidySplitsChildControllerProtocol]
  
  /**
   Delegate method to define which controller (or controllers) starts detail stack.
   */
  func getInitialDetailControllers() -> [TidySplitsChildControllerProtocol]
  
  /**
   Delegate method to define which controller should be shown if detail stack is empty and we transition to **regular** "splitted" layout.
   */
  func getDetailsPlaceholder() -> TidySplitsChildControllerProtocol
}
```

### Each of your child controllers should conform to `TidySplitsChildControllerProtocol`

This protocol is the core of all what is happening in this library.

```Swift
public protocol TidySplitsChildControllerProtocol: class {
  var prefferedDisplayType: TidySplitsChildPreferedDisplayType { get set }
  
  var tidySplitController: TidySplitsUISplitViewController? { get }
  var tidyNavigationController: TidySplitsUINavigationController? { get }
  
  func postPopSelfNotification()
  func popSelf() -> UIViewController?
}
```

The most important thing is `preferedDisplayType` property. It determines **where** specific controller should be pushed (Primary or Detail stack).

I have created and defined some base controllers which you can use as a base for your custom controllers:
 * TidySplitsUIViewController - subclass of UIViewController
 * TidySplitsUITableViewController - subclass of UITableViewController
 * TidySplitsUITabBarViewController - subclass of UITabBarController

### Okay, I have configured my own split controller and created some childs which conforms to `TidySplitsChildControllerProtocol`, what now?

Now you can finally make your app *navigating*! There are several possibilites to perform a navigation.

#### From Split controller

```swift
  open func showDetail(_ controller: TidySplitsChildControllerProtocol, _ animated: Bool = true, _ completion: ((TidySplitsChildControllerProtocol) -> Void)? = nil)

  open func push(_ controller: TidySplitsChildControllerProtocol, _ animated: Bool = true, _ completion: ((TidySplitsChildControllerProtocol) -> Void)? = nil)
  
  open func tryPush(_ controller : UIViewController, _ animated: Bool = true, _ completion: ((TidySplitsChildControllerProtocol) -> Void)? = nil) -> Bool
  
  @discardableResult open func pop(from type: TidySplitsChildPreferedDisplayType, _ animated: Bool = true, _ completion: ((UIViewController?) -> Void)? = nil) -> UIViewController?
```

* `showDetail` method replaces current detail stack with specified controller.
* `push` method pushes new controller to primary or detail stack - based on controller's prefered display type.
* `tryPush` method tries to push (if it conforms to our ChildProtocol) new controller to primary or detail stack - based on controller's prefered display type.
* `pop` method pops currently displayed controller from specified type


#### From Navigation controller

```swift
  open func pushToMe(_ controller: TidySplitsChildControllerProtocol, _ animated: Bool = true, _ completion: ((TidySplitsChildControllerProtocol) -> Void)? = nil)
  
  open func tryPushToMe(_ controller: UIViewController, _ animated: Bool = true, _ completion: ((TidySplitsChildControllerProtocol) -> Void)? = nil) -> Bool
  
  open func popFromMe(animated: Bool = true, _ completion: ((UIViewController?) -> Void)? = nil)
```

* `pushToMe` method pushes controller to current navigation **and changes it's prefered type to type of Navigation controller - think about it when using this method!**.
* `tryPushToMe` method tries to push controller to current navigation (if child conforms to ChildProtocol) **and changes it's prefered type to type of Navigation controller - think about it when using this method!**.
* `popFromMe` method pops currently displayed controller in this navigation controller

#### From Child controller

Child controller protocol has this properties defined:

```swift
  var tidySplitController: TidySplitsUISplitViewController? { get }
  var tidyNavigationController: TidySplitsUINavigationController? { get }
```

It allows you to use Split/Navigation controllers methods in child code.

Additionally child can `popSelf()` :)

## I found a bug.

That's nice, I wrote it in a hurry in ~8 hours. I am 100% that you will find something. Create an issue and we can make it better, together :).

## TODO:

* Teleports feature
* Expose better configuration options
* Document code

## Contributing

Just submit a pull request.

## Authors

* **Tomasz Kamiński** - *Creator* - [TomKaminski](https://github.com/TomKaminski)

See also the list of [contributors](https://github.com/TomKaminski/TidySplits/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.txt) file for details

