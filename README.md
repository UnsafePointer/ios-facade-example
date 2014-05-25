Façade design pattern implementation on iOS
===========================================

__Description:__

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

![ios-facade-screenshot-1.png](https://dl.dropboxusercontent.com/u/12352209/GitHub/ios-facade-screenshot-1.png)&nbsp;
![ios-facade-screenshot-2.png](https://dl.dropboxusercontent.com/u/12352209/GitHub/ios-facade-screenshot-2.png)
![ios-facade-screenshot-3.png](https://dl.dropboxusercontent.com/u/12352209/GitHub/ios-facade-screenshot-3.png)&nbsp;
![ios-facade-screenshot-4.png](https://dl.dropboxusercontent.com/u/12352209/GitHub/ios-facade-screenshot-4.png)

__Design notes:__

* I used to keep Core Data relationships on MTLModel (check [v1.0](https://github.com/Ruenzuo/ios-facade-example/commit/b99d7f31a6afc4b4a37c992b51692270c5056f69)) but I ended up changing this later (check [v1.1](https://github.com/Ruenzuo/ios-facade-example/commit/ddcb34612bdbeca24df46da313721a543a3973b9)) which decreased memory usage from ~40MB to ~20MB and startup time from ~3s to ~0s.
* Current data model:

![ios-facade-screenshot-5.png](https://dl.dropboxusercontent.com/u/12352209/GitHub/ios-facade-screenshot-5.png)

* Probably this can be done without Mantel layer, I just think it makes things easier that handling NSManagedObject instances. 
* There are a lot of performance and test hooks and methods that you don't need to have on production.
* This has been tested on very large data sources (check [v1.2](https://github.com/Ruenzuo/ios-facade-example/commit/88d6ee3c3c73408ed8c4c0c6c30df131553129f7), it has 250 countries, 100 cities for each country and 10 stations for each city) and short data sources (check [v1.3](https://github.com/Ruenzuo/ios-facade-example/commit/cbf228a5ba43e0e81f848bd3d261f818e85f50b4) it has 250 countries, 3 cities for each country and 10 stations for each city).
* Currently I'm not using any synchronization pattern, just checking if the data exists on database to make new requests.

__To-Do:__

* `[✓]` <del>Make it public.</del>
* `[✓]` <del>Write the blog post</del>. It's [here](http://ruenzuo.github.io/facade-software-design-pattern-on-ios-and-android/index.html).
* `[ ]` Add tests.
* `[ ]` Decide which strategy use depending on system resources like available memory, network state and others. 
* `[ ]` Add synchronization pattern.

License
=======

    The MIT License (MIT)

    Copyright (c) 2014 Renzo Crisóstomo

    Permission is hereby granted, free of charge, to any person obtaining a copy of
    this software and associated documentation files (the "Software"), to deal in
    the Software without restriction, including without limitation the rights to
    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
    the Software, and to permit persons to whom the Software is furnished to do so,
    subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
