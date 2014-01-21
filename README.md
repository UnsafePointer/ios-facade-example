Façade design pattern implementation on iOS
===========================================

_Description:_

On this example, I'm using this pattern to abstract object persistence operations through a single interface (thanks to Mantle) using the following strategies: memory cache (with TMCache), database (with MagicalRecord) and network cache (with AFNetworking). This is great for performance and user experience on mobile applications.

__Building:__

In order to build the application, clone this repo:

```sh
$ git clone git@github.com:Ruenzuo/ios-facade-example.git
```

Then set up the dependencies and open the workspace and you're ready to go:

```sh
$ cd ios-facade-example && pod install && open WeatherApp.xcworkspace
```  

_Design notes:_

* I used to keep Core Data relationships on MTLModel (check [v1.0](https://github.com/Ruenzuo/ios-facade-example/commit/b99d7f31a6afc4b4a37c992b51692270c5056f69)) but I ended up changing this later (check [v1.1](https://github.com/Ruenzuo/ios-facade-example/commit/ddcb34612bdbeca24df46da313721a543a3973b9)) decreasing memory usage from ~40MB to ~20MB.
* Probably this can be done without Mantel layer, I just think it makes things easier that handling NSManagedObject instances. 
* There are a lot of performance and test hooks and methods that you don't need to have on production.

_To-Do:_

* `[✓]` <del>Make it public.</del>
* `[ ]` Add tests.
* `[ ]` Decide which strategy use depending on system resources like available memory, network state and others. 