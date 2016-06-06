# OperationDemo
研究一下NSOperation的使用方法。	

如果start和main两个方法都重载了，则会调用start，并不调用main方法。

##主线程手动启动
在不加入Queue的情况下，Test1与Test分别是对应并发与非并发的，然而根本上我分不出来2者到底有什么区别。	

- **Test1**中Operation重载了`main`，然后直接使用了NSData的方式拿数据，所以会卡死在主线程。	
- **Test2**中重载了`start`和`isAsynchronous`。本来以为并发效果，在主线程是不会卡顿的，结果和Test1效果一致，所以不知道我理解错了啥。。

##使用OperationQueue
使用queue之后，不要自己调用`start`，然后会自动加入到子线程中进行。

**Test3**和**Test4**与1，2的实现方法相同
##使用NSURLConnection+Queue
**Test5**使用Connection的方法进行下载，重载`start`与`isAsynchronous`。	
比较重要的是因为connection是在子线程里进行下载的，而当[operation start]的时候,````走完该方法后，当前的线程就已经失去活性了（不知道有没有直接释放掉线程），所以delegate回调没有任何反应。````

###参考了SDWebImage的方法
在适当的时候加入

```
CFRunLoopRun();
CFRunLoopStop(CFRunLoopGetCurrent());
```

run的方法会将当前线程的CFRunLoop object在标准模式下启动，并且是无期限的，会一直运行下去。

stop的方法能够及时的停止线程的CFRunLoop object，文档是说当所有资源和计时器全部从CFRunLoop object移除时，CFRunLoop object也会停止。

###AFNetworking的方法
```
+ (void)networkRequestThreadEntryPoint:(id)__unused object {
    @autoreleasepool {
        [[NSThread currentThread] setName:@"AFNetworking"];

        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}

+ (NSThread *)networkRequestThread {
    static NSThread *_networkRequestThread = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _networkRequestThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint:) object:nil];
        [_networkRequestThread start];
    });

    return _networkRequestThread;
}

```
其实就和SDWebImage的CFRunLoopRun()类似。不过AFNetworking的话，是实现自己创建一个子线程,然后让该线程的CFRunLoop object开始run。之后所有的Connection发起、回调都是在该线程中。

##Question
- 不是很明白为什么重载`main`的时候需要用到**`autoreleasepool`**