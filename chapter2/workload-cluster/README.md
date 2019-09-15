# 2.4 Workload Cluster の構築

このディレクトリでは Workload Cluster の構築に使用するクラスタマニフェストのサンプルを提供します。

```
workload-cluster
├── README.md
├── cluster.yaml              # Cluster マニフェストのサンプル
├── controlplane.yaml         # クラスタマスターの Machine マニフェストのサンプル
├── machine-deployment.yaml   # ワーカーノードの MachineDeployment マニフェストのサンプル
└── multi-controlplane.yaml   # 複数のクラスタマスター Machine を作成するサンプル
```

このディレクトリの YAML ファイルを使用すると、以下の内容で Kubernetes クラスタが構築されます。

* クラスタ名: `capi-workload01`
* Kubernetes バージョン: `v1.15.3`
* クラスタマスター:
    * ノード名: `capi-workload01-controlplane-{0..2}`
    * インスタンスタイプ: `t3.small`
* ワーカー:
    * ノード名: `capi-workload01-node-*`
    * インスタンスタイプ: `t3.small`
