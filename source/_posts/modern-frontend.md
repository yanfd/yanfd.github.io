---
title: modern frontend
date: 2025-04-03 00:58:40
tags:
description: 前端的所见即所得
cover: https://p.ipic.vip/yxflz9.png
---

[toc]

做了一些前端内容，在这里存放一些记录。

由于个人笔记常用的是obsidian+云同步，所以图片在粘贴到typora时需要手动贴图床粘过来，可能会有遗漏。

---

# 前言

最近在写tailwind+typescript+next.js的组合，老实说发现现代前端甚至连html都不用写了的时候，是非常惊讶的

tailwind更是，虽然被人诟病导致代码变长变宽，但所见即所得的方式让我这种markdown爱好者非常喜欢，也不用像以前那样去手搓一堆一堆的css



https://x.com/rodreick007/status/1907483864806887502?s=46

https://pbs.twimg.com/media/Gni-doEa8AAQ6G_.jpg

![](https://pbs.twimg.com/media/Gni-doEa8AAQ6G_.jpg)



# 组件

## **tips and tricks**

1. 这个fluid texts非常他妈的好看，很细腻的响应式文字
```tsx
<！--Fluid Texts-->
<p class="text-[min(10vw,70px)]">Something Fluid</p>
<！--F1le-->
```

2. accent（改变例如checkbox之类老html元素的颜色等
```tsx
<!--Accent -->
<div class="my-4 flex flex-col text-white ml-2">
<label><input type="checkbox"checked /Browser default </label>
<label><input type="checkbox"class="accent-pink-500"checked /Customized label>
</div>
```

```python
from xxx import xxx
print(f"test{variation}")

```

3. 文件上传按钮，在class里输入file即可
```tsx
<!--File-->
<label class="my-4 block">
<input type="file" class="block w-full text-sm text-slate-500 file:mr-4 file:rounded-full file:border-0 file:bg-violet-50 file:px-4 file:py-2
file:text-sm file:font-semibold file:text-violet-700 hover:file:bg-violet-100" >
</label>
```


4. 选中高亮
```tsx

<!--Highlight -->
<div class="selection:bg-green-400 selection:text-white">
```

5. less js/ts，一些extra。直接在tailwintailwind网站上cmd+k搜索
![](https://p.ipic.vip/o6ljub.png)
6. 

## 其他

组件
在app结构下，创建(components)的文件夹，然后这个目录不会被读到
里面可以放很多不同组件，调用的时候使用
⬇️import XXXX from 组件目录
```tsx
import Navbar from '../(components)/nav';
```
并在html里用的地方调用
```tsx
<Navbar />
```


# directives提示
## base components utilities结构

base（全局元素应用样式
	components（组件，header、footer、card等等
		utilities（原子样式，给margin、padding等小件用
		utilities
	components
		utilities
		utilities
	components
		utilities
		utilities

## @layer
需要和@apply组合使用

@layer base 基础组件，p，h1之类
@layer components 自定义名字的卡片之类的，用的时候直接放到classname里


layer例子
```tsx
@layer components{
	.card{
		@appty m-10 rounded-lg bg-white px-6 py-8 shadow-xl ring-1	□ring-slate-.9o0/5▣dark:bg-black 
	}
}
```
使用时只需要
```tsx
<div className = 'card'>card text</div>
```

## @utility
定义一个专门的样式，这样在组件class调用的时候会用的比较方便
![](https://p.ipic.vip/a3phau.png)

![](https://p.ipic.vip/fwc64u.png)







## utilities

有些未定义的css，可以用[]的形式写明
例如 text-[10px]


| Utility Class                 | Options/Values                                               | Description           |
| ----------------------------- | ------------------------------------------------------------ | --------------------- |
| `bg-{color}`                  | `slate-50` to `slate-900`, `black`, `white`, `transparent`, `current` | 设置背景颜色          |
| `text-{color}`                | `slate-50` to `slate-900`, `black`, `white`, `transparent`, `current` | 设置文本颜色          |
| `font-{weight}`               | `thin`, `extralight`, `light`, `normal`, `medium`, `semibold`, `bold`, `extrabold`, `black` | 设置字体粗细          |
| `text-{size}`                 | `xs`, `sm`, `base`, `lg`, `xl`, `2xl` to `9xl`               | 设置字体大小          |
| `p-{size}`                    | `0` to `96`, `px` (1px)                                      | 设置内边距（padding） |
| `m-{size}`                    | `0` to `96`, `px` (1px), `auto`                              | 设置外边距（margin）  |
| `w-{size}`                    | `0` to `96`, `px`, `auto`, `full`, `screen`, `min`, `max`, `fit` | 设置宽度              |
| `h-{size}`                    | `0` to `96`, `px`, `auto`, `full`, `screen`, `min`, `max`, `fit` | 设置高度              |
| `rounded-{size}`              | `none`, `sm`, `md`, `lg`, `xl`, `2xl`, `3xl`, `full`         | 设置圆角              |
| `border-{size}`               | `0`, `2`, `4`, `8`                                           | 设置边框宽度          |
| `shadow-{size}`               | `sm`, `md`, `lg`, `xl`, `2xl`, `none`                        | 设置阴影              |
| `flex`                        | `row`, `row-reverse`, `col`, `col-reverse`                   | 设置 Flex 布局        |
| `justify-{position}`          | `start`, `end`, `center`, `between`, `around`, `evenly`      | 设置 Flex 主轴对齐    |
| `items-{position}`            | `start`, `end`, `center`, `baseline`, `stretch`              | 设置 Flex 交叉轴对齐  |
| `grid`                        | `cols-1` to `cols-12`, `rows-1` to `rows-6`                  | 设置 Grid 布局        |
| `gap-{size}`                  | `0` to `96`, `px`                                            | 设置 Grid/Flex 间距   |
| `hidden` / `block`            | `inline`, `inline-block`, `flex`, `grid`, `none`             | 控制显示/隐藏         |
| `opacity-{value}`             | `0` to `100`                                                 | 设置透明度            |
| `transition`                  | `none`, `all`, `colors`, `opacity`, `shadow`, `transform`    | 设置过渡效果          |
| `duration-{time}`             | `75`, `100`, `150`, `200`, `300`, `500`, `700`, `1000` (ms)  | 设置过渡时间          |
| `hover:`, `focus:`, `active:` | 所有工具类前加前缀                                           | 设置伪类状态          |
| `dark:`                       | 所有工具类前加前缀                                           | 暗黑模式样式          |
| `md:`, `lg:`, `xl:`           | 所有工具类前加前缀                                           | 响应式断点            |
| `animate-{type}`              | `spin`, `ping`, `pulse`, `bounce`                            | 设置动画效果          |
| `z-{index}`                   | `0` to `50`, `auto`                                          | 设置 z-index          |
| `overflow-{type}`             | `auto`, `hidden`, `visible`, `scroll`                        | 设置溢出行为          |
| `cursor-{type}`               | `auto`, `default`, `pointer`, `wait`, `text`, `move`, `not-allowed` | 设置鼠标指针样式      |
| `select-{type}`               | `none`, `text`, `all`, `auto`                                | 设置文本选择行为      |
| `whitespace-{type}`           | `normal`, `nowrap`, `pre`, `pre-line`, `pre-wrap`, `break-spaces` | 设置空白处理方式      |
| `break-{type}`                | `normal`, `words`, `all`, `keep`                             | 设置文本换行行为      |
| `object-{type}`               | `contain`, `cover`, `fill`, `none`, `scale-down`             | 设置图片填充方式      |
| `aspect-{ratio}`              | `auto`, `square`, `video`                                    | 设置宽高比            |

## margin/padding

margin不只有margintop（mt-4)之类，还可以写成my-4，意思是上+下。同理mx-4是左右
什么都不加直接m-4，代表所有面

margin控制div的大小，并且会推开其他div
padding则会向内推，把组件变小

![](https://p.ipic.vip/4xkhf6.png)

# layout

![](https://p.ipic.vip/yxflz9.png)


| 工具类           | 控制的轴   | 作用范围           | 典型使用场景                     |
| ---------------- | ---------- | ------------------ | -------------------------------- |
| `flex`           | -          | 容器级             | 启用 Flexbox 布局                |
| `justify-center` | **主轴**   | 子元素在主轴的对齐 | 水平居中（默认主轴为水平方向）   |
| `items-center`   | **交叉轴** | 子元素在交叉轴对齐 | 垂直居中（默认交叉轴为垂直方向） |

# position
- absolute
- relative
- fixed (sticks on front doesnt scroll)
- sticky (behave normally before scroll to certern point)

# display
## property 
 - flex
	- justify
		- start
		- end
		- evenly(比较喜欢这个)
	- space
		- ![[Screenshot 2025-03-29 at 16.45.38.png]]
	- flex-col 垂直flex
 - grid 网格布局，会自动铺满
	- grid-cols

# flexbox

# 响应式
移动端优先原则
把utilities当作断点，而不是情况

也就是说在未指定大小情况下，默认是给移动端用的
![](https://p.ipic.vip/vij1ay.png)
sm 代表small以及small以上
md
lg
