import { speechRecognizer } from '@kit.CoreSpeechKit';
import { KeyboardAvoidMode, window } from '@kit.ArkUI';
import { audio } from '@kit.AudioKit';
import { permissionPlugin } from 'basic';

export enum VoiceState {
  DEFAULT,
  VOICING,
  VOICEOVER
}

@Component
export struct AudioSearchComp {
  @State voiceState: VoiceState = VoiceState.DEFAULT
  keyword: string = ''
  audioCapturer: audio.AudioCapturer | null = null
  asrEngine: speechRecognizer.SpeechRecognitionEngine | null = null
  onChange: (keyword: string) => void = () => {
  }
  onComplete: (keyword: string) => void = () => {
  }

  async startRecord() {

  }

  async closeRecord() {

  }

  aboutToAppear(): void {
    // 键盘避让
    window.getLastWindow(getContext())
      .then((win) => {
        win.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE)
      })

    //申请麦克风权限
    permissionPlugin.requestPermissions(['ohos.permission.MICROPHONE'])

  }

  build() {
    Column() {
      if (this.voiceState !== VoiceState.DEFAULT) {
        Column({ space: 16 }) {
          if (this.voiceState === VoiceState.VOICING) {
            Text('请说话~~')
              .fontSize(14)
          } else if (this.voiceState === VoiceState.VOICEOVER && this.keyword == '') {
            Text('请再次说话~~')
              .fontSize(14)
          }
          Text() {
            Span('你可以说~~')
            Span('哎呦,你干嘛~~')
              .fontColor($r('[basic].color.gray'))
          }
          .fontSize(12)

        }
        .justifyContent(FlexAlign.Center)
        .height(150)
      }
      Blank()
      Button() {
        Row({ space: 5 }) {
          Image($r('sys.media.ohos_ic_public_voice'))
            .width(16)
            .aspectRatio(1)
            .fillColor($r('[basic].color.white'))
          if (this.voiceState === VoiceState.VOICING) {
            Text('立即搜索')
              .fontSize(14)
              .fontColor($r('[basic].color.white'))
          } else {
            Text('长按语音搜索')
              .fontSize(14)
              .fontColor($r('[basic].color.white'))
          }
        }
      }
      .padding({ left: 12, right: 12 })
      .height(36)
      .linearGradient({
        angle: 135,
        colors: [[$r('[basic].color.linear_begin'), 0], [$r('[basic].color.linear_end'), 1]],
      })
      .margin({ bottom: 16 })
      .gesture(LongPressGesture()
        .onAction(() => {
          this.startRecord()
        })
        .onActionCancel(() => {
          this.closeRecord()
        })
        .onActionEnd(() => {
          this.closeRecord()
        })
      )

    }
    .layoutWeight(1)
    .width('100%')
    // .backgroundImage($r('app.media.search_bg'))
    .backgroundImageSize(ImageSize.Contain)
    .backgroundImagePosition(Alignment.Bottom)
    .onVisibleAreaChange([0, 1], () => {
      this.keyword = ''
      this.voiceState = VoiceState.DEFAULT
    })
  }
}