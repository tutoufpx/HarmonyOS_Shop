import {  RequestAxios } from "basic"
import { Banner,CategoryItem } from "../viewmodel"

//获取轮播图
export const getBannerApi = () => {
  return RequestAxios.get<Banner[]>('/home/banner')
}

// 获取分类数据
export const getCategoryApi = () => {
  return RequestAxios.get<CategoryItem[]>('/home/category/head')
}

