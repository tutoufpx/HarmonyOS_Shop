import { mediaquery } from "@kit.ArkUI"
import { GlobalVariable } from "../constants"
import { BreakPointEnum } from "../viewmodel/break_point"


export class ScreenManagerByMedia {
  // 监测屏幕的大小变化
  registerListenerScreen() {
    let xsListener = mediaquery.matchMediaSync("(0vp<=width<320vp)")
    let smListener = mediaquery.matchMediaSync("(320vp<=width<600vp)")
    let mdListener = mediaquery.matchMediaSync("(600vp<=width<840vp)")
    let lgListener = mediaquery.matchMediaSync("(840vp<=width)")
    xsListener.on("change", (res) => {
      if (res.matches) {
        this.setBreakPoint(BreakPointEnum.xs)
      }
    })
    smListener.on("change", (res) => {
      if (res.matches) {
        this.setBreakPoint(BreakPointEnum.sm)
      }
    })
    mdListener.on("change", (res) => {
      if (res.matches) {
        this.setBreakPoint(BreakPointEnum.md)
      }
    })
    lgListener.on("change", (res) => {
      if (res.matches) {
        this.setBreakPoint(BreakPointEnum.lg)
      }
    })
  }

  unregisterListenerScreen() {
    let xsListener = mediaquery.matchMediaSync("(0vp<=width<320vp)")
    let smListener = mediaquery.matchMediaSync("(320vp<=width<600vp)")
    let mdListener = mediaquery.matchMediaSync("(600vp<=width<840vp)")
    let lgListener = mediaquery.matchMediaSync("(840vp<=width)")
    xsListener.off("change")
    smListener.off("change")
    mdListener.off("change")
    lgListener.off("change")
  }

  setBreakPoint(breakPoint: string) {
    AppStorage.setOrCreate<string>(GlobalVariable.BREAK_POINT_KEY, breakPoint)
  }
}

export const screenManagerByMedia = new ScreenManagerByMedia()