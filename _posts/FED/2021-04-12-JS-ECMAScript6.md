---
title: ECMAScript6
tags: FED
---

# ECMAScript6

## 一章 ECMA 变迁史

### 1.1 ECMAScript 与 JavaScript 的关系

**ECMAScript**是语言标准,规定一门语言的具体规格.
如变量如何声明,for 循环的格式怎么写,这些最基础的东西.
Javascrtip 是满足 ECMAScript 要求的一种语言.

两者关系,如同*快捷宾馆营业标准*和*如家酒店*一样.
满足 ECMAScrtipt 标准的语言还有`Jscript`和`ActionScript`

> ECMA ( European Computer Manufactures Association )
> 欧洲计算机制造联合会,总部设在日内瓦

### 1.2 ECMAScript 的变迁

ECMAScript 1.0（1997 年）

ECMAScript 2.0（1998 年）

ECMAScript 3.0（1999 年 12 月）

ECMAScript 4.0 (太激进,夭折了)

ECMAScript 5.0 (2009)

ECMAScript 6.0 (2015)

3.0 版是一个巨大的成功，在业界得到广泛支持，成为通行标准，奠定了 JavaScript 语言的基本语法，以后的版本完全继承。
直到今天，初学者一开始学习 JavaScript，其实就是在学 3.0 版的语法。
5.0 版和 3.0 版区别不大。

随着 JS 的崛起,应用于移动开发,后端开发,游戏开发等,业界对 JS 的语言的要求越来越高.
此时再看 4.0 时提出的设想,已经不显得激进了.于是,6.0 版本终于通过了.

此标准严格的叫法应是`ECMAScript2015`,当然叫`es6`也没啥,没人和你抬杠.

### 1.3 浏览器支持情况

http://kangax.github.io/compat-table/es6/

## 二章 主要变化

### 2.1 语法的细微变化

- let 与 const
- 解构赋值

### 2.2 原功能的扩展

- 字符串扩展
- 数值扩展
- 数组扩展
- 对象扩展
- 函数扩展
- 正则扩展
- Symbol 新类型

### 2.3 新功能的添加

- Set 和 Map 数据结构
- Iterator 迭代器
- Generator 生成器
- Promise 对象
- Class 类
- Module 模块化

## 三章 语法变化

### 3.1 let 更清洁的声明变量

ES6 新增了`let`命令，用来声明变量。
它的用法类似于`var` , 但比`var`更"清洁"，因为期声明的变量,只在`let`命令所在的代码块内有效。

看下例:

```js
var a = 3;
let b = 4;
console.log(a, b); // 相同的效果
```

再看下例:

```js
{
  let c = "hello";
  var b = "world";
}

console.log(c); //ReferenceError: c is not defined
console.log(d); // world
```

可以看出: `let`命令在定义的`{}`内生效,某些语言也有类似特点,称"块级作用域".

这样,`let`定义的变量,只在块内生效,不影响其他区域,所以我们说 Ta 更"清洁".

在某些场合下,用`let`特别适合,比如`for()`循环

```js
// 设置i仅为循环数组,但循环后,残留一个变量i.
var arr = ["a", "b", "c"];
for (var i = 0; i < arr.length; i++) {}
console.log(i); // 3
```

换成`let`再试一下,是不是更清洁?

```
// i变量只在for()内有效,不污染其他区域
var arr = ['a' , 'b' , 'c'];
for(let i=0; i<arr.length; i++) {
}
console.log(i); // ReferenceError: i is not defined
```

不污染全局的 window 属性

```js
var c = "hello";
let d = "world";

window.d; //undefined
window.c; //hello
```

注:同域下,var ,let 声明同一变量名,error

### 3.2 const 常量

常量很不稀奇(画外音:那你咋现在才有常量?)
PHP,Java,C,C++ ...多数语言都有常量.

常量,即不可改变其值的量.

```js
const PI = 3.14;
console.log(PI);

PI = 3.15; // TypeError: Assignment to constant variable.
const PI = 3.15; // Identifier 'PI' has already been declare
```

注:常量名和变量名,都区分大小写

```js
const STU = { name: "lucy", age: 22 };
console.log(STU);
STU.name = "lily";
console.log(STU);
```

