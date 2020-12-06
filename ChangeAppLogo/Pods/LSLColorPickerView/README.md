# ColorPickerView
##学习Keynote，写了个属于自己的颜色选择器，用CALayer和其子类显示颜色条，用UIWindow自己封装成MenuController等等，代码高度内聚（一个类搞定），且简单实用。


### 一、实用说明：
#### 1.实例化

```objc 

    /// color picker view (size must be given)
	_colorPickerView = [[LSLHSBColorPickerView alloc] initWithFrame:_contentView.bounds];	
    [_contentView addSubview:_colorPickerView];	
    
	/// selected color preview	
    _currentSelectedColorPreview.backgroundColor = _colorPickerView.preColor;
    
    /// selected color block	
    __weak typeof(self) weakSelf = self;	
    [_colorPickerView colorSelectedBlock:^(UIColor *color, BOOL isConfirm) {	
        /// do something...	
        ///	
        weakSelf.currentSelectedColorPreview.backgroundColor = color;	
        weakSelf.currentSelectedColor = color;	
    }];	
```

#### 2.保存（或清空）本地文档（归档）中的数据

```objc
#pragma mark - save or clean colors in archiver

- (IBAction)saveSelectedColorToArchiver {
    if (self.currentSelectedColor) {
        [self.colorPickerView saveSelectedColorToArchiver];
        self.currentSelectedColor = nil;
    }
}

- (IBAction)cleanCache:(id)sender {
    [LSLHSBColorPickerView cleanSelectedColorInArchiver];
}
	
```

###二、GIF演示
![](https://github.com/SilongLi/ColorPickerView/raw/master/LSLColorPikerDemo/GIF/colorPickerView.gif)