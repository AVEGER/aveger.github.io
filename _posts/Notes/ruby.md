## ruby项目遇到的问题

### 报错，错误信息

#### 代码块中遇到 {{}} 会报错，因为Liquid不会识别 {{}} 里面的内容包括大括号；; Liquid Warning: Liquid syntax error (line 94): Unexpected character $ in "{{ $store.getters.outdata }}" 

​	解决办法：Liquid 将所有实例解析为 Liquid 构造。要告诉 Liquid 不要解析此类实例，请将代码包装在 Liquid 的块中：{{}}
```html
<template>
	<h1>Create Event, {% raw %}{{ $store.state.user.name }}{% endraw %}</h1>
</template>
```

