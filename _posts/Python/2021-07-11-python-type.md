---
title: Python 数据类型
tags: Python
---

# Python 数据类型

Python 是一种动态类型语言，这意味着变量的数据类型在运行时可以改变。Python 支持许多不同的数据类型，包括数字、字符串、列表、元组、集合和字典。在本文中，我们将介绍 Python 中的每种数据类型及其用法。<!--more-->

## 数字

Python 中的数字包括整数、浮点数和复数。整数是没有小数部分的数字，浮点数是具有小数部分的数字，而复数是由实数和虚数部分组成的数字。

以下是一些 Python 数字的示例：

```python
x = 1    # 整数
y = 2.8  # 浮点数
z = 1j   # 复数
```

Python 还支持各种数字运算，例如加法、减法、乘法和除法。以下是一些 Python 数字运算的示例：

```python
x = 5
y = 3

print(x + y) # 输出 8
print(x - y) # 输出 2
print(x * y) # 输出 15
print(x / y) # 输出 1.6666666666666667
print(x % y) # 输出 2
print(x ** y) # 输出 125
```

## 字符串

Python 中的字符串是由一系列字符组成的。字符串可以用单引号或双引号括起来。Python 中的字符串是不可变的，这意味着一旦创建了一个字符串，就无法更改其内容。

以下是一些 Python 字符串的示例：

```python
a = "Hello, World!"
print(a)

b = 'Hello, World!'
print(b)
```

Python 还支持各种字符串操作，例如字符串连接、字符串格式化和字符串索引。以下是一些 Python 字符串操作的示例：

```python
a = "Hello"
b = "World"
c = a + b
print(c) # 输出 HelloWorld

age = 36
txt = "My name is John, and I am {}"
print(txt.format(age)) # 输出 My name is John, and I am 36

a = "Hello, World!"
print(a[1]) # 输出 e
```

## 列表

Python 中的列表是由一系列值组成的。列表中的值可以是任何数据类型，并且可以包含不同类型的值。列表是可变的，这意味着可以更改列表中的值。

以下是一些 Python 列表的示例：

```python
mylist = ["apple", "banana", "cherry"]
print(mylist)

mylist = ["apple", 1, True]
print(mylist)
```

Python 还支持各种列表操作，例如列表索引、列表切片和列表排序。以下是一些 Python 列表操作的示例：

```python
mylist = ["apple", "banana", "cherry"]
print(mylist[1]) # 输出 banana

mylist = ["apple", "banana", "cherry"]
print(mylist[1:3]) # 输出 ["banana", "cherry"]

mylist = [3, 2, 1]
mylist.sort()
print(mylist) # 输出 [1, 2, 3]
```

## 元组

Python 中的元组与列表非常相似，但是元组是不可变的，这意味着一旦创建了一个元组，就无法更改其内容。

以下是一些 Python 元组的示例：

```python
mytuple = ("apple", "banana", "cherry")
print(mytuple)

mytuple = ("apple", 1, True)
print(mytuple)
```

Python 还支持各种元组操作，例如元组索引和元组切片。以下是一些 Python 元组操作的示例：

```python
mytuple = ("apple", "banana", "cherry")
print(mytuple[1]) # 输出 banana

mytuple = ("apple", "banana", "cherry")
print(mytuple[1:3]) # 输出 ("banana", "cherry")
```

## 集合

Python 中的集合是由一组唯一的元素组成的。集合是可变的，这意味着可以添加或删除集合中的元素。

以下是一些 Python 集合的示例：

```python
myset = {"apple", "banana", "cherry"}
print(myset)

myset = set(["apple", "banana", "cherry"])
print(myset)
```

Python 还支持各种集合操作，例如集合交集、集合并集和集合差集。以下是一些 Python 集合操作的示例：

```python
set1 = {"apple", "banana", "cherry"}
set2 = {"google", "microsoft", "apple"}

print(set1.intersection(set2)) # 输出 {"apple"}
print(set1.union(set2)) # 输出 {"apple", "banana", "cherry", "google", "microsoft"}
print(set1.difference(set2)) # 输出 {"banana", "cherry"}
```

## 字典

Python 中的字典是由一组键值对组成的。字典中的键必须是唯一的，但是值可以重复。

以下是一些 Python 字典的示例：

```python
mydict = {"name": "John", "age": 36}
print(mydict)

mydict = dict(name="John", age=36)
print(mydict)
```

Python 还支持各种字典操作，例如字典访问、字典添加和字典删除。以下是一些 Python 字典操作的示例：

```python
mydict = {"name": "John", "age": 36}
print(mydict["name"]) # 输出 John

mydict = {"name": "John", "age": 36}
mydict["email"] = "john@example.com"
print(mydict)

mydict = {"name": "John", "age": 36}
del mydict["age"]
print(mydict)
```

## 结论

Python 是一种功能强大的编程语言，具有许多不同的数据类型。在本文中，我们介绍了 Python 中的数字、字符串、列表、元组、集合和字典，并介绍了每种数据类型的用法和操作。希望这篇文章能够帮助你更好地理解 Python 中的数据类型！
