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

### Okay, I have configured my own split controller and created some childs which conforms to `TidySplitsChildControllerProtocol`, what now?

Now you can finally make your app *navigating*! There are several possibilites to perform a navigation.


## I found a bug.

That's nice, I wrote it in a hurry in ~8 hours. I am 100% that you will find something. Create an issue and we can make it better, together :).

## Contributing

Just submit a pull request.

## Authors

* **Tomasz Kamiński** - *Initial work* - [TomKaminski](https://github.com/TomKaminski)

See also the list of [contributors](https://github.com/TomKaminski/TidySplits/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