> console.log()传入的参数如果指向一个可变对象（数组、对象），那么它会默默地记录下这个引用；
> 在你查看这个输出结果的时候，才会读取这个对象，并把相关属性和值显示出来

### 3.3 解构赋值

解构赋值也不稀奇,python,PHP7 也有.
通俗的说,就是一次给多个变量赋值.

ES6 允许按照一定模式，从数组和对象中提取值，对变量进行赋值，这被称为解构（Destructuring）。
以前，为变量赋值，只能直接指定值。

```js
var a = 1;
var b = 2;
var c = 3;
//ES6允许写成下面这样。

let [a, b, c] = [1, 2, 3];
```

上面代码表示，可以从数组中提取值，按照对应位置，对变量赋值。

本质上，这种写法属于“模式匹配”，只要等号两边的模式相同，左边的变量就会被赋予对应的值。下面是一些使用嵌套数组进行解构的例子。

```javascript
var [foo, [[bar], baz]] = [1, [[2], 3]];
foo; // 1
bar; // 2
baz; // 3

let [, , third] = ["foo", "bar", "baz"];
third; // "baz"

let [x, , y] = [1, 2, 3];
x; // 1
y; // 3
```

```javascript
let [head, ...tail] = [1, 2, 3, 4];
head; // 1
tail; // [2, 3, 4]

let [x, y, ...z] = ["a"];
x; // "a"
y; // undefined
z; // []
```

## 四章 字符串扩展

### 4.1 trim()清除空白 [Es6]

### 4.2 for of 循环字符串

```js
var str = "𠮷";

for (var i = 0; i < str.length; i++) {
  console.log(str[i]);
}

for (let i of str) {
  console.log(i);
}
```

可以看出,传统的 for 循环产生乱码,因为不认识 UTF16 的编码。

### 4.4 includes 判断子字符串

传统上，JS 只有 indexOf 方法确定一个字符串是否包含在另一个字符串中，ES6 又提供了三种新的方法。

```js
"abc".includes("a"); // true
"abc".indexOf("a") >= 0; // true
```

### 4.5 startsWith 和 endsWith

```js
var s = "Hello world!";
s.startsWith("Hello"); // true
s.endsWith("!"); // true
```

这三个方法都支持第二个参数，表示开始搜索的位置。

```javascript
var s = "Hello world!";
s.startsWith("world", 6); // true
s.endsWith("Hello", 5); // true
s.includes("Hello", 6); // false
```

上面代码表示，使用第二个参数 n 时，endsWith 的行为与其他两个方法有所不同。它针对前 n 个字符，而其他两个方法针对从第 n 个位置直到字符串结束。

### 4.6 repeat 重复字符串

`'hello'.repeat(3); // hellohellohello`

`'hello'.repeat(0) === '' //true,得到空字符串`

`'hello'.repeat(NaN) === '' //true,得到空字符串`

`'hello'.repeat('a') // 提醒,a转为为int得NaN 若为"3" 则转换为数字`

`'hello.repeat(-1)' // RangeError: Invalid count value 小于-1或者为infinity 则报错`

`'hello.repeat(0.9)' // "" , 空字符串 取整为0  -1到0之间也会被取整`

### 4.7 padStart()，padEnd() [ES7]

打开实验性的 js 来进行测试。
字符串补全长度的功能。如果某个字符串不够指定长度，会在头部或尾部补全。padStart 用于头部补全，padEnd 用于尾部补全。

```js
"x".padStart(5, "ab"); // 'ababx'
"x".padStart(4, "ab"); // 'abax'

"x".padEnd(5, "ab"); // 'xabab'
"x".padEnd(4, "ab"); // 'xaba'
```

上面代码中，padStart 和 padEnd 一共接受两个参数，第一个参数用来指定字符串的最小长度，第二个参数是用来补全的字符串。

如果原字符串的长度，等于或大于指定的最小长度，则返回原字符串。

```js
"xxx".padStart(2, "ab"); // 'xxx'
"xxx".padEnd(2, "ab"); // 'xxx'
```

如果用来补全的字符串与原字符串，两者的长度之和超过了指定的最小长度，则会截去超出位数的补全字符串。

```js
"abc".padStart(10, "0123456789");
// '0123456abc'
```

如果省略第二个参数，则会用空格补全长度。

