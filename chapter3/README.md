# 第3章 Kubernetes エコシステムと組み合わせて使ってみよう

このディレクトリでは、第3章で紹介しているクラスタマニフェストのサンプルリポジトリのコードを提供します。

```
chapter3
├── base            # 基本となる内容のマニフェストを定義
│   ├── cluster.yaml                    # Cluster のマニフェスト
│   ├── controlplane.yaml               # クラスタマスター用 Machine のマニフェスト
│   ├── kustomization.yaml              # Kustomize の設定ファイル
│   ├── kustomizeconfig.yaml            # Cluster API のカスタムリソースを扱うための設定ファイル
│   └── machine-deployment.yaml         # ワーカーノード用 MachineDeployment のマニフェスト
└── overlays
    ├── prd         # プロダクション環境用のクラスタを作るための overlay
    │   ├── controlplane.yaml           # マスターノードのパッチ
    │   ├── kustomization.yaml          # Kustomize の設定ファイル
    │   └── machine-deployment.yaml     # ワーカーノードのパッチ
    └── stg         # ステージング環境用のクラスタを作るための overlay
        ├── controlplane.yaml
        ├── kustomization.yaml
        └── machine-deployment.yaml
```

### 3.2 GitOps でクラスタ管理をしてみよう

#### kustomize build コマンドの実行

```shell
# ステージング環境用のクラスタマニフェストが生成される
kustomize build overlays/prd

# プロダクション環境用のクラスタマニフェストが生成される
kustomize build overlays/prd
```
