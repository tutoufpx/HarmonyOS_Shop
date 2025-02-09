import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { display, window } from '@kit.ArkUI';
import { Logger, BreakpointConstants } from 'basic'
import { deviceInfo } from '@kit.BasicServicesKit';

export default class EntryAbility extends UIAbility {
  private windowObj?: window.Window
  private curBp: string = ''

  // 根据当前尺寸获取窗口的变化
  private updateBreakpoint(windowWidth: number): void {
    // 将长度的单位由px换算为vp
    let windowWidthVp = windowWidth / display.getDefaultDisplaySync()
      .densityPixels
    let newBp: string = ''
    if (windowWidthVp < 320) {
      newBp = BreakpointConstants.XS
    } else if (windowWidthVp < 600) {
      newBp = BreakpointConstants.SM
    } else if (windowWidthVp < 840) {
      newBp = BreakpointConstants.MD
    } else {
      newBp = BreakpointConstants.LG
    }
    if (this.curBp !== newBp) {
      this.curBp = newBp
      // 使用状态变量记录当前断点值
      AppStorage.setOrCreate('currentBreakpoint', this.curBp)
    }
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // 在不是2in1 的情况下  开启沉静模式
    if (deviceInfo.deviceType !== "2in1") {
      //   开启全屏
      const win = windowStage.getMainWindowSync()
      win.setWindowLayoutFullScreen(true)
      //   获取安全高度
      const topHeight = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect
      AppStorage.setOrCreate<number>('safeTop', px2vp(topHeight.height))
      const bottom = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR)
        .bottomRect
      AppStorage.setOrCreate<number>('safeBottom', px2vp(bottom.height))
      
    }
    // Main window is created, set main page for this ability
    {
      hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    }

    windowStage.getMainWindow()
      .then((windowObj) => {
        this.windowObj = windowObj
        // 获取应用启动时的窗口尺寸
        this.updateBreakpoint(windowObj.getWindowProperties()
          .windowRect
          .width)
        // 注册回调函数，监听窗口尺寸变化
        windowObj.on('windowSizeChange', (windowSize) => {
          this.updateBreakpoint(windowSize.width)
        })
      });

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {

    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}