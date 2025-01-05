//配置axios
import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'


//基础配置
const request = axios.create({
  baseURL: 'https://meikou-api.itheima.net/',
  timeout: 5000,
})

//请求拦截器
request.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    //config.headers.Authorization = 'Bearer ' + GlobalVariable.TOKEN
    return config
  },
  (error: AxiosError) => {
    return Promise.reject(error)
  }
)

//响应拦截器
request.interceptors.response.use(
  (response: AxiosResponse) => {
    return response.data
  },
  (error: AxiosError) => {
    return Promise.reject(error)
  }
)


// 抽取公共部分
export
interface HTTpResponse<T> {
  code: string,
  msg: string,
  result: T
}

// 简化后续编码
export type ResponseType<T> = AxiosResponse<HTTpResponse<T>>

//请求方式
export class RequestAxios {
  // 查询方法
  // get和post区别- get的参数只能拼接到url地址上- 又叫做查询参数 query参数 url地址参数 地址栏参数 get参数
  static get<T>(url: string, params?: object): Promise<ResponseType<T>> {
    return request.get<null, ResponseType<T>>(url, { params })
  }

  // 新增方法
  static post<T>(url: string, data?: object): Promise<ResponseType<T>> {
    return request.post<null, ResponseType<T>>(url, data)
  }

  // 修改方法
  static put<T>(url: string, data?: object): Promise<ResponseType<T>> {
    return request.put<null, ResponseType<T>>(url, data)
  }

  // 删除方法
  static delete<T>(url: string, data?: object): Promise<ResponseType<T>> {
    return request.delete<null, ResponseType<T>>(url, data)
  }
}
