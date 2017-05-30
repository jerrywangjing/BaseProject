 //
//  macros.h
//  AppForTemplate
//
//  Created by jerry on 2017/5/26.
//  Copyright © 2017年 jerry. All rights reserved.
//

#ifndef macros_h
#define macros_h

// notes : 定义网络请求接口，api,测试服务器，生产服务器等

//接口主api

#ifdef DEBUG
//Debug状态下的测试API
#define API_BASE_URL_STRING     @"http://boys.test.companydomain.com/api/"

#else
//Release状态下的线上API
#define API_BASE_URL_STRING     @"http://www.companydomain.com/api/"

#endif

//接口

#define COMMENT_PUBLISH         @"comment/publish"          //发布评论

#define COMMENT_DELETE          @"comment/delComment"      //删除评论
#define LOGINOUT                @"common/logout"            //登出


#endif /* macros_h */
