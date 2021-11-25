# monitoring-handson

## 事前準備(手動対応)
- APIの有効化
	- Compute Engine API
    - Cloud Identity-Aware Proxy API

- Cloud shell で認証の設定
```
% gcloud auth login
% gcloud config set project {プロジェクトID}
% gcloud config set compute/region asia-northeast1
% gcloud config set compute/zone asia-northeast1-a
% gcloud auth application-default login
% gcloud config configurations list
```

- アラート通知用のチャンネルを作成
    - モニタリングへ移動
        - アラート > `EDIT NOTIFICATION CHANNELS`から通知先を作成
        - 今回は`Email`を指定
    - 作成したアラートの情報を確認
        - `gcloud alpha monitoring channels list`
        ```
        $ gcloud alpha monitoring channels list
        ---
        creationRecord:
        mutateTime: '2021-11-24T22:24:00.463665022Z'
        displayName: tumetume-input-alert
        enabled: true
        labels:
        email_address: nagano.taichi@cloud-ace.jp
        mutationRecords:
        - mutateTime: '2021-11-24T22:24:00.463665022Z'
        name: projects/ca-tnagano-terraform-test/notificationChannels/xxxxxxxxxxxxxxx ★ここが必要★
        type: email
        ```

- tfstate用のGCSの作成 
```
% export GCP_PROJECT={プロジェクトID} 
% gsutil mb -p $GCP_PROJECT -l asia-northeast1 -b on gs://{任意のバケット名}  #例：ca-tnagano-terraform-test
% gsutil versioning set on gs://{任意のバケット名}  #例：ca-tnagano-terraform-test
```

- サンプルコードのダウンロード
    - `git clone https://github.com/kuchennagano/monitoring-handson.git`
    - コメント箇所を修正する 
        1. variable.tf (3,7,10行目)
        2. provider.tf (12行目)
        3. monitoring.tf (3,4行目)
        4. packer/variables.pkr.hcl (2,7,8,10,12行目変更)
## Terraform実行
1. 初期化
```
% cd monitoring-handson/
% terraform init
```
2. ゴールデンイメージの作成
```
% sudo apt install packer
% sudo apt install ansible
% cd packer
% packer build .
```
3. gce.tfの修正
- イメージ名を手順2で作成したものに変更する (4行目)

4. Terraform実行
```
% cd ../
% terraform plan 
% terraform apply
```

## 確認
1. VPC・サブネット・NATができている
2. Compute Engine・IAP・ファイアウォールルールができている
3. VMインスタンスにsshできている
4. モニタリングにアラートができている