```js
"x".padStart(4); // '   x'
"x".padEnd(4); // 'x   '
```

padStart 的常见用途是为数值补全指定位数。下面代码生成 10 位的数值字符串。

```js
"1".padStart(10, "0"); // "0000000001"
"12".padStart(10, "0"); // "0000000012"
"123456".padStart(10, "0"); // "0000123456"
```

另一个用途是提示字符串格式。

```js
"12".padStart(10, "YYYY-MM-DD"); // "YYYY-MM-12"
"09-12".padStart(10, "YYYY-MM-DD"); // "YYYY-09-12"
```

### 4.8 模板字符

ES6 用反引号'`'包住字符串,可以让字符串多行书写,也可以自由的嵌入变量.

例: 旧时,我们将用户信息写入 DOM 中,要这样

```js
let stu = {name : 'lucy' , age:19};
$('#rs').html("My name is " + stu.name " +
",and my age is " + stu.age + "years old");
```

对于多行字符串容易报错.
现在,用模板语法,我们可以这样

```js
let str = `My name is ${stu.name},and my age is ${stu.age} years old,
and last year , I am ${stu.age + 1} years;
`;
```

模板内的${}存放变量
模板内的大括号`{}`可以放任意合法的 JS 表达式,意味着:

```js
function t() {
  return "world";
}

let str = `hello , ${t()} , ${7 + 9} , ${"ok"}`;
```

## 五章 数值 Number 对象

### 5.1 二进制和八进制的支持

```js
let a = 0b1001;
console.log(a); // 9

let b = 0o76;
console.log(b); //62
```

十六进制

```
var c = 0x21
```

### 5.2 原全局函数移植

ES6 把一些关于数值的全局函数移植到了 Number 对象上.为了逐步减少全局性的方法,使得语言逐步模块化.但是仍然向下兼容.

```javascript
isFinite(); //检查数值是不是有限的
isNaN(); // 检查函数是不是数值
parseInt();
parseFloat();
```

### 5.3 新增方法

- isInteger()
  这个方法用来判断一个值是否为整数，需要注意的是，在 JS 中，整数和浮点数存储方式一样，所以 3 和 3.0 被视为同一个值

- isSafeInteger()
  JS 能够准确表示的整数范围是`-2^53`到`2^53`之间（不含两个端点），当超过这个范围的时候，就无法精准的表示了。

```javascript
if (Math.pow(2, 53) === Math.pow(2, 53) + 1) {
  alert(1);
}
```

为此，我们可以用`Number.isSafeInteger()`来判断一个整数是否落在这个范围之内。

> ES6 引入了`Number.MAX_SAFE_INTEGER` 和`NUMBR.MIN_SAFE_INTEGER`来表示这个范围的上下限。

### 5.4 新增极小常量 EPSILON

ES6 在 Number 对象上面，新增了一个极小的常量`Number.EPSILON`

```javascript
console.log(Number.EPSILON.toFixed(20));
//0.00000000000000022204
```

引入这个小的量的目的，是为了为浮点计算设置一个误差范围。因为我们在进行浮点运算的时候，计算结果往往是不精确的。

```javascript
console.log(0.1 + 0.2);
//0.30000000000000004
```

如果误差能够小小于这个小的常量，那么我们认为得到了正确结果。
因此，`Number.EPSLIN`实际上就是一个可以接受的范围。

## 六章 Math 对象

ES6 在 Math 对象上新增了 17 个与数学相关的方法。所有这些方法和原来的都一样，是静态的，可以直接在 Math 对象上进行调用。
我们不必要全都记住，找几个可能用到的讲解。

### 6.1 Math.trunc()

去除一个数的小数部分，返回整数部分。

```javascript
Math.trunc(4.1);
Math.trunc(4.9);
Math.trunc(-4.1);
Math.trunc(); //对于空值和无法取整的值返回NaN
Math.trunc("abc");
Math.trunc("12.34"); //对于非数值 内部先将其转换为数值.
Math.trunc(NaN);
```

### 6.2 Math.sign()

`Math.sign`方法可以用来判断一个数到底是正数，负数，还是零。

- 如果参数是正数，返回+1
- 如果参数为负数，返回-1
- 如果参数为 0，返回 0
- 如果参数是-0，返回-0
- 如果参数为其它，返回 NaN

