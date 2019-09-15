# 2.3 Management Cluster の構築

このディレクトリでは Management Cluster の構築に使用するクラスタマニフェストの生成スクリプトを提供します。

```
management-cluster
├── README.md
├── _out                  # 生成されたマニフェストの出力先
├── generate.sh           # クラスタマニフェストの生成スクリプト
├── cluster               # Cluster マニフェストのテンプレート
├── machines              # Machine マニフェストのテンプレート
└── provider-components   # Cluster API Provider に関連するマニフェストのテンプレート
```

## クラスタの構築手順

以下は本文で紹介しているコマンド例と同様です。

### 2.3.1 IAM ユーザのアクセスキー取得と環境変数への設定

```shell
export AWS_REGION="ap-northeast-1"
export AWS_CREDENTIALS=$(aws iam create-access-key --user-name bootstrapper.cluster-api-provider-aws.sigs.k8s.io)
export AWS_ACCESS_KEY_ID=$(echo $AWS_CREDENTIALS | jq .AccessKey.AccessKeyId -r)
export AWS_SECRET_ACCESS_KEY=$(echo $AWS_CREDENTIALS | jq .AccessKey.SecretAccessKey -r)
```

**生成されたマニフェストには AWS のクレデンシャル情報が含まれる**という点に注意してください。
誤ってパブリックな Git リポジトリなどで公開しないように気を付けてください。

### 2.3.2 クラスタマニフェストの生成

```shell
export SSH_KEY_NAME="cluster-api-aws-default"
export CLUSTER_NAME="capi-mng"
./generate.sh
```

### 2.3.3 クラスタの構築

```shell
clusterctl create cluster -v 3 \
  --bootstrap-type kind \
  -c ./_out/cluster.yaml \
  -m ./_out/machines.yaml \
  -p ./_out/provider-components.yaml \
  -a ./_out/addon.yaml
```
