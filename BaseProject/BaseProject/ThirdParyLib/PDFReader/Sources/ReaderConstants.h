//
//	ReaderConstants.h
//	Reader v2.8.6
//
//	Created by Julius Oklamcak on 2011-07-01.
//	Copyright © 2011-2015 Julius Oklamcak. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//	of the Software, and to permit persons to whom the Software is furnished to
//	do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#if !__has_feature(objc_arc)
	//#error ARC (-fobjc-arc) is required to build this code.
#endif

#import <Foundation/Foundation.h>

#define READER_FLAT_UI TRUE    // 设置UI显示模式，true 为扁平化 false为拟物化
#define READER_SHOW_SHADOWS TRUE  // 是否开启文档阴影
#define READER_ENABLE_THUMBS TRUE  // 是否开启缩略图考航
#define READER_DISABLE_RETINA FALSE // retina 显示开关
#define READER_ENABLE_PREVIEW TRUE // 预览开关
#define READER_DISABLE_IDLE FALSE  // If TRUE, the iOS idle timer is disabled while viewing a document (beware of battery dr
#define READER_STANDALONE FALSE // 是否显示Done按钮来关闭文档
#define READER_BOOKMARKS TRUE  // true 是显示书签功能