### 6.3 Math.cbrt()

`Math.cbrt`方法用来计算一个数的立方根。对于非数值,也是在内部先将其转换为数值型.

### 6.4 指数运算符

ES7 新增了一个指数运算符(`**`)

```javascript
2 ** 2; //4
2 ** 3; //8
```

由此，又诞生了一个新的赋值运算符(`**=`)

```javascript
a **= 2;
//a = a*a;
```

## 七章 Array 数组对象

### 7.1 isArray()

`Array.isArray()`方法是用来判断某个值是否是数组，如果是，则返回 true，否则返回 false，用于判断一些类似数组的对象很有用。

eg:

```
Array.isArray(b)
```

因为无论是数组还是对象，对于 typeof 的操作返回值都为 object，所以就有了区分数组类型和对象类型的需要.而有些对象中又存在 length 属性,我们原来的方法是通过

```
Array.constructor == Array
ary instanceof Array
```

> instanceof 用来判断内存中实际对象 A 是不是 B 类型

来进行判断.

现在只需要使用该函数即可.

> 我们平时所定义的数组其实是 new Array([1,2,3])[0]

### 7.1 indexOf(),lastIndexOf() [ES5]

`indexOf()`方法返回给定元素能找在数组中找到的第一个索引值，否则则返回-1。
而`lastIndexOf()`方法是返回指定元素在数组中的最后一个索引值，如果不存在则返回-1。
注意，`lastIndexOf()`是从数组的后面向前查找。

```
var array = [2,4,9,2];
var index = array.indexOf(2);
var lastindex = array.lastIndexOf(2);
```

### 7.2 filter() , map() [ES5]

`filter()`方法使用制定的函数过滤所有元素，并创建一个包含所有通过过滤的元素的新数组。
指定函数为`filter()`的回调函数。

```js
var array = [12,5,8,123,42]
var.filtered = array.filter(function(obj){
	return obj>=10;
})
```

```js
var stus = [
  { name: "lily", gender: "女" },
  { name: "poly", gender: "男" },
  { name: "hmm", gender: "女" },
  { name: "white", gender: "男" },
];

// 过滤器,提供一个回调函数,得到一个新数组,
// 新数组由回调返回true的单元组成
var news = stus.filter(function (s) {
  return s.gender == "男";
});

console.log(news);
```

`map()`方法返回一个由原数组中的每个元素调用一个指定方法后的返回值组成的新数组。
map 方法会给原数组按照顺序调用一次回调函数进行处理。处理之后的返回值会组合起来形成一个新数组。

```
var numbers = [1,4,9];
var maped = numbers.map(Math.sqrt);
```

```javascript
var score = [34, 52, 68];
console.log(
  score.map(function (val) {
    return val + 10;
  })
);
```

### 7.3 forEach() [ES5]

同上述两个方法一样 `forEach()`也是用来遍历数组并且对数组的每个元素执行一次回调函数。
该回调函数接受三个参数

- 当前元素元素的值
- 当前元素的索引
- 当前数组

```
[2,5,9].forEach(function(element,index,array){
	console.log("a[" + index + "]=" + element);
})
```

### 7.4 reduce() reduceRight() [ES5]

同样是遍历数组，`reduce()`方法接受一个回调函数作为累加器，数组中的每个值（从左到右）开始合并，最终合成一个值。
回调函数包含四个参数

- previsousValue 上一次调用的回调值，或者是给定的初始值
- currentValue 数组中当前被处理的元素
- index 当前元素在数组中的索引值
- array 调用 reduce 的数组

```
[0,1,2,3,4,5].reduce(function(previsousValue,currentValue,index,array)　
	return previousValue + currentValue;
})
```

```javascript
var nums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
for (let i = 0, sum = 0; i < nums.length; i++) {
  sum += nums[i];
}

console.log(
  nums.reduce(function (sum, val) {
    sum += val;
    return sum;
  })
);
```

而`reduceRight()`和`reduce()`方法类似，只是执行顺序是从右到左的。

### 7.5 entries()，keys()和 values()

