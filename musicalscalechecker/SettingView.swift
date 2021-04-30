//
//  SettingView.swift
//  musicalscalechecker
//
//  Created by 松中誉生 on 2020/11/25.
//

import SwiftUI
import GoogleMobileAds

struct SettingView: View {
    @Binding var isFlat:Bool
    @Binding var timerInterval: Float
    
    //@Binding var rewarded: GADRewardedAd
    
    @Binding var navBarHidden:Bool
    
    @Binding var isAdHidden:Bool
    
    init(isFlat: Binding<Bool>, timerInterval: Binding<Float>, navBarHidden: Binding<Bool>, isAdHidden: Binding<Bool>){
        self._isFlat = isFlat
        //self._rewarded = rewarded
        self._timerInterval = timerInterval
        self._navBarHidden = navBarHidden
        self._isAdHidden = isAdHidden
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
        //UINavigationBar.appearance().tintColor = .clear
        UINavigationBar.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        Form{
            Section(header: Text("表記")){
                Toggle(isOn: $isFlat,
                       label: {
                        Text("♭(フラット)表記")
                       })
            }
            Section(header: Text("グラフの表示速度")){
                HStack{
                    Text("速")
                    Slider(value: $timerInterval,
                        in: 0.001...0.1)
                    Text("遅")
                }
            }
            /*
            Section(header:
                        HStack{
                            Spacer()
                            Text("広告削除(ベータ)").fontWeight(.heavy)
                            Spacer()
                        },
                    footer: Text("上のボタンをタップしても広告が表示されない場合、\r\n" + "iOS 14 端末の「設定アプリ->プライバシー->トラッキング->「Appからのトラッキング要求を許可」がオンになっているか確認してください。\r\n"
                + "iOS 13 端末の「設定アプリ->プライバシー->広告->「追跡型広告を制限」がオフになっているか確認してください。")
                        .font(.system(size: 9))){
                Button(action: {
                    if self.rewarded.isReady{
                        let root = UIApplication.shared.windows.first?.rootViewController
                        self.rewarded.present(fromRootViewController: root!, delegate: RewardedAdDelegate(rewarded: $rewarded, isAdHidden: $isAdHidden))
                    }
                }){
                    VStack(alignment: .leading, spacing: 0){
                        Text("広告を見て、")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "FF5555"))
                        Text("無料で全ての広告を5日間非表示にする")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "FF5555"))
                    }
                }
            }
            */
            if !isAdHidden {
                Section{
                    Rectangle()
                        .frame(height: 250)
                        .foregroundColor(.clear)
                        .background(AdRectView()
                                        .frame(height: 250))
                }
            }
        }
        .onAppear(){
            navBarHidden = false
        }
        .onDisappear(){
            navBarHidden = true
        }
    }
}

class RewardedAdDelegate: NSObject, GADRewardedAdDelegate, ObservableObject {
    @Binding var rewarded:GADRewardedAd
    @Binding var isAdHidden:Bool

    init(rewarded: Binding<GADRewardedAd>, isAdHidden: Binding<Bool>){
        self._rewarded = rewarded
        self._isAdHidden = isAdHidden
    }
    
    /// Tells the delegate that the user earned a reward.
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        print("watched")
        
        UserDefaults.standard.setValue(Date(), forKey: "date")
        isAdHidden = true
    }

    /// Tells the delegate that the rewarded ad was presented.
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
        print("presented")
    }

    /// Tells the delegate that the rewarded ad was dismissed.
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        print("dismiss")
        //rewarded = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313") //テスト
        rewarded.load(GADRequest()) { error in
          if let error = error {
            print("Loading failed: \(error)")
          } else {
            print("Loading Succeeded")
          }
        }
    }

    /// Tells the delegate that the rewarded ad failed to present.
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        print("error\(error)")
    }
}
