# RN LoadingView Example
这是一个给RN App定制LoadingView的例子, 只针对iOS。安卓和iOS原理一样，大家可以自己探索。

LoadingView只在开发模式下第一次启动app的时候比较明显，如果你想重复观察效果，可以尝试下面的命令来清除缓存重新打包app:

~~~
watchman watch-del-all && rm -rf node_modules/ && yarn install && yarn start -- --reset-cache 
~~~

运行上面的命令会启动一个packager，然后你重新运行app就会看到一个红色的LoadingView动画.


# 定制代码
定制代码在`AppDelegate.m`中，如下:

~~~
- (void)customizeLoadingView:(RCTRootView *)rootView {
  UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  CGSize screenSize = [UIScreen mainScreen].applicationFrame.size;
  indicator.center = CGPointMake(screenSize.width * 0.5, screenSize.height * 0.5);
  indicator.color = [UIColor redColor];
  [indicator startAnimating];
  rootView.loadingView = indicator;
}
~~~

大家可以复写上面的方法，实现自己的loadingView. 然后记得在`AppDelegate.m`的`- (BOOL)application:didFinishLaunchingWithOptions:`中调用这个方法。

LoadingView的生命周期RN会自动管理，加载完成以后会自动从superview里面删除，只要大家不持有这个loadingview的实例，这个view会自动销毁.