ES6 提供三个新的方法，`entries()`，`keys()`和`values()`,这三个方法可以用于遍历数组。它们和 for···of 类似，只是`keys()`是针对键名的遍历，`values()`是对键值的遍历，`entries()`是对键值对的遍历。

```js
for (let index of ["a", "b"].keys()) {
  console.log(index);
}
for (let elem of ["a", "b"].values()) {
  console.log(elem);
}
//values暂时不支持
for (let [index, elem] of ["a", "b"].entries()) {
  console.log(index, elem);
}
```

如果不使用原来的 for···of 循环，那么可以手动调用指针，使用`next`方法，进行遍历。

```
let letter = ['a','b','c'];
let entries = letter.entries();
console.log(entries.next().value);
console.log(entries.next().value);
console.log(entries.next().value);
```

### 7.6 Array.from()

`Array.from()`方法用于将两类对象转化成为真正的数组：类似数组的对象（array-likeobject）和可遍历的对象（包括 ES6 新增的数据结构 Set 和 Map）。

```javascript
let arrayLike = {
  0: "a",
  1: "b",
  2: "c",
  length: 3,
};
let arr = Array.from(arrayLike);
```

`Array.from()`的另一个应用是，将字符串转为数组，然后返回字符串的长度。

```
Array.from(string).length;
```

### 7.7 Array.of()

`Array.of()`方法将用于将一组值，转换成为数组。

```
Array.of(3);
Array.of(3,11,9);
```

### 7.8 Array.copyWithin()

数组通过`copyWithin`方法，在当前数组内部，将指定位置的成员复制到其它位置（会覆盖原有的成员），然后返回当前数组。

```
Array.copyWithin(target,start,end);
```

它接受三个参数：

- target(必须)：从该位置开始替换数据。
- start(可选)：从该位置开始读取数据，默认为 0，如果为负值，则表示从末尾开始计数。
- end（可选）：从该位置**前**停止读取数据，默认等于数组长度。如果为负值，表示从末尾开始计数。

```javascript
[1, 2, 3, 4, 5].copyWithin(0, 3, 4);
//[4,2,3,4,5]
```

### 7.9 Array.find() 和 Array.findIndex()

数组实例的`find()`方法，用于找到第一个符合条件的数组成员。它的参数是一个回调函数。所有数组的成员依次执行该回调函数，直到找出第一个返回值为 true 的成员，然后返回该成员。如果没有符合条件的成员，则返回`undefined`
回调函数可以接受三个参数

- value 当前的键值
- index 当前的索引值
- array 原数组

```javascript
[1, 5, 10, 15].find(function (value, index, array) {
  return value > 9;
});
//10
```

数组的`findIndex()`方法和`find()`方法类似，只是返回值是第一个符合条件的数组成员的位置，如果找不到，则返回-1；

```
[1,5,10,15].findIndex(function(value,index,array){
	return value > 9;
})
//2
```

### 7.10 Array.fill()

`fill()`方法使用给定值，填充一个数组。

```
['a','b','c'].fill(7)
//7,7,7
```

上面的代码表明，fill 方法用于空数组的初始化非常方便。数组中已有的元素，会被全部抹去。
fill 方法还可以接受第二个和第三个参数，用于指定填充的起始位置和结束位置。

```
['a','b','c'].fill(7,1,2)
//['a','7','c']
```

### 7.11 includes()

`Array.includes()`方法返回一个布尔值，表示某个数组是否包含给定的值。

```
[1,2,3].includes(2)//true
[1,2,3].includes(4)//false
```

同样该方法可以设置搜索的起始位置，默认为 0.
如果第二个参数为负数，则表示倒数的位置。

```
[1,2,3].includes(3,3) //false
[1,2,3].includes(3,-1)//true
```

### 7.12 数组空位

数组的空位，指的是数组的某一个位置没有任何值。比如，`Array`构造函数返回的数组都是空位

```
Array(3)//[,,,]
```

注意，空位不是`undefined`，一个位置等于`undefined`，依然是有值的。空位没有任何值。

## 八章 Object 对象

### 8.1 属性的简洁写法

```js
var a = 9;
var obj = { a };
console.log(obj);
var age = 19;
var name = "lucy";
//变量名等于属性名时,可以简写
//var stu = {name:name , age:age};
var stu = { name, age };
console.log(stu); //{a:a}
```

同时,方法也可以简写

