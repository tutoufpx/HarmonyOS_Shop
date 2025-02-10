import { speechRecognizer } from '@kit.CoreSpeechKit';
import { KeyboardAvoidMode, window } from '@kit.ArkUI';
import { audio } from '@kit.AudioKit';
import { permissionPlugin } from 'basic';
import { fileIo as fs } from '@kit.CoreFileKit';

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
    //结合官方代码整合
    let audioStreamInfo: audio.AudioStreamInfo = {
      samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_48000, // 采样率
      channels: audio.AudioChannel.CHANNEL_2, // 通道
      sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE, // 采样格式
      encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW // 编码格式
    };
    let audioCapturerInfo: audio.AudioCapturerInfo = {
      source: audio.SourceType.SOURCE_TYPE_MIC, // 音源类型
      capturerFlags: 0 // 音频采集器标志
    };
    let audioCapturerOptions: audio.AudioCapturerOptions = {
      streamInfo: audioStreamInfo,
      capturerInfo: audioCapturerInfo
    };

    let path = getContext().cacheDir;
    let filePath = path + '/StarWars10s-2C-48000-4SW.pcm';
    let file: fs.File = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    let bufferSize: number = 0

    class Options {
      offset?: number;
      length?: number;
    }

    let readDataCallback = (buffer: ArrayBuffer) => {
      let options: Options = {
        offset: bufferSize,
        length: buffer.byteLength
      }
      fs.writeSync(file.fd, buffer, options);
      bufferSize += buffer.byteLength;
    };

    this.audioCapturer?.on('readData', readDataCallback)
    //开始录制
    this.audioCapturer?.start();
    //调整录制状态
    this.voiceState = VoiceState.VOICING
    // console.log('1', '开始录制语音~~~')

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