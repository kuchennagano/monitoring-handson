# monitoring-handson

## 事前準備
- 以下は手動で対応
    - APIの有効化(compute) 
			- XXXX

- Cloud shell で認証の設定
```
% gcloud auth login
% gcloud config set project
% gcloud config set compute/region asia-northeast1
% gcloud config set compute/zone asia-northeast1-a
% gcloud auth application-default login
```

- tfstate用のGCSの作成 
```
% export GCP_PROJECT=ca-nagano-taichi-test 
% gsutil mb -p $GCP_PROJECT -l asia-northeast1 -b on gs://ca-nagano-taichi-test
% gsutil versioning set on gs://ca-nagano-taichi-test
```

- サンプルコードのダウンロード
    - コメント箇所を修正する 

## Terraform実行
1. 初期化
```
% terraform init
```
2. ゴールデンイメージの作成
```
% cd packer
% packer build .
```
3. gce.tfの修正
- イメージ名を手順2で作成したものに変更する

4. Terraform実行
```
% terraform plan 
% terraform apply
```