```js
obj = {
  test() {
    alert("a");
  },
};

/*var dog = {
    bark : function(){
        alert('小黑');
    }
}*/

var dog = {
  ["a" + "g" + "e"]: 23,

  bark() {
    alert("小黑");
  },
};

console.log(dog);
```

### 8.2 属性表达式

```javascript
var obj = {
  name: "lucy",
  ["a" + "ge"]: 19,
};
```

### 8.3 Object.is()

ES5 比较两个值是否相等，只有两个运算符：相等运算符（==）和严格相等运算符（===）。它们都有缺点，前者会自动转换数据类型，后者的 NaN 不等于自身，以及+0 等于-0。JavaScript 缺乏一种运算，在所有环境中，只要两个值是一样的，它们就应该相等。

ES6 提出“Same-value equality”（同值相等）算法，用来解决这个问题。Object.is 就是部署这个算法的新方法。它用来比较两个值是否严格相等，与严格比较运算符（===）的行为基本一致。

```js
Object.is("foo", "foo");
// true
Object.is({}, {});
// false
```

不同之处只有两个：一是+0 不等于-0，二是 NaN 等于自身。

```js
+0 === -0; //true
NaN === NaN; // false

Object.is(+0, -0); // false
Object.is(NaN, NaN); // true
```

### 8.4 Object.assign()

```javascript
// Object.assign()复制其他对象的属性
var tiger = { leg: 4 };
Object.assign(tiger, {
  climb: function () {
    alert("爬树");
  },
});

console.log(tiger);
```

用途:

- 便捷添加属性
- 克隆对象
- 合并对象
- 添加默认值

### 8.5 keys(),values(),entries()

类似数组的方法

## 九章 Function 的变化

### 9.1 参数默认值

```js
function add(score, incr = 10) {
  return score + mul;
}

add(5, 1); //6
add(5); // 15
```

> 注意,默认参数应该写在最后一位.

### 9.2 不定参数

不定形参

```js
function add(score, ...other) {
  console.log(other);
}

add(60, 3, 4, 5);
```

不定实参

```
function sum2(a,b,c,d) {
    console.log(a,b,c,d);
}
var row = ['lucy' , 'poly' , 'hmm' , 'lilei'];
//sum2(row[0] , row[1] , row[2] , row[3]);
sum2(...row);
```

### 9.3 箭头函数

ES6 允许使用箭头来定义函数
函数表示的其实就是一种映射关系.

```javascript
var f = (v) => v;
```

上面的箭头函数等同于：

```javascript
var f = function (v) {
  return v;
};
```

对比:

```javascript
var name = "window name";
var obj = {
  name: "obj name",
  getName: function () {
    return function () {
      console.log(this.name);
    };
  },
};
obj.getName()();
```

```javascript
//箭头函数的this作用域遗传自他的生成环境
var name = "window name";
var obj = {
  name: "obj name",
  getName: function () {
    return () => {
      console.log(this.name);
    };
  },
};
obj.getName()();
```

箭头将 this 函数绑定所在作用域.

###9.4 this 绑定

this 的绑定方法可以使 this 的指向变为 bind 生效的作用域内

```js
var obj = {
  0: "lisi",
  1: "wangwu",
  2: "zhaoliu",
  length: 3,
  getName: function (callback) {
    for (i = 0; i < this.length; i++) callback(i);
  },
};
var c = function (i) {
  console.log(this[i]);
};
obj.getName(c);
```

对比

```js
var obj = {
  0: "lisi",
  1: "wangwu",
  2: "zhaoliu",
  length: 3,
  getName: function (callback) {
    for (i = 0; i < this.length; i++) callback.bind(this)(i);
    // callback.call(this,i)
  },
};
var c = function (i) {
  console.log(this[i]);
};
obj.getName(c);
```

## 十章 Set 与 Map

### 10.1 Set 集合

set 是数据的集合，具有确定性，无序性，唯一性。

```js
var s = new Set();
s.add(3);
s.add(5);
s.add(6);
s.add(6);

console.log(s);
```

Set 的相关方法

- add()
- delete
- has()
- clear()

我们在初始化 set 的时候，可以序列化的加入一些内容。

### 10.2 Map

