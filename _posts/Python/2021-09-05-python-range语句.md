---
title: Python语句---range语句
tags: Python
---

ange()语句是Python内置函数之一，用于生成一个整数序列，常用于循环操作、索引计算和进度条显示等场景。

## 一、range语句的原理
- range()语句是一个内置函数，用于生成一个整数序列。它的基本语法如下：

````python
range(start, stop[, step])
````

其中，start表示序列的起始值，stop表示序列的结束值（不包含在序列中），step表示序列的步长。range()语句会生成一个从start开始、以step为步长、到stop结束的整数序列。

- 例如，以下代码会生成一个从0开始、以2为步长、到4（不包含4）结束的整数序列：

````python
range(0, 4, 2)

输出结果为：[0, 2, 4]。
````



## 二、range()语句的使用方法

在Python中，我们可以使用range()语句进行循环操作、索引计算和进度条显示等操作。以下是一些使用方法：

1. 循环操作

   使用range()语句可以方便地实现循环操作。例如，以下代码使用range()语句生成了一个从0到9的整数序列，并使用for循环遍历输出每个数：

   ````python
   for i in range(10):  
       print(i)
       
   输出结果为：[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]。
   ````

2. 索引计算

   使用range()语句可以方便地进行索引计算，例如，以下代码使用range()语句生成了一个从0到3的整数序列，并使用list和enumerate函数将其转换为列表的索引和值：

   ````python
   my_list = ['a', 'b', 'c', 'd']
   for i, value in enumerate(my_list):
       print(i, value)
   
   输出结果为：('0', 'a') ('1', 'b') ('2', 'c') ('3', 'd')
   ````