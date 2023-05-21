---
title: JS中的Promise
tags: FED
---

# Promise

## 一，定义

#### 1，抽象概念

​ 它是 ES6 规范的进行异步编程的新方案，能把异步变为同步；

​ 备：旧的方案是单纯的使用回调函数来实现；

​ 三种状态：

​ pending（初始化）

​ fulfilled（成功）

​ rejected（失败）

```js
//异步编程具体操作有哪些
fs 文件操作,一个对硬盘进行读取操作的模块；
数据库操作
AJAX
计时器
```

#### 2，具体表达

​ 从语法上来说：Promise 是一个构造函数，可以实例化对象

​ 从功能上说：Promise 对象用来封装一个异步操作并可以获取其成功/失败的结果值

## 二，为什么要使用 Promise

#### 1，指定回调函数的方式更加灵活

​ 旧的：必须在启动异步任务前指定

​ promise：启动异步任务=>返回 promise 对象 => 给 promise 对象绑定回调函数（也可以在异步任务结束后指定/多个）

#### 2，promise 支持链式调用，解决了回调地狱的问题

​ a，回调地狱：回调函数的嵌套使用；

​ b，回调地狱造成的影响：不便于阅读；不便于异常处理；

​ c，解决方法：

## 三，Promise 的使用

#### Promise 运行的整流程

![](F:\思大鼎picture\JS图片\promise流程.png)

#### 1，创建 promise 对象

```js
//返回的值也是一个promise对象

//myResolve形参，代表一个函数，表示promise对象是成功的状态；表示异步执行的代码执行成功时的一种结果；
//myReject形参，代表一个函数，表示promise对象是失败的状态；表示异步执行的代码执行失败时的一种结果；

let myPromise = new Promise(function (myResolve, myReject) {
  // "Producing Code"（可能需要一些时间，在进行异步执行的代码）

  myResolve(); // 成功时，将promise对象的状态设置为 成功
  myReject(); // 出错时，将promise对象的状态设置为 失败
});

// "Consuming Code" （必须等待一个兑现的承诺）
myPromise.then(
  function (value) {
    /* 成功时的代码 */
  },
  function (error) {
    /* 出错时的代码 */
  }
);
```

#### 2，使用 promise 的链式调用

​ 我们可以使用`promise.then()`，`promise.catch()`和`promise.finally()`这些方法将进一步的操作变成已经敲定的关联。

##### promise.then()：

​ 用来指定 promsie 的回调，能指定 promise 对象成功和失败状态的回调函数，执行后返回一个 promise 对象；

```js
//.then;跟在promise后直接链式使用；
let mypromise = new Promise((solve, ject) => {
  //执行代码块
}).then(() => {
  //可以直接在promise后，使用then方法，可以理解为成功状态下，下一步的回调执行；
  //执行代码，往后可以无限点方法执行，如此执行起来就有顺序可行，改变了异步执行；
});
```

```js
//.then;使用其单独点promise对象；

//Promise.then() 有两个参数，一个是成功时的回调，另一个是失败时的回调。
//两者都是可选的，因此您可以为成功或失败添加回调。
myPromise.then(
  function (value) {
    /* code if successful */
  },
  function (error) {
    /* code if some error */
  }
);
```

##### promise.catch：

​ 用来指定 promsie 的回调，只能指定 promise 对象失败状态的回调函数，执行后返回一个 promise 对象；

```js
//.catch
let mypromise = new Promise((solve, ject) => {
  //执行代码块
}).catch(() => {
  //可以直接在promise后，使用then方法，可以理解为失败状态下，下一步的回调执行；
  //执行代码，往后可以无限点方法执行，如此执行起来就有顺序可行，改变了异步执行；
});
```

#### 3，promise 实例

```js
let myFirstPromise = new Promise(function (resolve, reject) {
  //当异步代码执行成功时，我们才会调用resolve(...), 当异步代码失败时就会调用reject(...)
  //在本例中，我们使用setTimeout(...)来模拟异步代码，实际编码时可能是XHR请求或是HTML5的一些API方法.
  setTimeout(function () {
    resolve("成功!"); //代码正常执行！
  }, 250);
});

myFirstPromise.then(function (successMessage) {
  //successMessage的值是上面调用resolve(...)方法传入的值.
  //successMessage参数不一定非要是字符串类型，这里只是举个例子
  console.log("Yay! " + successMessage);
});
```

## 四，async 函数

#### 1，概念

​ 是使用`async`关键字声明的函数。 async 函数是[`AsyncFunction`]构造函数的实例， 并且其中允许使用`await`关键字。**`async`和`await`关键字让我们可以用一种更简洁的方式写出基于[`Promise`]的异步行为，而无需使用繁琐的.then 和.catch 操作。**无需刻意地链式调用`promise`。

##### a，async 声明的函数，返回的是一个 Promise 对象

##### b，Promise 对象的结果，由 async 声明的返回值决定的

##### 成功的结果：如果返回值是一个非 Promise 类型的数据或是一个 Promise 类型的数据，则返回的结果是成功的；

##### 失败的结果：如果返回的是一个失败的；返回的是抛出异常；

#### 2，async 和 await 关键字

​ **async 使函数返回 Promise；**

​ **await 使函数等待 Promise；await 只能在 async 函数中使用；**

​ 基础语法：

```js
//async操作的函数里必须返回一个Promsie对象;
async function myDisplay() {
  let myPromise = new Promise(function (myResolve, myReject) {
    //异步操作：延时器；
    setTimeout(function () {
      myResolve("I love You !!");
    }, 3000);
  });
  document.getElementById("demo").innerHTML = await myPromise;
}

myDisplay();
```

#### 3，async 应用和一般异步操作的区别

##### 一般异步延时器操作

```html
<body>
  <button id="normalbtn">正常异步执行</button>
  <button id="btn">使用async函数后</button>
  <script>
    //async声明的函数返回的是promise对象；

    //异步执行的延时器，中间间隔只有一秒，应该是两秒后再等两秒
    function testone() {
      setTimeout(function () {
        console.log("经过两秒输出");
      }, 2000);
      setTimeout(function () {
        console.log("经过三秒输出");
      }, 3000);
    }
    document.getElementById("normalbtn").onclick = function () {
      testone();
    };
  </script>
</body>
```

##### 使用 async 对延时器的操作

```js
<body>
    <button id="normalbtn">正常异步执行</button>
    <button id="btn">使用async函数后</button>
    <script>
        //async声明的函数返回的是promise对象；

        //使用async函数
        function twoSecond(){
            return new Promise((resolve,reject)=>{
                setTimeout(function(){
                    console.log('经过两秒输出');
                    resolve('经过两秒输出')
                },2000)
            })
        }
        function treeSecond(){
            return new Promise((resolve,reject)=>{
                setTimeout(function(){
                    console.log('经过三秒输出');
                    resolve('经过三秒输出')
                },3000)
            })
        }
        document.getElementById('btn').onclick = function(){
            asyncOne()
        }
        async function asyncOne(){
            await twoSecond()
            await treeSecond()
        }
    </script>
</body>
```