JavaScript 的对象（Object），本质上是键值对的集合（Hash 结构），但是传统上只能用字符串当作键。这给它的使用带来了很大的限制。
为了解决这个问题，ES6 提供了 Map 数据结构。它类似于对象，也是键值对的集合，但是“键”的范围不限于字符串，各种类型的值（包括对象）都可以当作键。也就是说，Object 结构提供了“字符串—值”的对应，Map 结构提供了“值—值”的对应，是一种更完善的 Hash 结构实现。

```js
var sym = {};
var m = new Map();
m.set("name", "lucy");
m.set(sym, "lily");
m.set({}, function () {});

console.log(m);
console.log(m.get({}));
console.log(m.get(sym));
```

### 10.3 Map 相关方法

- set()
- get()
- has()
- delete()
- clear()

## 十一章 Generator 生成器

生成器是一种特殊的函数,这种函数执行,不是直接`return`结果.
而是得到一个处于"执行状态"的函数.
这个函数,而以逐步执行,逐步返回结果.
在我们的开发过程中，经常会遇到从一个接口收集数据，用于另外的程序的情景，这时候用生成器就显得十分方便。

```js
function m1() {
  var arr = [];

  for (let i = 0; i < 5; i++) {
    arr.push(i);
  }

  return arr;
}

var rs = m1();
console.log(rs);

for (let i = 0; i < rs.length; i++) {
  console.log(rs[i]);
}
```

```js
function* make() {
  for (let i = 0; i < 10; i++) {
    yield i;
  }
}

var getI = make();
console.log(getI.next());
```

## 十二章 Iterator 迭代器

### 12.1 　 for...of 用法

JS 中原有的数组,对象,及 ES6 新增了 Set,Map,如何遍历?
Iterator 给我们带来了相对统一的方式,即 for...of

数组、Set 和 Map 结构、某些类似数组的对象（比如 arguments 对象、DOM NodeList 对象）、Generator 对象，以及字符串

```js
let str = "hello";
for (let s of str) {
  console.log(s);
}
```

```js
let arr = ["东", "南", "西"];
for (let a of arr) {
  console.log(a);
}
```

```js
let sts = new Set(["春", "夏", "秋"]);
for (let s of sts) {
  console.log(s);
}
```

```js
let maps = new Map([
  ["name", "lucy"],
  ["age", 9],
]);
for (let m of maps) {
  console.log(m);
}
```

```js
function* makeSn() {
  for (let i = 0; i < 5; i++) {
    yield i;
  }
}

for (let sn of makeSn()) {
  console.log(sn);
}
```

### 12.2 三种遍历方式

原始的 for 循环

```js
for (var index = 0; index < myArray.length; index++) {
  console.log(myArray[index]);
}
```

es5 新增的 forEach()

```js
// 自动给你的回调函数传递3个参数(单元的值,单元的键,数组本身)

["a", "b", "c"].forEach(function (val, key, arr) {
  // if(val == 'b') break; //forEach中不能break

  console.log(val);
});
```

缺点:无法跳出 forEach 循环,break 失效

for...in

```javascript
//for...in循环可以遍历数组的键名。

for (let k in arr) {
  console.log(typeof k); // string
}
```

缺点:

- for...in 循环主要是为遍历对象而设计的，不适用于遍历数组。
- 数组的键名是数字，但是 for...in 循环是以字符串作为键名“0”、“1”、“2”等等。
- for...in 循环不仅遍历数字键名，还会遍历手动添加的其他键，甚至包括原型链上的键。
- 不敢保证遍历的键的顺序。

for...of

```js
var arr=['a' , 'b' , 'c'];

for(let i in arr) {
    console.log(typeof i);
}


for(let i of arr) {
    if(i == 'b') {
        break;
    }

    console.log(i);
}
}
```

- 有着同 for...in 一样的简洁语法，但是没有 for...in 那些缺点。
- 不同用于 forEach 方法，它可以与 break、continue 和 return 配合使用。
- 提供了遍历所有数据结构的统一操作接口。

## 十三章 Class

```js
class Cat {
  constructor(color, leg) {
    this.color = color;
    this.leg = leg;
  }
}

class Tiger extends Cat {
  constructor(color, leg) {
    super(color, leg);
    this.hunt = function () {};
  }
}
```
