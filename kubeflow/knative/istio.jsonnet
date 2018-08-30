{
    "apiVersion": "v1",
    "kind": "Namespace",
    "metadata": {
        "name": "istio-system"
    }
} {
    "apiVersion": "v1",
    "data": {
        "mapping.conf": ""
    },
    "kind": "ConfigMap",
    "metadata": {
        "labels": {
            "app": "istio-statsd-prom-bridge",
            "chart": "mixer-0.8.0",
            "heritage": "Tiller",
            "istio": "mixer",
            "release": "RELEASE-NAME"
        },
        "name": "istio-statsd-prom-bridge",
        "namespace": "istio-system"
    }
} {
    "apiVersion": "v1",
    "data": {
        "custom-resources.yaml": "apiVersion: \"config.istio.io/v1alpha2\"\nkind: attributemanifest\nmetadata:\n  name: istioproxy\n  namespace: istio-system\nspec:\n  attributes:\n    origin.ip:\n      valueType: IP_ADDRESS\n    origin.uid:\n      valueType: STRING\n    origin.user:\n      valueType: STRING\n    request.headers:\n      valueType: STRING_MAP\n    request.id:\n      valueType: STRING\n    request.host:\n      valueType: STRING\n    request.method:\n      valueType: STRING\n    request.path:\n      valueType: STRING\n    request.reason:\n      valueType: STRING\n    request.referer:\n      valueType: STRING\n    request.scheme:\n      valueType: STRING\n    request.total_size:\n          valueType: INT64\n    request.size:\n      valueType: INT64\n    request.time:\n      valueType: TIMESTAMP\n    request.useragent:\n      valueType: STRING\n    response.code:\n      valueType: INT64\n    response.duration:\n      valueType: DURATION\n    response.headers:\n      valueType: STRING_MAP\n    response.total_size:\n          valueType: INT64\n    response.size:\n      valueType: INT64\n    response.time:\n      valueType: TIMESTAMP\n    source.uid:\n      valueType: STRING\n    source.user:\n      valueType: STRING\n    destination.uid:\n      valueType: STRING\n    connection.id:\n      valueType: STRING\n    connection.received.bytes:\n      valueType: INT64\n    connection.received.bytes_total:\n      valueType: INT64\n    connection.sent.bytes:\n      valueType: INT64\n    connection.sent.bytes_total:\n      valueType: INT64\n    connection.duration:\n      valueType: DURATION\n    connection.mtls:\n      valueType: BOOL\n    context.protocol:\n      valueType: STRING\n    context.timestamp:\n      valueType: TIMESTAMP\n    context.time:\n      valueType: TIMESTAMP\n    api.service:\n      valueType: STRING\n    api.version:\n      valueType: STRING\n    api.operation:\n      valueType: STRING\n    api.protocol:\n      valueType: STRING\n    request.auth.principal:\n      valueType: STRING\n    request.auth.audiences:\n      valueType: STRING\n    request.auth.presenter:\n      valueType: STRING\n    request.auth.claims:\n      valueType: STRING_MAP\n    request.auth.raw_claims:\n      valueType: STRING\n    request.api_key:\n      valueType: STRING\n\n---\napiVersion: \"config.istio.io/v1alpha2\"\nkind: attributemanifest\nmetadata:\n  name: kubernetes\n  namespace: istio-system\nspec:\n  attributes:\n    source.ip:\n      valueType: IP_ADDRESS\n    source.labels:\n      valueType: STRING_MAP\n    source.name:\n      valueType: STRING\n    source.namespace:\n      valueType: STRING\n    source.service:\n      valueType: STRING\n    source.serviceAccount:\n      valueType: STRING\n    destination.ip:\n      valueType: IP_ADDRESS\n    destination.labels:\n      valueType: STRING_MAP\n    destination.name:\n      valueType: STRING\n    destination.namespace:\n      valueType: STRING\n    destination.service:\n      valueType: STRING\n    destination.serviceAccount:\n      valueType: STRING\n---\napiVersion: \"config.istio.io/v1alpha2\"\nkind: stdio\nmetadata:\n  name: handler\n  namespace: istio-system\nspec:\n  outputAsJson: true\n---\napiVersion: \"config.istio.io/v1alpha2\"\nkind: logentry\nmetadata:\n  name: accesslog\n  namespace: istio-system\nspec:\n  severity: '\"Info\"'\n  timestamp: request.time\n  variables:\n    originIp: origin.ip | ip(\"0.0.0.0\")\n    sourceIp: source.ip | ip(\"0.0.0.0\")\n    sourceService: source.service | \"\"\n    sourceUser: source.user | source.uid | \"\"\n    sourceNamespace: source.namespace | \"\"\n    destinationIp: destination.ip | ip(\"0.0.0.0\")\n    destinationService: destination.service | \"\"\n    destinationNamespace: destination.namespace | \"\"\n    apiName: api.service | \"\"\n    apiVersion: api.version | \"\"\n    apiClaims: request.headers[\"sec-istio-auth-userinfo\"]| \"\"\n    apiKey: request.api_key | request.headers[\"x-api-key\"] | \"\"\n    requestOperation: api.operation | \"\"\n    protocol: request.scheme | \"http\"\n    method: request.method | \"\"\n    url: request.path | \"\"\n    responseCode: response.code | 0\n    responseSize: response.size | 0\n    requestSize: request.size | 0\n    latency: response.duration | \"0ms\"\n    connectionMtls: connection.mtls | false\n    userAgent: request.useragent | \"\"\n    responseTimestamp: response.time\n    receivedBytes: request.total_size | connection.received.bytes | 0\n    sentBytes: response.total_size | connection.sent.bytes | 0\n    referer: request.referer | \"\"\n  monitored_resource_type: '\"UNSPECIFIED\"'\n---\napiVersion: \"config.istio.io/v1alpha2\"\nkind: rule\nmetadata:\n  name: stdio\n  namespace: istio-system\nspec:\n  match: \"true\" # If omitted match is true.\n  actions:\n  - handler: handler.stdio\n    instances:\n    - accesslog.logentry\n---\napiVersion: \"config.istio.io/v1alpha2\"\nkind: metric\nmetadata:\n  name: requestcount\n  namespace: istio-system\nspec:\n  value: \"1\"\n  dimensions:\n    source_service: source.service | \"unknown\"\n    source_version: source.labels[\"version\"] | \"unknown\"\n    destination_service: destination.service | \"unknown\"\n    destination_version: destination.labels[\"version\"] | \"unknown\"\n    response_code: response.code | 200\n    connection_mtls: connection.mtls | false\n  monitored_resource_type: '\"UNSPECIFIED\"'\n---\napiVersion: \"config.istio.io/v1alpha2\"\nkind: metric\nmetadata:\n  name: requestduration\n  namespace: istio-system\nspec:\n  value: response.duration | \"0ms\"\n  dimensions:\n    source_service: source.service | \"unknown\"\n    source_version: source.labels[\"version\"] | \"unknown\"\n    destination_service: destination.service | \"unknown\"\n    destination_version: destination.labels[\"version\"] | \"unknown\"\n    response_code: response.code | 200\n    connection_mtls: connection.mtls | false\n  monitored_resource_type: '\"UNSPECIFIED\"'\n---\napiVersion: \"config.istio.io/v1alpha2\"\nkind: metric\nmetadata:\n  name: requestsize\n  namespace: istio-system\nspec:\n  value: request.size | 0\n  dimensions:\n    source_service: source.service | \"unknown\"\n    source_version: source.labels[\"version\"] | \"unknown\"\n    destination_service: destination.service | \"unknown\"\n    destination_version: destination.labels[\"version\"] | \"unknown\"\n    response_code: response.code | 200\n    connection_mtls: connection.mtls | false\n  monitored_resource_type: '\"UNSPECIFIED\"'\n---\napiVersion: \"config.istio.io/v1alpha2\"\nkind: metric\nmetadata:\n  name: responsesize\n  namespace: istio-system\nspec:\n  value: response.size | 0\n  dimensions:\n    source_service: source.service | \"unknown\"\n    source_version: source.labels[\"version\"] | \"unknown\"\n    destination_service: destination.service | \"unknown\"\n    destination_version: destination.labels[\"version\"] | \"unknown\"\n    response_code: response.code | 200\n    connection_mtls: connection.mtls | false\n  monitored_resource_type: '\"UNSPECIFIED\"'\n---\napiVersion: \"config.istio.io/v1alpha2\"\nkind: metric\nmetadata:\n  name: tcpbytesent\n  namespace: istio-system\n  labels:\n    istio-protocol: tcp # needed so that mixer will only generate when context.protocol == tcp\nspec:\n  value: connection.sent.bytes | 0\n  dimensions:\n    source_service: source.service | \"unknown\"\n    source_version: source.labels[\"version\"] | \"unknown\"\n    destination_service: destination.service | \"unknown\"\n    destination_version: destination.labels[\"version\"] | \"unknown\"\n    connection_mtls: connection.mtls | false\n  monitored_resource_type: '\"UNSPECIFIED\"'\n---\napiVersion: \"config.istio.io/v1alpha2\"\nkind: metric\nmetadata:\n  name: tcpbytereceived\n  namespace: istio-system\n  labels:\n    istio-protocol: tcp # needed so that mixer will only generate when context.protocol == tcp\nspec:\n  value: connection.received.bytes | 0\n  dimensions:\n    source_service: source.service | \"unknown\"\n    source_version: source.labels[\"version\"] | \"unknown\"\n    destination_service: destination.service | \"unknown\"\n    destination_version: destination.labels[\"version\"] | \"unknown\"\n    connection_mtls: connection.mtls | false\n  monitored_resource_type: '\"UNSPECIFIED\"'\n---\napiVersion: \"config.istio.io/v1alpha2\"\nkind: prometheus\nmetadata:\n  name: handler\n  namespace: istio-system\nspec:\n  metrics:\n  - name: request_count\n    instance_name: requestcount.metric.istio-system\n    kind: COUNTER\n    label_names:\n    - source_service\n    - source_version\n    - destination_service\n    - destination_version\n    - response_code\n    - connection_mtls\n  - name: request_duration\n    instance_name: requestduration.metric.istio-system\n    kind: DISTRIBUTION\n    label_names:\n    - source_service\n    - source_version\n    - destination_service\n    - destination_version\n    - response_code\n    - connection_mtls\n    buckets:\n      explicit_buckets:\n        bounds: [0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10]\n  - name: request_size\n    instance_name: requestsize.metric.istio-system\n    kind: DISTRIBUTION\n    label_names:\n    - source_service\n    - source_version\n    - destination_service\n    - destination_version\n    - response_code\n    - connection_mtls\n    buckets:\n      exponentialBuckets:\n        numFiniteBuckets: 8\n        scale: 1\n        growthFactor: 10\n  - name: response_size\n    instance_name: responsesize.metric.istio-system\n    kind: DISTRIBUTION\n    label_names:\n    - source_service\n    - source_version\n    - destination_service\n    - destination_version\n    - response_code\n    - connection_mtls\n    buckets:\n      exponentialBuckets:\n        numFiniteBuckets: 8\n        scale: 1\n        growthFactor: 10\n  - name: tcp_bytes_sent\n    instance_name: tcpbytesent.metric.istio-system\n    kind: COUNTER\n    label_names:\n    - source_service\n    - source_version\n    - destination_service\n    - destination_version\n    - connection_mtls\n  - name: tcp_bytes_received\n    instance_name: tcpbytereceived.metric.istio-system\n    kind: COUNTER\n    label_names:\n    - source_service\n    - source_version\n    - destination_service\n    - destination_version\n    - connection_mtls\n---\napiVersion: \"config.istio.io/v1alpha2\"\nkind: rule\nmetadata:\n  name: promhttp\n  namespace: istio-system\n  labels:\n    istio-protocol: http\nspec:\n  actions:\n  - handler: handler.prometheus\n    instances:\n    - requestcount.metric\n    - requestduration.metric\n    - requestsize.metric\n    - responsesize.metric\n---\napiVersion: \"config.istio.io/v1alpha2\"\nkind: rule\nmetadata:\n  name: promtcp\n  namespace: istio-system\n  labels:\n    istio-protocol: tcp # needed so that mixer will only execute when context.protocol == TCP\nspec:\n  actions:\n  - handler: handler.prometheus\n    instances:\n    - tcpbytesent.metric\n    - tcpbytereceived.metric\n---\n\napiVersion: \"config.istio.io/v1alpha2\"\nkind: kubernetesenv\nmetadata:\n  name: handler\n  namespace: istio-system\nspec:\n  # when running from mixer root, use the following config after adding a\n  # symbolic link to a kubernetes config file via:\n  #\n  # $ ln -s ~/.kube/config mixer/adapter/kubernetes/kubeconfig\n  #\n  # kubeconfig_path: \"mixer/adapter/kubernetes/kubeconfig\"\n\n---\napiVersion: \"config.istio.io/v1alpha2\"\nkind: rule\nmetadata:\n  name: kubeattrgenrulerule\n  namespace: istio-system\nspec:\n  actions:\n  - handler: handler.kubernetesenv\n    instances:\n    - attributes.kubernetes\n---\napiVersion: \"config.istio.io/v1alpha2\"\nkind: rule\nmetadata:\n  name: tcpkubeattrgenrulerule\n  namespace: istio-system\nspec:\n  match: context.protocol == \"tcp\"\n  actions:\n  - handler: handler.kubernetesenv\n    instances:\n    - attributes.kubernetes\n---\napiVersion: \"config.istio.io/v1alpha2\"\nkind: kubernetes\nmetadata:\n  name: attributes\n  namespace: istio-system\nspec:\n  # Pass the required attribute data to the adapter\n  source_uid: source.uid | \"\"\n  source_ip: source.ip | ip(\"0.0.0.0\") # default to unspecified ip addr\n  destination_uid: destination.uid | \"\"\n  origin_uid: '\"\"'\n  origin_ip: ip(\"0.0.0.0\") # default to unspecified ip addr\n  attribute_bindings:\n    # Fill the new attributes from the adapter produced output.\n    # $out refers to an instance of OutputTemplate message\n    source.ip: $out.source_pod_ip | ip(\"0.0.0.0\")\n    source.labels: $out.source_labels | emptyStringMap()\n    source.namespace: $out.source_namespace | \"default\"\n    source.service: $out.source_service | \"unknown\"\n    source.serviceAccount: $out.source_service_account_name | \"unknown\"\n    destination.ip: $out.destination_pod_ip | ip(\"0.0.0.0\")\n    destination.labels: $out.destination_labels | emptyStringMap()\n    destination.namespace: $out.destination_namespace | \"default\"\n    destination.service: $out.destination_service | \"unknown\"\n    destination.serviceAccount: $out.destination_service_account_name | \"unknown\"\n---\n# Configuration needed by Mixer.\n# Mixer cluster is delivered via CDS\n# Specify mixer cluster settings\napiVersion: networking.istio.io/v1alpha3\nkind: DestinationRule\nmetadata:\n  name: istio-policy\n  namespace: istio-system\nspec:\n  host: istio-policy.istio-system.svc.cluster.local\n  trafficPolicy:\n    connectionPool:\n      http:\n        http2MaxRequests: 10000\n        maxRequestsPerConnection: 10000\n---\napiVersion: networking.istio.io/v1alpha3\nkind: DestinationRule\nmetadata:\n  name: istio-telemetry\n  namespace: istio-system\nspec:\n  host: istio-telemetry.istio-system.svc.cluster.local\n  trafficPolicy:\n    connectionPool:\n      http:\n        http2MaxRequests: 10000\n        maxRequestsPerConnection: 10000\n---"
    },
    "kind": "ConfigMap",
    "metadata": {
        "labels": {
            "app": "istio-mixer",
            "chart": "mixer-0.8.0",
            "heritage": "Tiller",
            "istio": "mixer",
            "release": "RELEASE-NAME"
        },
        "name": "istio-mixer-custom-resources",
        "namespace": "istio-system"
    }
} {
    "apiVersion": "v1",
    "data": {
        "mesh": "#\n# Edit this list to avoid using mTLS to connect to these services.\n# Typically, these are control services (e.g kubernetes API server) that don't have istio sidecar\n# to transparently terminate mTLS authentication.\n# mtlsExcludedServices: [\"kubernetes.default.svc.cluster.local\"]\n\n# Set the following variable to true to disable policy checks by the Mixer.\n# Note that metrics will still be reported to the Mixer.\ndisablePolicyChecks: false\n# Set enableTracing to false to disable request tracing.\nenableTracing: true\n#\n# To disable the mixer completely (including metrics), comment out\n# the following lines\nmixerCheckServer: istio-policy.istio-system.svc.cluster.local:15004\nmixerReportServer: istio-telemetry.istio-system.svc.cluster.local:15004\n# This is the ingress service name, update if you used a different name\ningressService: istio-ingress\n#\n# Along with discoveryRefreshDelay, this setting determines how\n# frequently should Envoy fetch and update its internal configuration\n# from istio Pilot. Lower refresh delay results in higher CPU\n# utilization and potential performance loss in exchange for faster\n# convergence. Tweak this value according to your setup.\nrdsRefreshDelay: 10s\n#\ndefaultConfig:\n  # NOTE: If you change any values in this section, make sure to make\n  # the same changes in start up args in istio-ingress pods.\n  # See rdsRefreshDelay for explanation about this setting.\n  discoveryRefreshDelay: 10s\n  #\n  # TCP connection timeout between Envoy \u0026 the application, and between Envoys.\n  connectTimeout: 10s\n  #\n  ### ADVANCED SETTINGS #############\n  # Where should envoy's configuration be stored in the istio-proxy container\n  configPath: \"/etc/istio/proxy\"\n  binaryPath: \"/usr/local/bin/envoy\"\n  # The pseudo service name used for Envoy.\n  serviceCluster: istio-proxy\n  # These settings that determine how long an old Envoy\n  # process should be kept alive after an occasional reload.\n  drainDuration: 45s\n  parentShutdownDuration: 1m0s\n  #\n  # The mode used to redirect inbound connections to Envoy. This setting\n  # has no effect on outbound traffic: iptables REDIRECT is always used for\n  # outbound connections.\n  # If \"REDIRECT\", use iptables REDIRECT to NAT and redirect to Envoy.\n  # The \"REDIRECT\" mode loses source addresses during redirection.\n  # If \"TPROXY\", use iptables TPROXY to redirect to Envoy.\n  # The \"TPROXY\" mode preserves both the source and destination IP\n  # addresses and ports, so that they can be used for advanced filtering\n  # and manipulation.\n  # The \"TPROXY\" mode also configures the sidecar to run with the\n  # CAP_NET_ADMIN capability, which is required to use TPROXY.\n  #interceptionMode: REDIRECT\n  #\n  # Port where Envoy listens (on local host) for admin commands\n  # You can exec into the istio-proxy container in a pod and\n  # curl the admin port (curl http://localhost:15000/) to obtain\n  # diagnostic information from Envoy. See\n  # https://lyft.github.io/envoy/docs/operations/admin.html\n  # for more details\n  proxyAdminPort: 15000\n  #\n  # Zipkin trace collector\n  zipkinAddress: zipkin.istio-system:9411\n  #\n  # Statsd metrics collector converts statsd metrics into Prometheus metrics.\n  statsdUdpAddress: istio-statsd-prom-bridge.istio-system:9125\n  #\n  # Mutual TLS authentication between sidecars and istio control plane.\n  controlPlaneAuthPolicy: NONE\n  #\n  # Address where istio Pilot service is running\n  discoveryAddress: istio-pilot.istio-system:15007"
    },
    "kind": "ConfigMap",
    "metadata": {
        "labels": {
            "app": "istio",
            "chart": "istio-0.8.0",
            "heritage": "Tiller",
            "release": "RELEASE-NAME"
        },
        "name": "istio",
        "namespace": "istio-system"
    }
} {
    "apiVersion": "v1",
    "data": {
        "config": "policy: enabled\ntemplate: |-\n  initContainers:\n  - name: istio-init\n    image: docker.io/istio/proxy_init:0.8.0\n    args:\n    - \"-p\"\n    - [[ .MeshConfig.ProxyListenPort ]]\n    - \"-u\"\n    - 1337\n    - \"-m\"\n    - [[ or (index .ObjectMeta.Annotations \"sidecar.istio.io/interceptionMode\") .ProxyConfig.InterceptionMode.String ]]\n    - \"-i\"\n    [[ if (isset .ObjectMeta.Annotations \"traffic.sidecar.istio.io/includeOutboundIPRanges\") -]]\n    - \"[[ index .ObjectMeta.Annotations \"traffic.sidecar.istio.io/includeOutboundIPRanges\"  ]]\"\n    [[ else -]]\n    - \"*\"\n    [[ end -]]\n    - \"-x\"\n    [[ if (isset .ObjectMeta.Annotations \"traffic.sidecar.istio.io/excludeOutboundIPRanges\") -]]\n    - \"[[ index .ObjectMeta.Annotations \"traffic.sidecar.istio.io/excludeOutboundIPRanges\"  ]]\"\n    [[ else -]]\n    - \"\"\n    [[ end -]]\n    - \"-b\"\n    [[ if (isset .ObjectMeta.Annotations \"traffic.sidecar.istio.io/includeInboundPorts\") -]]\n    - \"[[ index .ObjectMeta.Annotations \"traffic.sidecar.istio.io/includeInboundPorts\"  ]]\"\n    [[ else -]]\n    - [[ range .Spec.Containers -]][[ range .Ports -]][[ .ContainerPort -]], [[ end -]][[ end -]][[ end]]\n    - \"-d\"\n    [[ if (isset .ObjectMeta.Annotations \"traffic.sidecar.istio.io/excludeInboundPorts\") -]]\n    - \"[[ index .ObjectMeta.Annotations \"traffic.sidecar.istio.io/excludeInboundPorts\" ]]\"\n    [[ else -]]\n    - \"\"\n    [[ end -]]\n    imagePullPolicy: IfNotPresent\n    securityContext:\n      capabilities:\n        add:\n        - NET_ADMIN\n      privileged: true\n    restartPolicy: Always\n\n  containers:\n  - name: istio-proxy\n    # PATCH #2:  Add a prestop sleep.\n    lifecycle:\n      preStop:\n        exec:\n          command:\n          - /bin/sleep\n          - \"20\"\n    # PATCH #2 ends.\n    image: [[ if (isset .ObjectMeta.Annotations \"sidecar.istio.io/proxyImage\") -]]\n    \"[[ index .ObjectMeta.Annotations \"sidecar.istio.io/proxyImage\" ]]\"\n    [[ else -]]\n    docker.io/istio/proxyv2:0.8.0\n    [[ end -]]\n    args:\n    - proxy\n    - sidecar\n    - --configPath\n    - [[ .ProxyConfig.ConfigPath ]]\n    - --binaryPath\n    - [[ .ProxyConfig.BinaryPath ]]\n    - --serviceCluster\n    [[ if ne \"\" (index .ObjectMeta.Labels \"app\") -]]\n    - [[ index .ObjectMeta.Labels \"app\" ]]\n    [[ else -]]\n    - \"istio-proxy\"\n    [[ end -]]\n    - --drainDuration\n    - [[ formatDuration .ProxyConfig.DrainDuration ]]\n    - --parentShutdownDuration\n    - [[ formatDuration .ProxyConfig.ParentShutdownDuration ]]\n    - --discoveryAddress\n    - [[ .ProxyConfig.DiscoveryAddress ]]\n    - --discoveryRefreshDelay\n    - [[ formatDuration .ProxyConfig.DiscoveryRefreshDelay ]]\n    - --zipkinAddress\n    - [[ .ProxyConfig.ZipkinAddress ]]\n    - --connectTimeout\n    - [[ formatDuration .ProxyConfig.ConnectTimeout ]]\n    - --statsdUdpAddress\n    - [[ .ProxyConfig.StatsdUdpAddress ]]\n    - --proxyAdminPort\n    - [[ .ProxyConfig.ProxyAdminPort ]]\n    - --controlPlaneAuthPolicy\n    - [[ .ProxyConfig.ControlPlaneAuthPolicy ]]\n    env:\n    - name: POD_NAME\n      valueFrom:\n        fieldRef:\n          fieldPath: metadata.name\n    - name: POD_NAMESPACE\n      valueFrom:\n        fieldRef:\n          fieldPath: metadata.namespace\n    - name: INSTANCE_IP\n      valueFrom:\n        fieldRef:\n          fieldPath: status.podIP\n    - name: ISTIO_META_POD_NAME\n      valueFrom:\n        fieldRef:\n          fieldPath: metadata.name\n    - name: ISTIO_META_INTERCEPTION_MODE\n      value: [[ or (index .ObjectMeta.Annotations \"sidecar.istio.io/interceptionMode\") .ProxyConfig.InterceptionMode.String ]]\n    imagePullPolicy: IfNotPresent\n    securityContext:\n        privileged: false\n        readOnlyRootFilesystem: true\n        [[ if eq (or (index .ObjectMeta.Annotations \"sidecar.istio.io/interceptionMode\") .ProxyConfig.InterceptionMode.String) \"TPROXY\" -]]\n        capabilities:\n          add:\n          - NET_ADMIN\n        [[ else -]]\n        runAsUser: 1337\n        [[ end -]]\n    restartPolicy: Always\n    resources:\n      requests:\n        cpu: 100m\n        memory: 128Mi\n\n    volumeMounts:\n    - mountPath: /etc/istio/proxy\n      name: istio-envoy\n    - mountPath: /etc/certs/\n      name: istio-certs\n      readOnly: true\n  volumes:\n  - emptyDir:\n      medium: Memory\n    name: istio-envoy\n  - name: istio-certs\n    secret:\n      optional: true\n      [[ if eq .Spec.ServiceAccountName \"\" -]]\n      secretName: istio.default\n      [[ else -]]\n      secretName: [[ printf \"istio.%s\" .Spec.ServiceAccountName ]]\n      [[ end -]]"
    },
    "kind": "ConfigMap",
    "metadata": {
        "labels": {
            "app": "istio",
            "chart": "istio-0.8.0",
            "heritage": "Tiller",
            "istio": "sidecar-injector",
            "release": "RELEASE-NAME"
        },
        "name": "istio-sidecar-injector",
        "namespace": "istio-system"
    }
} {
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
        "labels": {
            "app": "egressgateway",
            "chart": "egressgateway-0.8.0",
            "heritage": "Tiller",
            "release": "RELEASE-NAME"
        },
        "name": "istio-egressgateway-service-account",
        "namespace": "istio-system"
    }
} {
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
        "labels": {
            "app": "ingress",
            "chart": "ingress-0.8.0",
            "heritage": "Tiller",
            "release": "RELEASE-NAME"
        },
        "name": "istio-ingress-service-account",
        "namespace": "istio-system"
    }
} {
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
        "labels": {
            "app": "ingressgateway",
            "chart": "ingressgateway-0.8.0",
            "heritage": "Tiller",
            "release": "RELEASE-NAME"
        },
        "name": "istio-ingressgateway-service-account",
        "namespace": "istio-system"
    }
} {
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
        "labels": {
            "app": "mixer",
            "chart": "mixer-0.8.0",
            "heritage": "Tiller",
            "release": "RELEASE-NAME"
        },
        "name": "istio-mixer-post-install-account",
        "namespace": "istio-system"
    }
} {
    "apiVersion": "rbac.authorization.k8s.io/v1beta1",
    "kind": "ClusterRole",
    "metadata": {
        "labels": {
            "app": "mixer",
            "chart": "mixer-0.8.0",
            "heritage": "Tiller",
            "release": "RELEASE-NAME"
        },
        "name": "istio-mixer-post-install-istio-system",
        "namespace": "istio-system"
    },
    "rules": [{
        "apiGroups": ["config.istio.io"],
        "resources": ["*"],
        "verbs": ["create", "get", "list", "watch", "patch"]
    }, {
        "apiGroups": ["networking.istio.io"],
        "resources": ["*"],
        "verbs": ["*"]
    }, {
        "apiGroups": ["apiextensions.k8s.io"],
        "resources": ["customresourcedefinitions"],
        "verbs": ["get", "list", "watch"]
    }, {
        "apiGroups": [""],
        "resources": ["configmaps", "endpoints", "pods", "services", "namespaces", "secrets"],
        "verbs": ["get", "list", "watch"]
    }]
} {
    "apiVersion": "rbac.authorization.k8s.io/v1beta1",
    "kind": "ClusterRoleBinding",
    "metadata": {
        "labels": {
            "app": "mixer",
            "chart": "mixer-0.8.0",
            "heritage": "Tiller",
            "release": "RELEASE-NAME"
        },
        "name": "istio-mixer-post-install-role-binding-istio-system"
    },
    "roleRef": {
        "apiGroup": "rbac.authorization.k8s.io",
        "kind": "ClusterRole",
        "name": "istio-mixer-post-install-istio-system"
    },
    "subjects": [{
        "kind": "ServiceAccount",
        "name": "istio-mixer-post-install-account",
        "namespace": "istio-system"
    }]
} {
    "apiVersion": "batch/v1",
    "kind": "Job",
    "metadata": {
        "annotations": {
            "helm.sh/hook": "post-install",
            "helm.sh/hook-delete-policy": "before-hook-creation"
        },
        "labels": {
            "app": "mixer",
            "chart": "mixer-0.8.0",
            "heritage": "Tiller",
            "release": "RELEASE-NAME"
        },
        "name": "istio-mixer-post-install",
        "namespace": "istio-system"
    },
    "spec": {
        "template": {
            "metadata": {
                "labels": {
                    "app": "mixer",
                    "release": "RELEASE-NAME"
                },
                "name": "istio-mixer-post-install"
            },
            "spec": {
                "containers": [{
                    "command": ["./kubectl", "apply", "-f", "/tmp/mixer/custom-resources.yaml"],
                    "image": "quay.io/coreos/hyperkube:v1.7.6_coreos.0",
                    "name": "hyperkube",
                    "volumeMounts": [{
                        "mountPath": "/tmp/mixer",
                        "name": "tmp-configmap-mixer"
                    }]
                }],
                "restartPolicy": "Never",
                "serviceAccountName": "istio-mixer-post-install-account",
                "volumes": [{
                    "configMap": {
                        "name": "istio-mixer-custom-resources"
                    },
                    "name": "tmp-configmap-mixer"
                }]
            }
        }
    }
} {
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
        "labels": {
            "app": "mixer",
            "chart": "mixer-0.8.0",
            "heritage": "Tiller",
            "release": "RELEASE-NAME"
        },
        "name": "istio-mixer-service-account",
        "namespace": "istio-system"
    }
} {
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
        "labels": {
            "app": "istio-pilot",
            "chart": "pilot-0.8.0",
            "heritage": "Tiller",
            "release": "RELEASE-NAME"
        },
        "name": "istio-pilot-service-account",
        "namespace": "istio-system"
    }
} {
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
        "labels": {
            "app": "security",
            "chart": "security-0.8.0",
            "heritage": "Tiller",
            "release": "RELEASE-NAME"
        },
        "name": "istio-citadel-service-account",
        "namespace": "istio-system"
    }
} {
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
        "labels": {
            "app": "security",
            "chart": "security-0.8.0",
            "heritage": "Tiller",
            "release": "RELEASE-NAME"
        },
        "name": "istio-cleanup-old-ca-service-account",
        "namespace": "istio-system"
    }
} {
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
        "labels": {
            "app": "istio-sidecar-injector",
            "chart": "sidecarInjectorWebhook-0.8.0",
            "heritage": "Tiller",
            "release": "RELEASE-NAME"
        },
        "name": "istio-sidecar-injector-service-account",
        "namespace": "istio-system"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "core",
            "package": "istio.io.mixer"
        },
        "name": "rules.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "rule",
            "plural": "rules",
            "singular": "rule"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "core",
            "package": "istio.io.mixer"
        },
        "name": "attributemanifests.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "attributemanifest",
            "plural": "attributemanifests",
            "singular": "attributemanifest"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "mixer-adapter",
            "package": "circonus"
        },
        "name": "circonuses.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "circonus",
            "plural": "circonuses",
            "singular": "circonus"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "mixer-adapter",
            "package": "denier"
        },
        "name": "deniers.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "denier",
            "plural": "deniers",
            "singular": "denier"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "mixer-adapter",
            "package": "fluentd"
        },
        "name": "fluentds.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "fluentd",
            "plural": "fluentds",
            "singular": "fluentd"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "mixer-adapter",
            "package": "kubernetesenv"
        },
        "name": "kubernetesenvs.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "kubernetesenv",
            "plural": "kubernetesenvs",
            "singular": "kubernetesenv"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "mixer-adapter",
            "package": "listchecker"
        },
        "name": "listcheckers.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "listchecker",
            "plural": "listcheckers",
            "singular": "listchecker"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "mixer-adapter",
            "package": "memquota"
        },
        "name": "memquotas.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "memquota",
            "plural": "memquotas",
            "singular": "memquota"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "mixer-adapter",
            "package": "noop"
        },
        "name": "noops.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "noop",
            "plural": "noops",
            "singular": "noop"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "mixer-adapter",
            "package": "opa"
        },
        "name": "opas.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "opa",
            "plural": "opas",
            "singular": "opa"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "mixer-adapter",
            "package": "prometheus"
        },
        "name": "prometheuses.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "prometheus",
            "plural": "prometheuses",
            "singular": "prometheus"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "mixer-adapter",
            "package": "rbac"
        },
        "name": "rbacs.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "rbac",
            "plural": "rbacs",
            "singular": "rbac"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "mixer-adapter",
            "package": "servicecontrol"
        },
        "name": "servicecontrols.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "servicecontrol",
            "plural": "servicecontrols",
            "singular": "servicecontrol"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "mixer-adapter",
            "package": "solarwinds"
        },
        "name": "solarwindses.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "solarwinds",
            "plural": "solarwindses",
            "singular": "solarwinds"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "mixer-adapter",
            "package": "stackdriver"
        },
        "name": "stackdrivers.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "stackdriver",
            "plural": "stackdrivers",
            "singular": "stackdriver"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "mixer-adapter",
            "package": "statsd"
        },
        "name": "statsds.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "statsd",
            "plural": "statsds",
            "singular": "statsd"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "mixer-adapter",
            "package": "stdio"
        },
        "name": "stdios.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "stdio",
            "plural": "stdios",
            "singular": "stdio"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "mixer-instance",
            "package": "apikey"
        },
        "name": "apikeys.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "apikey",
            "plural": "apikeys",
            "singular": "apikey"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "mixer-instance",
            "package": "authorization"
        },
        "name": "authorizations.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "authorization",
            "plural": "authorizations",
            "singular": "authorization"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "mixer-instance",
            "package": "checknothing"
        },
        "name": "checknothings.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "checknothing",
            "plural": "checknothings",
            "singular": "checknothing"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "mixer-instance",
            "package": "adapter.template.kubernetes"
        },
        "name": "kuberneteses.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "kubernetes",
            "plural": "kuberneteses",
            "singular": "kubernetes"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "mixer-instance",
            "package": "listentry"
        },
        "name": "listentries.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "listentry",
            "plural": "listentries",
            "singular": "listentry"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "mixer-instance",
            "package": "logentry"
        },
        "name": "logentries.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "logentry",
            "plural": "logentries",
            "singular": "logentry"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "mixer-instance",
            "package": "metric"
        },
        "name": "metrics.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "metric",
            "plural": "metrics",
            "singular": "metric"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "mixer-instance",
            "package": "quota"
        },
        "name": "quotas.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "quota",
            "plural": "quotas",
            "singular": "quota"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "mixer-instance",
            "package": "reportnothing"
        },
        "name": "reportnothings.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "reportnothing",
            "plural": "reportnothings",
            "singular": "reportnothing"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "mixer-instance",
            "package": "servicecontrolreport"
        },
        "name": "servicecontrolreports.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "servicecontrolreport",
            "plural": "servicecontrolreports",
            "singular": "servicecontrolreport"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "mixer-instance",
            "package": "tracespan"
        },
        "name": "tracespans.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "tracespan",
            "plural": "tracespans",
            "singular": "tracespan"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "rbac",
            "package": "istio.io.mixer"
        },
        "name": "serviceroles.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "ServiceRole",
            "plural": "serviceroles",
            "singular": "servicerole"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "mixer",
            "istio": "rbac",
            "package": "istio.io.mixer"
        },
        "name": "servicerolebindings.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "ServiceRoleBinding",
            "plural": "servicerolebindings",
            "singular": "servicerolebinding"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "istio-pilot"
        },
        "name": "destinationpolicies.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "DestinationPolicy",
            "listKind": "DestinationPolicyList",
            "plural": "destinationpolicies",
            "singular": "destinationpolicy"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "istio-pilot"
        },
        "name": "egressrules.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "EgressRule",
            "listKind": "EgressRuleList",
            "plural": "egressrules",
            "singular": "egressrule"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "istio-pilot"
        },
        "name": "routerules.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "RouteRule",
            "listKind": "RouteRuleList",
            "plural": "routerules",
            "singular": "routerule"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "istio-pilot"
        },
        "name": "virtualservices.networking.istio.io"
    },
    "spec": {
        "group": "networking.istio.io",
        "names": {
            "kind": "VirtualService",
            "listKind": "VirtualServiceList",
            "plural": "virtualservices",
            "singular": "virtualservice"
        },
        "scope": "Namespaced",
        "version": "v1alpha3"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "istio-pilot"
        },
        "name": "destinationrules.networking.istio.io"
    },
    "spec": {
        "group": "networking.istio.io",
        "names": {
            "kind": "DestinationRule",
            "listKind": "DestinationRuleList",
            "plural": "destinationrules",
            "singular": "destinationrule"
        },
        "scope": "Namespaced",
        "version": "v1alpha3"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "istio-pilot"
        },
        "name": "serviceentries.networking.istio.io"
    },
    "spec": {
        "group": "networking.istio.io",
        "names": {
            "kind": "ServiceEntry",
            "listKind": "ServiceEntryList",
            "plural": "serviceentries",
            "singular": "serviceentry"
        },
        "scope": "Namespaced",
        "version": "v1alpha3"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
            "app": "istio-pilot"
        },
        "name": "gateways.networking.istio.io"
    },
    "spec": {
        "group": "networking.istio.io",
        "names": {
            "kind": "Gateway",
            "plural": "gateways",
            "singular": "gateway"
        },
        "scope": "Namespaced",
        "version": "v1alpha3"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "name": "policies.authentication.istio.io"
    },
    "spec": {
        "group": "authentication.istio.io",
        "names": {
            "kind": "Policy",
            "plural": "policies",
            "singular": "policy"
        },
        "scope": "Namespaced",
        "version": "v1alpha1"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "name": "httpapispecbindings.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "HTTPAPISpecBinding",
            "plural": "httpapispecbindings",
            "singular": "httpapispecbinding"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "name": "httpapispecs.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "HTTPAPISpec",
            "plural": "httpapispecs",
            "singular": "httpapispec"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "name": "quotaspecbindings.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "QuotaSpecBinding",
            "plural": "quotaspecbindings",
            "singular": "quotaspecbinding"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "name": "quotaspecs.config.istio.io"
    },
    "spec": {
        "group": "config.istio.io",
        "names": {
            "kind": "QuotaSpec",
            "plural": "quotaspecs",
            "singular": "quotaspec"
        },
        "scope": "Namespaced",
        "version": "v1alpha2"
    }
} {
    "apiVersion": "rbac.authorization.k8s.io/v1beta1",
    "kind": "ClusterRole",
    "metadata": {
        "labels": {
            "app": "ingress",
            "chart": "ingress-0.8.0",
            "heritage": "Tiller",
            "release": "RELEASE-NAME"
        },
        "name": "istio-ingress-istio-system"
    },
    "rules": [{
        "apiGroups": ["extensions"],
        "resources": ["thirdpartyresources", "ingresses"],
        "verbs": ["get", "watch", "list", "update"]
    }, {
        "apiGroups": [""],
        "resources": ["configmaps", "pods", "endpoints", "services"],
        "verbs": ["get", "watch", "list"]
    }]
} {
    "apiVersion": "rbac.authorization.k8s.io/v1beta1",
    "kind": "ClusterRole",
    "metadata": {
        "labels": {
            "app": "mixer",
            "chart": "mixer-0.8.0",
            "heritage": "Tiller",
            "release": "RELEASE-NAME"
        },
        "name": "istio-mixer-istio-system",
        "namespace": "istio-system"
    },
    "rules": [{
        "apiGroups": ["config.istio.io"],
        "resources": ["*"],
        "verbs": ["create", "get", "list", "watch", "patch"]
    }, {
        "apiGroups": ["apiextensions.k8s.io"],
        "resources": ["customresourcedefinitions"],
        "verbs": ["get", "list", "watch"]
    }, {
        "apiGroups": [""],
        "resources": ["configmaps", "endpoints", "pods", "services", "namespaces", "secrets"],
        "verbs": ["get", "list", "watch"]
    }]
} {
    "apiVersion": "rbac.authorization.k8s.io/v1beta1",
    "kind": "ClusterRole",
    "metadata": {
        "labels": {
            "app": "istio-pilot",
            "chart": "pilot-0.8.0",
            "heritage": "Tiller",
            "release": "RELEASE-NAME"
        },
        "name": "istio-pilot-istio-system",
        "namespace": "istio-system"
    },
    "rules": [{
        "apiGroups": ["config.istio.io"],
        "resources": ["*"],
        "verbs": ["*"]
    }, {
        "apiGroups": ["networking.istio.io"],
        "resources": ["*"],
        "verbs": ["*"]
    }, {
        "apiGroups": ["authentication.istio.io"],
        "resources": ["*"],
        "verbs": ["*"]
    }, {
        "apiGroups": ["apiextensions.k8s.io"],
        "resources": ["customresourcedefinitions"],
        "verbs": ["*"]
    }, {
        "apiGroups": ["extensions"],
        "resources": ["thirdpartyresources", "thirdpartyresources.extensions", "ingresses", "ingresses/status"],
        "verbs": ["*"]
    }, {
        "apiGroups": [""],
        "resources": ["configmaps"],
        "verbs": ["create", "get", "list", "watch", "update"]
    }, {
        "apiGroups": [""],
        "resources": ["endpoints", "pods", "services"],
        "verbs": ["get", "list", "watch"]
    }, {
        "apiGroups": [""],
        "resources": ["namespaces", "nodes", "secrets"],
        "verbs": ["get", "list", "watch"]
    }]
} {
    "apiVersion": "rbac.authorization.k8s.io/v1beta1",
    "kind": "ClusterRole",
    "metadata": {
        "labels": {
            "app": "security",
            "chart": "security-0.8.0",
            "heritage": "Tiller",
            "release": "RELEASE-NAME"
        },
        "name": "istio-citadel-istio-system",
        "namespace": "istio-system"
    },
    "rules": [{
        "apiGroups": [""],
        "resources": ["secrets"],
        "verbs": ["create", "get", "watch", "list", "update", "delete"]
    }, {
        "apiGroups": [""],
        "resources": ["serviceaccounts"],
        "verbs": ["get", "watch", "list"]
    }, {
        "apiGroups": [""],
        "resources": ["services"],
        "verbs": ["get", "watch", "list"]
    }]
} {
    "apiVersion": "rbac.authorization.k8s.io/v1beta1",
    "kind": "Role",
    "metadata": {
        "labels": {
            "app": "security",
            "chart": "security-0.8.0",
            "heritage": "Tiller",
            "release": "RELEASE-NAME"
        },
        "name": "istio-cleanup-old-ca-istio-system",
        "namespace": "istio-system"
    },
    "rules": [{
        "apiGroups": [""],
        "resources": ["deployments", "serviceaccounts", "services"],
        "verbs": ["get", "delete"]
    }, {
        "apiGroups": ["extensions"],
        "resources": ["deployments", "replicasets"],
        "verbs": ["get", "list", "update", "delete"]
    }]
} {
    "apiVersion": "rbac.authorization.k8s.io/v1beta1",
    "kind": "ClusterRole",
    "metadata": {
        "labels": {
            "app": "istio-sidecar-injector",
            "chart": "sidecarInjectorWebhook-0.8.0",
            "heritage": "Tiller",
            "release": "RELEASE-NAME"
        },
        "name": "istio-sidecar-injector-istio-system"
    },
    "rules": [{
        "apiGroups": ["*"],
        "resources": ["configmaps"],
        "verbs": ["get", "list", "watch"]
    }, {
        "apiGroups": ["admissionregistration.k8s.io"],
        "resources": ["mutatingwebhookconfigurations"],
        "verbs": ["get", "list", "watch", "patch"]
    }]
} {
    "apiVersion": "rbac.authorization.k8s.io/v1beta1",
    "kind": "ClusterRoleBinding",
    "metadata": {
        "name": "istio-ingress-istio-system"
    },
    "roleRef": {
        "apiGroup": "rbac.authorization.k8s.io",
        "kind": "ClusterRole",
        "name": "istio-pilot-istio-system"
    },
    "subjects": [{
        "kind": "ServiceAccount",
        "name": "istio-ingress-service-account",
        "namespace": "istio-system"
    }]
} {
    "apiVersion": "rbac.authorization.k8s.io/v1beta1",
    "kind": "ClusterRoleBinding",
    "metadata": {
        "labels": {
            "app": "mixer",
            "chart": "mixer-0.8.0",
            "heritage": "Tiller",
            "release": "RELEASE-NAME"
        },
        "name": "istio-mixer-admin-role-binding-istio-system"
    },
    "roleRef": {
        "apiGroup": "rbac.authorization.k8s.io",
        "kind": "ClusterRole",
        "name": "istio-mixer-istio-system"
    },
    "subjects": [{
        "kind": "ServiceAccount",
        "name": "istio-mixer-service-account",
        "namespace": "istio-system"
    }]
} {
    "apiVersion": "rbac.authorization.k8s.io/v1beta1",
    "kind": "ClusterRoleBinding",
    "metadata": {
        "labels": {
            "app": "istio-pilot",
            "chart": "pilot-0.8.0",
            "heritage": "Tiller",
            "release": "RELEASE-NAME"
        },
        "name": "istio-pilot-istio-system"
    },
    "roleRef": {
        "apiGroup": "rbac.authorization.k8s.io",
        "kind": "ClusterRole",
        "name": "istio-pilot-istio-system"
    },
    "subjects": [{
        "kind": "ServiceAccount",
        "name": "istio-pilot-service-account",
        "namespace": "istio-system"
    }]
} {
    "apiVersion": "rbac.authorization.k8s.io/v1beta1",
    "kind": "ClusterRoleBinding",
    "metadata": {
        "labels": {
            "app": "security",
            "chart": "security-0.8.0",
            "heritage": "Tiller",
            "release": "RELEASE-NAME"
        },
        "name": "istio-citadel-istio-system"
    },
    "roleRef": {
        "apiGroup": "rbac.authorization.k8s.io",
        "kind": "ClusterRole",
        "name": "istio-citadel-istio-system"
    },
    "subjects": [{
        "kind": "ServiceAccount",
        "name": "istio-citadel-service-account",
        "namespace": "istio-system"
    }]
} {
    "apiVersion": "rbac.authorization.k8s.io/v1beta1",
    "kind": "RoleBinding",
    "metadata": {
        "labels": {
            "app": "security",
            "chart": "security-0.8.0",
            "heritage": "Tiller",
            "release": "RELEASE-NAME"
        },
        "name": "istio-cleanup-old-ca-istio-system",
        "namespace": "istio-system"
    },
    "roleRef": {
        "apiGroup": "rbac.authorization.k8s.io",
        "kind": "Role",
        "name": "istio-cleanup-old-ca-istio-system"
    },
    "subjects": [{
        "kind": "ServiceAccount",
        "name": "istio-cleanup-old-ca-service-account",
        "namespace": "istio-system"
    }]
} {
    "apiVersion": "rbac.authorization.k8s.io/v1beta1",
    "kind": "ClusterRoleBinding",
    "metadata": {
        "labels": {
            "app": "istio-sidecar-injector",
            "chart": "sidecarInjectorWebhook-0.8.0",
            "heritage": "Tiller",
            "release": "RELEASE-NAME"
        },
        "name": "istio-sidecar-injector-admin-role-binding-istio-system"
    },
    "roleRef": {
        "apiGroup": "rbac.authorization.k8s.io",
        "kind": "ClusterRole",
        "name": "istio-sidecar-injector-istio-system"
    },
    "subjects": [{
        "kind": "ServiceAccount",
        "name": "istio-sidecar-injector-service-account",
        "namespace": "istio-system"
    }]
} {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "labels": {
            "chart": "egressgateway-0.8.0",
            "heritage": "Tiller",
            "istio": "egressgateway",
            "release": "RELEASE-NAME"
        },
        "name": "istio-egressgateway",
        "namespace": "istio-system"
    },
    "spec": {
        "ports": [{
            "name": "http",
            "port": 80
        }, {
            "name": "https",
            "port": 443
        }],
        "selector": {
            "istio": "egressgateway"
        },
        "type": "ClusterIP"
    }
} {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "labels": {
            "chart": "ingress-0.8.0",
            "heritage": "Tiller",
            "istio": "ingress",
            "release": "RELEASE-NAME"
        },
        "name": "istio-ingress",
        "namespace": "istio-system"
    },
    "spec": {
        "ports": [{
            "name": "http",
            "nodePort": 32000,
            "port": 80
        }, {
            "name": "https",
            "port": 443
        }],
        "selector": {
            "istio": "ingress"
        },
        "type": "NodePort"
    }
}
null {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "labels": {
            "chart": "ingressgateway-0.8.0",
            "heritage": "Tiller",
            "istio": "ingressgateway",
            "release": "RELEASE-NAME"
        },
        "name": "istio-ingressgateway",
        "namespace": "istio-system"
    },
    "spec": {
        "ports": [{
            "name": "http",
            "nodePort": 31380,
            "port": 80
        }, {
            "name": "https",
            "nodePort": 31390,
            "port": 443
        }, {
            "name": "tcp",
            "nodePort": 31400,
            "port": 31400
        }],
        "selector": {
            "istio": "ingressgateway"
        },
        "type": "NodePort"
    }
} {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "labels": {
            "chart": "mixer-0.8.0",
            "istio": "mixer",
            "release": "RELEASE-NAME"
        },
        "name": "istio-policy",
        "namespace": "istio-system"
    },
    "spec": {
        "ports": [{
            "name": "grpc-mixer",
            "port": 9091
        }, {
            "name": "grpc-mixer-mtls",
            "port": 15004
        }, {
            "name": "http-monitoring",
            "port": 9093
        }],
        "selector": {
            "istio": "mixer",
            "istio-mixer-type": "policy"
        }
    }
} {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "labels": {
            "chart": "mixer-0.8.0",
            "istio": "mixer",
            "release": "RELEASE-NAME"
        },
        "name": "istio-telemetry",
        "namespace": "istio-system"
    },
    "spec": {
        "ports": [{
            "name": "grpc-mixer",
            "port": 9091
        }, {
            "name": "grpc-mixer-mtls",
            "port": 15004
        }, {
            "name": "http-monitoring",
            "port": 9093
        }, {
            "name": "prometheus",
            "port": 42422
        }],
        "selector": {
            "istio": "mixer",
            "istio-mixer-type": "telemetry"
        }
    }
}
null
null {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "labels": {
            "chart": "mixer-0.8.0",
            "istio": "statsd-prom-bridge",
            "release": "RELEASE-NAME"
        },
        "name": "istio-statsd-prom-bridge",
        "namespace": "istio-system"
    },
    "spec": {
        "ports": [{
            "name": "statsd-prom",
            "port": 9102
        }, {
            "name": "statsd-udp",
            "port": 9125,
            "protocol": "UDP"
        }],
        "selector": {
            "istio": "statsd-prom-bridge"
        }
    }
} {
    "apiVersion": "extensions/v1beta1",
    "kind": "Deployment",
    "metadata": {
        "labels": {
            "chart": "mixer-0.8.0",
            "istio": "mixer",
            "release": "RELEASE-NAME"
        },
        "name": "istio-statsd-prom-bridge",
        "namespace": "istio-system"
    },
    "spec": {
        "template": {
            "metadata": {
                "annotations": {
                    "sidecar.istio.io/inject": "false"
                },
                "labels": {
                    "istio": "statsd-prom-bridge"
                }
            },
            "spec": {
                "containers": [{
                    "args": ["-statsd.mapping-config=/etc/statsd/mapping.conf"],
                    "image": "prom/statsd-exporter:latest",
                    "imagePullPolicy": "IfNotPresent",
                    "name": "statsd-prom-bridge",
                    "ports": [{
                        "containerPort": 9102
                    }, {
                        "containerPort": 9125,
                        "protocol": "UDP"
                    }],
                    "resources": {},
                    "volumeMounts": [{
                        "mountPath": "/etc/statsd",
                        "name": "config-volume"
                    }]
                }],
                "serviceAccountName": "istio-mixer-service-account",
                "volumes": [{
                    "configMap": {
                        "name": "istio-statsd-prom-bridge"
                    },
                    "name": "config-volume"
                }]
            }
        }
    }
} {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "labels": {
            "app": "istio-pilot",
            "chart": "pilot-0.8.0",
            "heritage": "Tiller",
            "release": "RELEASE-NAME"
        },
        "name": "istio-pilot",
        "namespace": "istio-system"
    },
    "spec": {
        "ports": [{
            "name": "http-old-discovery",
            "port": 15003
        }, {
            "name": "https-discovery",
            "port": 15005
        }, {
            "name": "http-discovery",
            "port": 15007
        }, {
            "name": "grpc-xds",
            "port": 15010
        }, {
            "name": "https-xds",
            "port": 15011
        }, {
            "name": "http-legacy-discovery",
            "port": 8080
        }, {
            "name": "http-monitoring",
            "port": 9093
        }],
        "selector": {
            "istio": "pilot"
        }
    }
} {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "labels": {
            "app": "istio-citadel"
        },
        "name": "istio-citadel",
        "namespace": "istio-system"
    },
    "spec": {
        "ports": [{
            "name": "grpc-citadel",
            "port": 8060,
            "protocol": "TCP",
            "targetPort": 8060
        }, {
            "name": "http-monitoring",
            "port": 9093
        }],
        "selector": {
            "istio": "citadel"
        }
    }
} {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "labels": {
            "istio": "sidecar-injector"
        },
        "name": "istio-sidecar-injector",
        "namespace": "istio-system"
    },
    "spec": {
        "ports": [{
            "port": 443
        }],
        "selector": {
            "istio": "sidecar-injector"
        }
    }
} {
    "apiVersion": "extensions/v1beta1",
    "kind": "Deployment",
    "metadata": {
        "labels": {
            "app": "egressgateway",
            "chart": "egressgateway-0.8.0",
            "heritage": "Tiller",
            "istio": "egressgateway",
            "release": "RELEASE-NAME"
        },
        "name": "istio-egressgateway",
        "namespace": "istio-system"
    },
    "spec": {
        "replicas": null,
        "template": {
            "metadata": {
                "annotations": {
                    "sidecar.istio.io/inject": "false"
                },
                "labels": {
                    "istio": "egressgateway"
                }
            },
            "spec": {
                "affinity": {
                    "nodeAffinity": {
                        "preferredDuringSchedulingIgnoredDuringExecution": [{
                            "preference": {
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["amd64"]
                                }]
                            },
                            "weight": 2
                        }, {
                            "preference": {
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["ppc64le"]
                                }]
                            },
                            "weight": 2
                        }, {
                            "preference": {
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["s390x"]
                                }]
                            },
                            "weight": 2
                        }],
                        "requiredDuringSchedulingIgnoredDuringExecution": {
                            "nodeSelectorTerms": [{
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["amd64", "ppc64le", "s390x"]
                                }]
                            }]
                        }
                    }
                },
                "containers": [{
                    "args": ["proxy", "router", "-v", "2", "--discoveryRefreshDelay", "1s", "--drainDuration", "45s", "--parentShutdownDuration", "1m0s", "--connectTimeout", "10s", "--serviceCluster", "istio-egressgateway", "--zipkinAddress", "zipkin:9411", "--statsdUdpAddress", "istio-statsd-prom-bridge:9125", "--proxyAdminPort", "15000", "--controlPlaneAuthPolicy", "NONE", "--discoveryAddress", "istio-pilot:8080"],
                    "env": [{
                        "name": "POD_NAME",
                        "valueFrom": {
                            "fieldRef": {
                                "apiVersion": "v1",
                                "fieldPath": "metadata.name"
                            }
                        }
                    }, {
                        "name": "POD_NAMESPACE",
                        "valueFrom": {
                            "fieldRef": {
                                "apiVersion": "v1",
                                "fieldPath": "metadata.namespace"
                            }
                        }
                    }, {
                        "name": "INSTANCE_IP",
                        "valueFrom": {
                            "fieldRef": {
                                "fieldPath": "status.podIP"
                            }
                        }
                    }, {
                        "name": "ISTIO_META_POD_NAME",
                        "valueFrom": {
                            "fieldRef": {
                                "fieldPath": "metadata.name"
                            }
                        }
                    }],
                    "image": "docker.io/istio/proxyv2:0.8.0",
                    "imagePullPolicy": "IfNotPresent",
                    "name": "egressgateway",
                    "ports": [{
                        "containerPort": 80
                    }, {
                        "containerPort": 443
                    }],
                    "resources": {},
                    "volumeMounts": [{
                        "mountPath": "/etc/certs",
                        "name": "istio-certs",
                        "readOnly": true
                    }]
                }],
                "serviceAccountName": "istio-egressgateway-service-account",
                "volumes": [{
                    "name": "istio-certs",
                    "secret": {
                        "optional": true,
                        "secretName": "istio.default"
                    }
                }]
            }
        }
    }
} {
    "apiVersion": "extensions/v1beta1",
    "kind": "Deployment",
    "metadata": {
        "labels": {
            "app": "ingress",
            "chart": "ingress-0.8.0",
            "heritage": "Tiller",
            "istio": "ingress",
            "release": "RELEASE-NAME"
        },
        "name": "istio-ingress",
        "namespace": "istio-system"
    },
    "spec": {
        "replicas": null,
        "template": {
            "metadata": {
                "annotations": {
                    "sidecar.istio.io/inject": "false"
                },
                "labels": {
                    "istio": "ingress"
                }
            },
            "spec": {
                "affinity": {
                    "nodeAffinity": {
                        "preferredDuringSchedulingIgnoredDuringExecution": [{
                            "preference": {
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["amd64"]
                                }]
                            },
                            "weight": 2
                        }, {
                            "preference": {
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["ppc64le"]
                                }]
                            },
                            "weight": 2
                        }, {
                            "preference": {
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["s390x"]
                                }]
                            },
                            "weight": 2
                        }],
                        "requiredDuringSchedulingIgnoredDuringExecution": {
                            "nodeSelectorTerms": [{
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["amd64", "ppc64le", "s390x"]
                                }]
                            }]
                        }
                    }
                },
                "containers": [{
                    "args": ["proxy", "ingress", "-v", "2", "--discoveryRefreshDelay", "1s", "--drainDuration", "45s", "--parentShutdownDuration", "1m0s", "--connectTimeout", "10s", "--serviceCluster", "istio-ingress", "--zipkinAddress", "zipkin:9411", "--statsdUdpAddress", "istio-statsd-prom-bridge:9125", "--proxyAdminPort", "15000", "--controlPlaneAuthPolicy", "NONE", "--discoveryAddress", "istio-pilot:8080"],
                    "env": [{
                        "name": "POD_NAME",
                        "valueFrom": {
                            "fieldRef": {
                                "apiVersion": "v1",
                                "fieldPath": "metadata.name"
                            }
                        }
                    }, {
                        "name": "POD_NAMESPACE",
                        "valueFrom": {
                            "fieldRef": {
                                "apiVersion": "v1",
                                "fieldPath": "metadata.namespace"
                            }
                        }
                    }, {
                        "name": "INSTANCE_IP",
                        "valueFrom": {
                            "fieldRef": {
                                "apiVersion": "v1",
                                "fieldPath": "status.podIP"
                            }
                        }
                    }],
                    "image": "docker.io/istio/proxy:0.8.0",
                    "imagePullPolicy": "IfNotPresent",
                    "name": "ingress",
                    "ports": [{
                        "containerPort": 80
                    }, {
                        "containerPort": 443
                    }],
                    "resources": {},
                    "volumeMounts": [{
                        "mountPath": "/etc/certs",
                        "name": "istio-certs",
                        "readOnly": true
                    }, {
                        "mountPath": "/etc/istio/ingress-certs",
                        "name": "ingress-certs",
                        "readOnly": true
                    }]
                }],
                "serviceAccountName": "istio-ingress-service-account",
                "volumes": [{
                    "name": "istio-certs",
                    "secret": {
                        "optional": true,
                        "secretName": "istio.default"
                    }
                }, {
                    "name": "ingress-certs",
                    "secret": {
                        "optional": true,
                        "secretName": "istio-ingress-certs"
                    }
                }]
            }
        }
    }
} {
    "apiVersion": "extensions/v1beta1",
    "kind": "Deployment",
    "metadata": {
        "labels": {
            "app": "ingressgateway",
            "chart": "ingressgateway-0.8.0",
            "heritage": "Tiller",
            "istio": "ingressgateway",
            "release": "RELEASE-NAME"
        },
        "name": "istio-ingressgateway",
        "namespace": "istio-system"
    },
    "spec": {
        "replicas": null,
        "template": {
            "metadata": {
                "annotations": {
                    "sidecar.istio.io/inject": "false"
                },
                "labels": {
                    "istio": "ingressgateway"
                }
            },
            "spec": {
                "affinity": {
                    "nodeAffinity": {
                        "preferredDuringSchedulingIgnoredDuringExecution": [{
                            "preference": {
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["amd64"]
                                }]
                            },
                            "weight": 2
                        }, {
                            "preference": {
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["ppc64le"]
                                }]
                            },
                            "weight": 2
                        }, {
                            "preference": {
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["s390x"]
                                }]
                            },
                            "weight": 2
                        }],
                        "requiredDuringSchedulingIgnoredDuringExecution": {
                            "nodeSelectorTerms": [{
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["amd64", "ppc64le", "s390x"]
                                }]
                            }]
                        }
                    }
                },
                "containers": [{
                    "args": ["proxy", "router", "-v", "2", "--discoveryRefreshDelay", "1s", "--drainDuration", "45s", "--parentShutdownDuration", "1m0s", "--connectTimeout", "10s", "--serviceCluster", "istio-ingressgateway", "--zipkinAddress", "zipkin:9411", "--statsdUdpAddress", "istio-statsd-prom-bridge:9125", "--proxyAdminPort", "15000", "--controlPlaneAuthPolicy", "NONE", "--discoveryAddress", "istio-pilot:8080"],
                    "env": [{
                        "name": "POD_NAME",
                        "valueFrom": {
                            "fieldRef": {
                                "apiVersion": "v1",
                                "fieldPath": "metadata.name"
                            }
                        }
                    }, {
                        "name": "POD_NAMESPACE",
                        "valueFrom": {
                            "fieldRef": {
                                "apiVersion": "v1",
                                "fieldPath": "metadata.namespace"
                            }
                        }
                    }, {
                        "name": "INSTANCE_IP",
                        "valueFrom": {
                            "fieldRef": {
                                "apiVersion": "v1",
                                "fieldPath": "status.podIP"
                            }
                        }
                    }, {
                        "name": "ISTIO_META_POD_NAME",
                        "valueFrom": {
                            "fieldRef": {
                                "fieldPath": "metadata.name"
                            }
                        }
                    }],
                    "image": "docker.io/istio/proxyv2:0.8.0",
                    "imagePullPolicy": "IfNotPresent",
                    "name": "ingressgateway",
                    "ports": [{
                        "containerPort": 80
                    }, {
                        "containerPort": 443
                    }, {
                        "containerPort": 31400
                    }],
                    "resources": {},
                    "volumeMounts": [{
                        "mountPath": "/etc/certs",
                        "name": "istio-certs",
                        "readOnly": true
                    }, {
                        "mountPath": "/etc/istio/ingressgateway-certs",
                        "name": "ingressgateway-certs",
                        "readOnly": true
                    }]
                }],
                "serviceAccountName": "istio-ingressgateway-service-account",
                "volumes": [{
                    "name": "istio-certs",
                    "secret": {
                        "optional": true,
                        "secretName": "istio.default"
                    }
                }, {
                    "name": "ingressgateway-certs",
                    "secret": {
                        "optional": true,
                        "secretName": "istio-ingressgateway-certs"
                    }
                }]
            }
        }
    }
} {
    "apiVersion": "extensions/v1beta1",
    "kind": "Deployment",
    "metadata": {
        "labels": {
            "chart": "mixer-0.8.0",
            "istio": "mixer",
            "release": "RELEASE-NAME"
        },
        "name": "istio-policy",
        "namespace": "istio-system"
    },
    "spec": {
        "replicas": 1,
        "template": {
            "metadata": {
                "annotations": {
                    "sidecar.istio.io/inject": "false"
                },
                "labels": {
                    "istio": "mixer",
                    "istio-mixer-type": "policy"
                }
            },
            "spec": {
                "affinity": {
                    "nodeAffinity": {
                        "preferredDuringSchedulingIgnoredDuringExecution": [{
                            "preference": {
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["amd64"]
                                }]
                            },
                            "weight": 2
                        }, {
                            "preference": {
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["ppc64le"]
                                }]
                            },
                            "weight": 2
                        }, {
                            "preference": {
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["s390x"]
                                }]
                            },
                            "weight": 2
                        }],
                        "requiredDuringSchedulingIgnoredDuringExecution": {
                            "nodeSelectorTerms": [{
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["amd64", "ppc64le", "s390x"]
                                }]
                            }]
                        }
                    }
                },
                "containers": [{
                    "args": ["--address", "tcp://127.0.0.1:9092", "--configStoreURL=k8s://", "--configDefaultNamespace=istio-system", "--trace_zipkin_url=http://zipkin:9411/api/v1/spans"],
                    "image": "docker.io/istio/mixer:0.8.0",
                    "imagePullPolicy": "IfNotPresent",
                    "name": "mixer",
                    "ports": [{
                        "containerPort": 9092
                    }, {
                        "containerPort": 9093
                    }, {
                        "containerPort": 42422
                    }],
                    "resources": {}
                }, {
                    "args": ["proxy", "--serviceCluster", "istio-policy", "--templateFile", "/etc/istio/proxy/envoy_policy.yaml.tmpl", "--controlPlaneAuthPolicy", "NONE"],
                    "env": [{
                        "name": "POD_NAME",
                        "valueFrom": {
                            "fieldRef": {
                                "apiVersion": "v1",
                                "fieldPath": "metadata.name"
                            }
                        }
                    }, {
                        "name": "POD_NAMESPACE",
                        "valueFrom": {
                            "fieldRef": {
                                "apiVersion": "v1",
                                "fieldPath": "metadata.namespace"
                            }
                        }
                    }, {
                        "name": "INSTANCE_IP",
                        "valueFrom": {
                            "fieldRef": {
                                "apiVersion": "v1",
                                "fieldPath": "status.podIP"
                            }
                        }
                    }],
                    "image": "docker.io/istio/proxyv2:0.8.0",
                    "imagePullPolicy": "IfNotPresent",
                    "name": "istio-proxy",
                    "ports": [{
                        "containerPort": 9091
                    }, {
                        "containerPort": 15004
                    }],
                    "resources": {
                        "requests": {
                            "cpu": "100m",
                            "memory": "128Mi"
                        }
                    },
                    "volumeMounts": [{
                        "mountPath": "/etc/certs",
                        "name": "istio-certs",
                        "readOnly": true
                    }]
                }],
                "serviceAccountName": "istio-mixer-service-account",
                "volumes": [{
                    "name": "istio-certs",
                    "secret": {
                        "optional": true,
                        "secretName": "istio.istio-mixer-service-account"
                    }
                }]
            }
        }
    }
} {
    "apiVersion": "extensions/v1beta1",
    "kind": "Deployment",
    "metadata": {
        "labels": {
            "chart": "mixer-0.8.0",
            "istio": "mixer",
            "release": "RELEASE-NAME"
        },
        "name": "istio-telemetry",
        "namespace": "istio-system"
    },
    "spec": {
        "replicas": 1,
        "template": {
            "metadata": {
                "annotations": {
                    "sidecar.istio.io/inject": "false"
                },
                "labels": {
                    "istio": "mixer",
                    "istio-mixer-type": "telemetry"
                }
            },
            "spec": {
                "containers": [{
                    "args": ["--address", "tcp://127.0.0.1:9092", "--configStoreURL=k8s://", "--configDefaultNamespace=istio-system", "--trace_zipkin_url=http://zipkin:9411/api/v1/spans"],
                    "image": "docker.io/istio/mixer:0.8.0",
                    "imagePullPolicy": "IfNotPresent",
                    "name": "mixer",
                    "ports": [{
                        "containerPort": 9092
                    }, {
                        "containerPort": 9093
                    }, {
                        "containerPort": 42422
                    }],
                    "resources": {}
                }, {
                    "args": ["proxy", "--serviceCluster", "istio-telemetry", "--templateFile", "/etc/istio/proxy/envoy_telemetry.yaml.tmpl", "--controlPlaneAuthPolicy", "NONE"],
                    "env": [{
                        "name": "POD_NAME",
                        "valueFrom": {
                            "fieldRef": {
                                "apiVersion": "v1",
                                "fieldPath": "metadata.name"
                            }
                        }
                    }, {
                        "name": "POD_NAMESPACE",
                        "valueFrom": {
                            "fieldRef": {
                                "apiVersion": "v1",
                                "fieldPath": "metadata.namespace"
                            }
                        }
                    }, {
                        "name": "INSTANCE_IP",
                        "valueFrom": {
                            "fieldRef": {
                                "apiVersion": "v1",
                                "fieldPath": "status.podIP"
                            }
                        }
                    }],
                    "image": "docker.io/istio/proxyv2:0.8.0",
                    "imagePullPolicy": "IfNotPresent",
                    "name": "istio-proxy",
                    "ports": [{
                        "containerPort": 9091
                    }, {
                        "containerPort": 15004
                    }],
                    "resources": {
                        "requests": {
                            "cpu": "100m",
                            "memory": "128Mi"
                        }
                    },
                    "volumeMounts": [{
                        "mountPath": "/etc/certs",
                        "name": "istio-certs",
                        "readOnly": true
                    }]
                }],
                "serviceAccountName": "istio-mixer-service-account",
                "volumes": [{
                    "name": "istio-certs",
                    "secret": {
                        "optional": true,
                        "secretName": "istio.istio-mixer-service-account"
                    }
                }]
            }
        }
    }
}
null {
    "apiVersion": "extensions/v1beta1",
    "kind": "Deployment",
    "metadata": {
        "annotations": {
            "checksum/config-volume": "f8da08b6b8c170dde721efd680270b2901e750d4aa186ebb6c22bef5b78a43f9"
        },
        "labels": {
            "app": "istio-pilot",
            "chart": "pilot-0.8.0",
            "heritage": "Tiller",
            "istio": "pilot",
            "release": "RELEASE-NAME"
        },
        "name": "istio-pilot",
        "namespace": "istio-system"
    },
    "spec": {
        "replicas": 1,
        "template": {
            "metadata": {
                "annotations": {
                    "sidecar.istio.io/inject": "false"
                },
                "labels": {
                    "istio": "pilot"
                }
            },
            "spec": {
                "affinity": {
                    "nodeAffinity": {
                        "preferredDuringSchedulingIgnoredDuringExecution": [{
                            "preference": {
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["amd64"]
                                }]
                            },
                            "weight": 2
                        }, {
                            "preference": {
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["ppc64le"]
                                }]
                            },
                            "weight": 2
                        }, {
                            "preference": {
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["s390x"]
                                }]
                            },
                            "weight": 2
                        }],
                        "requiredDuringSchedulingIgnoredDuringExecution": {
                            "nodeSelectorTerms": [{
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["amd64", "ppc64le", "s390x"]
                                }]
                            }]
                        }
                    }
                },
                "containers": [{
                    "args": ["discovery"],
                    "env": [{
                        "name": "POD_NAME",
                        "valueFrom": {
                            "fieldRef": {
                                "apiVersion": "v1",
                                "fieldPath": "metadata.name"
                            }
                        }
                    }, {
                        "name": "POD_NAMESPACE",
                        "valueFrom": {
                            "fieldRef": {
                                "apiVersion": "v1",
                                "fieldPath": "metadata.namespace"
                            }
                        }
                    }, {
                        "name": "PILOT_THROTTLE",
                        "value": "500"
                    }, {
                        "name": "PILOT_CACHE_SQUASH",
                        "value": "5"
                    }],
                    "image": "docker.io/istio/pilot:0.8.0",
                    "imagePullPolicy": "IfNotPresent",
                    "name": "discovery",
                    "ports": [{
                        "containerPort": 8080
                    }, {
                        "containerPort": 15010
                    }],
                    "readinessProbe": {
                        "httpGet": {
                            "path": "/v1/registration",
                            "port": 8080
                        },
                        "initialDelaySeconds": 30,
                        "periodSeconds": 30,
                        "timeoutSeconds": 5
                    },
                    "resources": {},
                    "volumeMounts": [{
                        "mountPath": "/etc/istio/config",
                        "name": "config-volume"
                    }, {
                        "mountPath": "/etc/certs",
                        "name": "istio-certs",
                        "readOnly": true
                    }]
                }, {
                    "args": ["proxy", "--serviceCluster", "istio-pilot", "--templateFile", "/etc/istio/proxy/envoy_pilot.yaml.tmpl", "--controlPlaneAuthPolicy", "NONE"],
                    "env": [{
                        "name": "POD_NAME",
                        "valueFrom": {
                            "fieldRef": {
                                "apiVersion": "v1",
                                "fieldPath": "metadata.name"
                            }
                        }
                    }, {
                        "name": "POD_NAMESPACE",
                        "valueFrom": {
                            "fieldRef": {
                                "apiVersion": "v1",
                                "fieldPath": "metadata.namespace"
                            }
                        }
                    }, {
                        "name": "INSTANCE_IP",
                        "valueFrom": {
                            "fieldRef": {
                                "apiVersion": "v1",
                                "fieldPath": "status.podIP"
                            }
                        }
                    }],
                    "image": "docker.io/istio/proxyv2:0.8.0",
                    "imagePullPolicy": "IfNotPresent",
                    "name": "istio-proxy",
                    "ports": [{
                        "containerPort": 15003
                    }, {
                        "containerPort": 15005
                    }, {
                        "containerPort": 15007
                    }, {
                        "containerPort": 15011
                    }],
                    "resources": {
                        "requests": {
                            "cpu": "100m",
                            "memory": "128Mi"
                        }
                    },
                    "volumeMounts": [{
                        "mountPath": "/etc/certs",
                        "name": "istio-certs",
                        "readOnly": true
                    }]
                }],
                "serviceAccountName": "istio-pilot-service-account",
                "volumes": [{
                    "configMap": {
                        "name": "istio"
                    },
                    "name": "config-volume"
                }, {
                    "name": "istio-certs",
                    "secret": {
                        "secretName": "istio.istio-pilot-service-account"
                    }
                }]
            }
        }
    }
} {
    "apiVersion": "extensions/v1beta1",
    "kind": "Deployment",
    "metadata": {
        "labels": {
            "app": "security",
            "chart": "security-0.8.0",
            "heritage": "Tiller",
            "istio": "citadel",
            "release": "RELEASE-NAME"
        },
        "name": "istio-citadel",
        "namespace": "istio-system"
    },
    "spec": {
        "replicas": 1,
        "template": {
            "metadata": {
                "annotations": {
                    "sidecar.istio.io/inject": "false"
                },
                "labels": {
                    "istio": "citadel"
                }
            },
            "spec": {
                "affinity": {
                    "nodeAffinity": {
                        "preferredDuringSchedulingIgnoredDuringExecution": [{
                            "preference": {
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["amd64"]
                                }]
                            },
                            "weight": 2
                        }, {
                            "preference": {
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["ppc64le"]
                                }]
                            },
                            "weight": 2
                        }, {
                            "preference": {
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["s390x"]
                                }]
                            },
                            "weight": 2
                        }],
                        "requiredDuringSchedulingIgnoredDuringExecution": {
                            "nodeSelectorTerms": [{
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["amd64", "ppc64le", "s390x"]
                                }]
                            }]
                        }
                    }
                },
                "containers": [{
                    "args": ["--append-dns-names=true", "--grpc-port=8060", "--grpc-hostname=citadel", "--self-signed-ca=true", "--citadel-storage-namespace=istio-system"],
                    "image": "docker.io/istio/citadel:0.8.0",
                    "imagePullPolicy": "IfNotPresent",
                    "name": "citadel",
                    "resources": {}
                }],
                "serviceAccountName": "istio-citadel-service-account"
            }
        }
    }
} {
    "apiVersion": "extensions/v1beta1",
    "kind": "Deployment",
    "metadata": {
        "labels": {
            "app": "sidecarInjectorWebhook",
            "chart": "sidecarInjectorWebhook-0.8.0",
            "heritage": "Tiller",
            "istio": "sidecar-injector",
            "release": "RELEASE-NAME"
        },
        "name": "istio-sidecar-injector",
        "namespace": "istio-system"
    },
    "spec": {
        "replicas": null,
        "template": {
            "metadata": {
                "labels": {
                    "istio": "sidecar-injector"
                }
            },
            "spec": {
                "affinity": {
                    "nodeAffinity": {
                        "preferredDuringSchedulingIgnoredDuringExecution": [{
                            "preference": {
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["amd64"]
                                }]
                            },
                            "weight": 2
                        }, {
                            "preference": {
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["ppc64le"]
                                }]
                            },
                            "weight": 2
                        }, {
                            "preference": {
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["s390x"]
                                }]
                            },
                            "weight": 2
                        }],
                        "requiredDuringSchedulingIgnoredDuringExecution": {
                            "nodeSelectorTerms": [{
                                "matchExpressions": [{
                                    "key": "beta.kubernetes.io/arch",
                                    "operator": "In",
                                    "values": ["amd64", "ppc64le", "s390x"]
                                }]
                            }]
                        }
                    }
                },
                "containers": [{
                    "args": ["--caCertFile=/etc/istio/certs/root-cert.pem", "--tlsCertFile=/etc/istio/certs/cert-chain.pem", "--tlsKeyFile=/etc/istio/certs/key.pem", "--injectConfig=/etc/istio/inject/config", "--meshConfig=/etc/istio/config/mesh", "--healthCheckInterval=2s", "--healthCheckFile=/health"],
                    "image": "docker.io/istio/sidecar_injector:0.8.0",
                    "imagePullPolicy": "IfNotPresent",
                    "livenessProbe": {
                        "exec": {
                            "command": ["/usr/local/bin/sidecar-injector", "probe", "--probe-path=/health", "--interval=2s"]
                        },
                        "initialDelaySeconds": 4,
                        "periodSeconds": 4
                    },
                    "name": "sidecar-injector-webhook",
                    "readinessProbe": {
                        "exec": {
                            "command": ["/usr/local/bin/sidecar-injector", "probe", "--probe-path=/health", "--interval=2s"]
                        },
                        "initialDelaySeconds": 4,
                        "periodSeconds": 4
                    },
                    "volumeMounts": [{
                        "mountPath": "/etc/istio/config",
                        "name": "config-volume",
                        "readOnly": true
                    }, {
                        "mountPath": "/etc/istio/certs",
                        "name": "certs",
                        "readOnly": true
                    }, {
                        "mountPath": "/etc/istio/inject",
                        "name": "inject-config",
                        "readOnly": true
                    }]
                }],
                "serviceAccountName": "istio-sidecar-injector-service-account",
                "volumes": [{
                    "configMap": {
                        "name": "istio"
                    },
                    "name": "config-volume"
                }, {
                    "name": "certs",
                    "secret": {
                        "secretName": "istio.istio-sidecar-injector-service-account"
                    }
                }, {
                    "configMap": {
                        "items": [{
                            "key": "config",
                            "path": "config"
                        }],
                        "name": "istio-sidecar-injector"
                    },
                    "name": "inject-config"
                }]
            }
        }
    }
} {
    "apiVersion": "batch/v1",
    "kind": "Job",
    "metadata": {
        "annotations": {
            "helm.sh/hook": "post-install",
            "helm.sh/hook-delete-policy": "hook-succeeded"
        },
        "labels": {
            "app": "security",
            "chart": "security-0.8.0",
            "heritage": "Tiller",
            "release": "RELEASE-NAME"
        },
        "name": "istio-cleanup-old-ca",
        "namespace": "istio-system"
    },
    "spec": {
        "template": {
            "metadata": {
                "labels": {
                    "app": "security",
                    "release": "RELEASE-NAME"
                },
                "name": "istio-cleanup-old-ca"
            },
            "spec": {
                "containers": [{
                    "command": ["/bin/bash", "-c", "NS=\"-n istio-system\"; ./kubectl get deploy istio-ca $NS; if [[ $? = 0 ]]; then ./kubectl delete deploy istio-ca $NS; fi; ./kubectl get serviceaccount istio-ca-service-account $NS; if [[ $? = 0 ]]; then ./kubectl delete serviceaccount istio-ca-service-account $NS; fi; ./kubectl get service istio-ca-ilb $NS; if [[ $? = 0 ]]; then ./kubectl delete service istio-ca-ilb $NS; fi\n"],
                    "image": "quay.io/coreos/hyperkube:v1.7.6_coreos.0",
                    "name": "hyperkube"
                }],
                "restartPolicy": "Never",
                "serviceAccountName": "istio-cleanup-old-ca-service-account"
            }
        }
    }
} {
    "apiVersion": "autoscaling/v2beta1",
    "kind": "HorizontalPodAutoscaler",
    "metadata": {
        "name": "istio-egressgateway",
        "namespace": "istio-system"
    },
    "spec": {
        "maxReplicas": 1,
        "metrics": [{
            "resource": {
                "name": "cpu",
                "targetAverageUtilization": 80
            },
            "type": "Resource"
        }],
        "minReplicas": 1,
        "scaleTargetRef": {
            "apiVersion": "apps/v1beta1",
            "kind": "Deployment",
            "name": "istio-egressgateway"
        }
    }
} {
    "apiVersion": "autoscaling/v2beta1",
    "kind": "HorizontalPodAutoscaler",
    "metadata": {
        "name": "istio-ingress",
        "namespace": "istio-system"
    },
    "spec": {
        "maxReplicas": 1,
        "metrics": [{
            "resource": {
                "name": "cpu",
                "targetAverageUtilization": 80
            },
            "type": "Resource"
        }],
        "minReplicas": 1,
        "scaleTargetRef": {
            "apiVersion": "apps/v1beta1",
            "kind": "Deployment",
            "name": "istio-ingress"
        }
    }
} {
    "apiVersion": "autoscaling/v2beta1",
    "kind": "HorizontalPodAutoscaler",
    "metadata": {
        "name": "istio-ingressgateway",
        "namespace": "istio-system"
    },
    "spec": {
        "maxReplicas": 1,
        "metrics": [{
            "resource": {
                "name": "cpu",
                "targetAverageUtilization": 80
            },
            "type": "Resource"
        }],
        "minReplicas": 1,
        "scaleTargetRef": {
            "apiVersion": "apps/v1beta1",
            "kind": "Deployment",
            "name": "istio-ingressgateway"
        }
    }
} {
    "apiVersion": "admissionregistration.k8s.io/v1beta1",
    "kind": "MutatingWebhookConfiguration",
    "metadata": {
        "labels": {
            "app": "istio-sidecar-injector",
            "chart": "sidecarInjectorWebhook-0.8.0",
            "heritage": "Tiller",
            "release": "RELEASE-NAME"
        },
        "name": "istio-sidecar-injector",
        "namespace": "istio-system"
    },
    "webhooks": [{
        "clientConfig": {
            "caBundle": "",
            "service": {
                "name": "istio-sidecar-injector",
                "namespace": "istio-system",
                "path": "/inject"
            }
        },
        "failurePolicy": "Fail",
        "name": "sidecar-injector.istio.io",
        "namespaceSelector": {
            "matchLabels": {
                "istio-injection": "enabled"
            }
        },
        "rules": [{
            "apiGroups": [""],
            "apiVersions": ["v1"],
            "operations": ["CREATE"],
            "resources": ["pods"]
        }]
    }]
}
null