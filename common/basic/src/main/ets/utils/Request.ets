import axios, { InternalAxiosRequestConfig, AxiosError, AxiosResponse } from '@ohos/axios'

// 实例化 通用配置
const request = axios.create({
  baseURL: 'https://meikou-api.itheima.net/',
  timeout: 5000
})

// 拦截器配置
// 请求拦截器
// token配置等
request.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  return config
}, (error: AxiosError) => {
  return Promise.reject(error)
})


// 添加响应拦截器
// 错误统一处理等
request.interceptors.response.use((response: AxiosResponse) => {
  return response
}, (error: AxiosError) => {
  return Promise.reject(error)
})

// 抽取公共部分
export interface HttpResponse<T> {
  code: string
  msg: string
  result: T
}

// 简化后续编码
export type ResponseType<T> = AxiosResponse<HttpResponse<T>>


export class RequestAxios {
  static get<T>(url: string, params?: object): Promise<ResponseType<T>> {
    return request.get<null, ResponseType<T>>(url, { params })
  }

  static post<T>(url: string, data?: object): Promise<ResponseType<T>> {
    return request.post<null, ResponseType<T>>(url, data)
  }

  static delete<T>(url: string, data?: object): Promise<ResponseType<T>> {
    return request.delete<null, ResponseType<T>>(url, data)
  }

  static put<T>(url: string, data?: object): Promise<ResponseType<T>> {
    return request.put<null, ResponseType<T>>(url, data)
  }
}

