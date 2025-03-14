# Changelog

## [3.5.1](https://github.com/cloud-pi-native/socle/compare/v3.5.0...v3.5.1) (2025-03-14)


### Bug Fixes

* :bug: Fix dso-config initialization ([b83af65](https://github.com/cloud-pi-native/socle/commit/b83af65dc002c0ada2ce2b6d112a843265764200))
* :bug: Fix dso-config initialization ([2dfdaf9](https://github.com/cloud-pi-native/socle/commit/2dfdaf9ba1c03555b7122b30070c8fe820a161af))

## [3.5.0](https://github.com/cloud-pi-native/socle/compare/v3.4.0...v3.5.0) (2025-03-13)


### Features

* :arrow_up: Upgrade GitLab to version 17.9.2 + adapt some values ([434d8a1](https://github.com/cloud-pi-native/socle/commit/434d8a11a34bd36518d7f8b17b7d9f3217ec1e39))
* :arrow_up: Upgrade GitLab to version 17.9.2 + adapt some values ([21c5647](https://github.com/cloud-pi-native/socle/commit/21c56474aee4f0ebc1c31b760b0a3d40be5cdec5))


### Bug Fixes

* :bug: GitLab value indentation ([3698627](https://github.com/cloud-pi-native/socle/commit/3698627aa8d18f0ff9ea1f51ea04d6b7fa325f26))
* :bug: remove duplicate spec: ([9dddcdc](https://github.com/cloud-pi-native/socle/commit/9dddcdc7493c8c524496f81fd8fafb66782b5691))
* :bug: remove duplicate spec: ([83c77d2](https://github.com/cloud-pi-native/socle/commit/83c77d286ef0d407d4e499a8bfd4ec184a1b1606))

## [3.4.0](https://github.com/cloud-pi-native/socle/compare/v3.3.1...v3.4.0) (2025-03-05)


### Features

* :arrow_up: Upgrade Keycloak to version 26.1.2 ([8bfef6d](https://github.com/cloud-pi-native/socle/commit/8bfef6d389fe4b4e38b23c3304e568d29c337791))
* :sparkles: Add Console server restart tasks and messages ([7ee5b95](https://github.com/cloud-pi-native/socle/commit/7ee5b95b6a6999a9dae5cfe603b57cfdb273182f))
* :sparkles: Add keycloak admin reset playbook ([da2a596](https://github.com/cloud-pi-native/socle/commit/da2a59663154e6c4cc3a6ea78df78bb4b4794a62))
* :sparkles: Add keycloak user unlock playbook ([129b34e](https://github.com/cloud-pi-native/socle/commit/129b34e09e052b18ab0f2fd4ac6b661b1c2a18dc))
* :sparkles: introduce gitlab backup ([6f95582](https://github.com/cloud-pi-native/socle/commit/6f95582f380783bfa66be2979d8a9d52a950eaf7))
* :sparkles: Upgrade Keycloak to 26.1.3 version ([773adbd](https://github.com/cloud-pi-native/socle/commit/773adbdd9174ecb27f699ddd895fbee7c581a3ef))


### Bug Fixes

* :rotating_light: Comments indentation ([58a0263](https://github.com/cloud-pi-native/socle/commit/58a02633eae32d131bea752d4910beaec9fc1f90))
* :wrench: forgot validate_certs ([74ebc12](https://github.com/cloud-pi-native/socle/commit/74ebc12f559cf64eb3383daf31fd9a43edc329eb))

## [3.3.1](https://github.com/cloud-pi-native/socle/compare/v3.3.0...v3.3.1) (2025-02-20)


### Bug Fixes

* :bug: Keycloak set kc_access_token ([36b0460](https://github.com/cloud-pi-native/socle/commit/36b0460b8ca43b116d64127a1f2937f2a520c1b1))

## [3.3.0](https://github.com/cloud-pi-native/socle/compare/v3.2.2...v3.3.0) (2025-02-20)


### Features

* :arrow_up: upgrade console chart to v2 ([d6384c2](https://github.com/cloud-pi-native/socle/commit/d6384c2305fa173306c53823f3bf8e01f6b9a5ce))
* :sparkles: add wal parallelism when restoring cnpg db ([5c17325](https://github.com/cloud-pi-native/socle/commit/5c17325195f15a7769e32393571a4e0fdd29e0fc))
* :zap: improve gitaly availability ([f320927](https://github.com/cloud-pi-native/socle/commit/f320927a089d0cfb132b3dd89e9ab4a7318bbbe3))


### Bug Fixes

* :bug: ignore proxy in kaniko args if not in dsc ([63b929f](https://github.com/cloud-pi-native/socle/commit/63b929f90d9fcaf167f890ac0ed8df8a4a132879))
* :bug: Reset Keycloak admin fact and API token ([3137c69](https://github.com/cloud-pi-native/socle/commit/3137c69b0cfc4e2fed1d127be5371fbf7610a2b0))
* :bug: Set Keycloak permanent admin user ([bddceeb](https://github.com/cloud-pi-native/socle/commit/bddceeb79528e27bf0e7442d237cdd73c6f0d91e))
* :wrench: platform security context ([5fc5921](https://github.com/cloud-pi-native/socle/commit/5fc592143e77ebe5c66afc7f69fdf39d3edde98b))


### Performance Improvements

* :art: Add when condition ([6209903](https://github.com/cloud-pi-native/socle/commit/62099031fe41fd5d71fb4a73e0bf8f289b3fc95d))

## [3.2.2](https://github.com/cloud-pi-native/socle/compare/v3.2.1...v3.2.2) (2025-02-07)


### Bug Fixes

* :bug: add proxycache into gitlab-ci kaniko args ([a270f68](https://github.com/cloud-pi-native/socle/commit/a270f687196052a92dd2dac2664ceddb08fa606b))
* :bug: Install Kyverno task ([9deeb17](https://github.com/cloud-pi-native/socle/commit/9deeb17f01521f5e37f00ca96098a5f36cb9a0b1))
* :bug: update argo-cd default admin group ([716828b](https://github.com/cloud-pi-native/socle/commit/716828b7efca71c1db94ff6fe9d67397fa3bd566))
* :bug: when two or more argocd installed argocd need labelKey ([c7bd96a](https://github.com/cloud-pi-native/socle/commit/c7bd96ab6aaa24e0ee59146c081b57952e9aae9d))

## [3.2.1](https://github.com/cloud-pi-native/socle/compare/v3.2.0...v3.2.1) (2025-02-04)


### Bug Fixes

* :bug: Fix Harbor ingress values ([d4dc82d](https://github.com/cloud-pi-native/socle/commit/d4dc82de3fecb0be75b61875d0c15b0b03f23fde))


### Performance Improvements

* :zap: improve argo-cd resource exclusions ([59010df](https://github.com/cloud-pi-native/socle/commit/59010df7673dc4521a9bd10c6cb3c63d94f78eb1))

## [3.2.0](https://github.com/cloud-pi-native/socle/compare/v3.1.0...v3.2.0) (2025-01-27)


### Features

* :sparkles: Upgrading GitLab to v17.8.1 ([cef49de](https://github.com/cloud-pi-native/socle/commit/cef49de47bfbec88d50f9766b3d75a57c669219f))


### Bug Fixes

* :bug: add missing keycloak default client scope ([ae50ee2](https://github.com/cloud-pi-native/socle/commit/ae50ee2c5f5fa5e35788752b6f8d42c0de63d795))

## [3.1.0](https://github.com/cloud-pi-native/socle/compare/v3.0.0...v3.1.0) (2025-01-13)


### Features

* :arrow_up: upgrade keycloak dsfr theme to v2.1.4 ([ace8896](https://github.com/cloud-pi-native/socle/commit/ace88966d2a9960a1ed6fd073358e68420b0147b))
* :arrow_up: upgrade sonarqube to v10.8.1 ([a4acb05](https://github.com/cloud-pi-native/socle/commit/a4acb050294a78e932b84cdd4983e0764e08761e))


### Bug Fixes

* :bug: correctly handle branch protection on catalog ([044ec00](https://github.com/cloud-pi-native/socle/commit/044ec00a6fa5373f7c7fb4c4abe58f8d56117ab9))
* :bug: correctly handle console installation ([a7c0983](https://github.com/cloud-pi-native/socle/commit/a7c098332ae5b4b86e1c6d75003bc4904c7def26))

## [3.0.0](https://github.com/cloud-pi-native/socle/compare/v2.14.0...v3.0.0) (2025-01-09)


### ⚠ BREAKING CHANGES

* :boom: Upgrade Nexus version to 3.76.0

### Features

* :boom: Upgrade Nexus version to 3.76.0 ([db44dfd](https://github.com/cloud-pi-native/socle/commit/db44dfda0f5c5cd54169cf4921ce364603d1b4e8))


### Bug Fixes

* :bug: Add first install check to prevent failures on upgrades ([e1cc7b3](https://github.com/cloud-pi-native/socle/commit/e1cc7b30ba249bb12fe1017aecf9fad457095b25))


## [2.14.0](https://github.com/cloud-pi-native/socle/compare/v2.13.0...v2.14.0) (2024-12-10)


### Features

* :arrow_up: upgrade argo-cd to v2.13.1 ([975db7d](https://github.com/cloud-pi-native/socle/commit/975db7d97322fa7d38692b5a60d169d3c33edb49))
* :arrow_up: upgrade harbor to v2.12.0 ([35d9487](https://github.com/cloud-pi-native/socle/commit/35d94872737615841a9f5ccf1004e2de0e851856))
* :arrow_up: upgrade sonarqube to v10.7.0 ([466f60c](https://github.com/cloud-pi-native/socle/commit/466f60c20ef70877b2b4943ddafd013a68f038f9))

## [2.13.0](https://github.com/cloud-pi-native/socle/compare/v2.12.4...v2.13.0) (2024-12-10)


### Features

* :arrow_up: upgrade keycloak to v26.0.5 ([2c1401e](https://github.com/cloud-pi-native/socle/commit/2c1401efdbf9f3424310bc637c94bbf9057b7236))
* :arrow_up: Upgrade Vault version from 1.14.0 to 1.18.1 ([a2bb7c0](https://github.com/cloud-pi-native/socle/commit/a2bb7c082672d6421e9bba33111d4fb0dd9d3ac9))
* :sparkles: add sonar cnes report allowing exports ([8021d91](https://github.com/cloud-pi-native/socle/commit/8021d91b6c7d6676f50165bfb385add55035fe4c))
* :sparkles: handle CNPG cluster images override ([a28088e](https://github.com/cloud-pi-native/socle/commit/a28088efd7f4b1f4ba7f6ea3eeec10148613bcb0))


### Bug Fixes

* :art: Add missing Argo CD ingressClassName ([bc39fe0](https://github.com/cloud-pi-native/socle/commit/bc39fe0e768c480e92483ffdc313367dfeada16f))
* :bug: correctly handle imageName variable ([db04671](https://github.com/cloud-pi-native/socle/commit/db04671d8819bf5ee2b17c6cd813e2d0c8b6c3ea))
* :bug: Fix some alert rules (missing namespace label) ([6a91a7f](https://github.com/cloud-pi-native/socle/commit/6a91a7fc0f768aeb800924044c33b8a576317768))
* :pencil2: ansible-lint ([5278669](https://github.com/cloud-pi-native/socle/commit/527866962aa6cfac688806ca4088a9ce8fedd546))
* :pencil2: grammar, description's 76 char width and full stop, fix urls, remove ref to bitnami for argocd & sonarqube ([f57aceb](https://github.com/cloud-pi-native/socle/commit/f57aceb8ecb36a10bf602fc121a98c418dfa6758))
* :pencil2: https links ([80412d6](https://github.com/cloud-pi-native/socle/commit/80412d6328325e7425da78a820c24562fbd15634))
* :pencil2: typos, grammar, double/end-of-line spaces ([fa8fecb](https://github.com/cloud-pi-native/socle/commit/fa8fecbadb1db692fa8bec66dc9131ff862162bc))
* :rotating_light: eslint ([16492de](https://github.com/cloud-pi-native/socle/commit/16492de973f50d488f4975ccc9f4f5144e7541d5))


### Reverts

* :rewind: CHANGELOG.md ([7483100](https://github.com/cloud-pi-native/socle/commit/7483100310ac8959b677df0cae6270d3cbbd543a))

## [2.12.4](https://github.com/cloud-pi-native/socle/compare/v2.12.3...v2.12.4) (2024-10-28)


### Bug Fixes

* :recycle: improve customization for ingress annotations ([d15fc30](https://github.com/cloud-pi-native/socle/commit/d15fc30596ebc661ba90c0576340884985b572fb))

## [2.12.3](https://github.com/cloud-pi-native/socle/compare/v2.12.2...v2.12.3) (2024-10-22)


### Bug Fixes

* :bug: add default values for nexus and gitlab-ci-pipelines-exporter ([58895d5](https://github.com/cloud-pi-native/socle/commit/58895d510aea666c0ede255f9cf4029d6e48f3dd))

## [2.12.2](https://github.com/cloud-pi-native/socle/compare/v2.12.1...v2.12.2) (2024-10-21)


### Bug Fixes

* :bug: configure nexus docker proxy only if enabled in dsc ([f7546cf](https://github.com/cloud-pi-native/socle/commit/f7546cf2de6f01d2950d69f1998f4f57746194bb))
* :bug: handle proxies for gitlab-ci-pipeline-exporter ([63e66b1](https://github.com/cloud-pi-native/socle/commit/63e66b13cfe94da9e12bc04001bb13a3b44db190))

## [2.12.1](https://github.com/cloud-pi-native/socle/compare/v2.12.0...v2.12.1) (2024-10-18)


### Bug Fixes

* :bug: always b64 encode exposed_ca_pem because it is decoded ([2237f93](https://github.com/cloud-pi-native/socle/commit/2237f9395d33c78513a2c2bde5eb6e6f96ef9e9b))

## [2.12.0](https://github.com/cloud-pi-native/socle/compare/v2.11.2...v2.12.0) (2024-10-18)


### Features

* :sparkles: Add gitops observability ([bbe43f6](https://github.com/cloud-pi-native/socle/commit/bbe43f6bd916c28dffe3a5ca86cb657d9b29d7c6))
* :sparkles: Improve PVC alerting ([2ada7d7](https://github.com/cloud-pi-native/socle/commit/2ada7d741c0a4ad7066ab6c9b11bd06aee8cc44b))


### Bug Fixes

* :bug: argocd controller needs proxy envVar ([c6c2a65](https://github.com/cloud-pi-native/socle/commit/c6c2a65326e963be654d13123517946e749edb50))
* :bug: handle minio cli extra args from dsc ([d89f278](https://github.com/cloud-pi-native/socle/commit/d89f2780e15334e058876b86a9227184b581d76f))

## [2.11.2](https://github.com/cloud-pi-native/socle/compare/v2.11.1...v2.11.2) (2024-10-16)


### Bug Fixes

* :bug: fix compression on cnpg clusters ([5998632](https://github.com/cloud-pi-native/socle/commit/59986327ae1646b563ea3a4f0d9f749675c15316))

## [2.11.1](https://github.com/cloud-pi-native/socle/compare/v2.11.0...v2.11.1) (2024-10-16)


### Bug Fixes

* :lock: Upgrade GitLab due to CVE-2024-9164 ([25dfeff](https://github.com/cloud-pi-native/socle/commit/25dfeff420e00f17105ab5229cc8b37c984509df))

## [2.11.0](https://github.com/cloud-pi-native/socle/compare/v2.10.1...v2.11.0) (2024-10-14)


### Features

* :zap: Add postgresWalMaxSlotKeepSize parameter ([780834a](https://github.com/cloud-pi-native/socle/commit/780834a229d5c04bfde69d9f149f8a1a4a810aaa))


### Bug Fixes

* :bug: disable cnpg backup on restore mode ([96d13c0](https://github.com/cloud-pi-native/socle/commit/96d13c06c630734f35930b93cef7111fe3bf6756))
* :bug: fix argocd install with proxy ([ba8d833](https://github.com/cloud-pi-native/socle/commit/ba8d83349b932103ed42b9c883f991879c9b8c09))

## [2.10.1](https://github.com/cloud-pi-native/socle/compare/v2.10.0...v2.10.1) (2024-10-04)


### Bug Fixes

* :bug: backup system using ansible and dsc ([d8dd0a6](https://github.com/cloud-pi-native/socle/commit/d8dd0a6fb48b5a091566ae8abca3f5452b37026e))

## [2.10.0](https://github.com/cloud-pi-native/socle/compare/v2.9.0...v2.10.0) (2024-10-02)


### Features

* :sparkles: handle cnpg compression and dedicated wal pvc ([25436b5](https://github.com/cloud-pi-native/socle/commit/25436b5ecd4f7428b3f2b59b973fa1b6d8375d4f))


### Bug Fixes

* :bug: correctly handle certs on vault oidc config ([f476694](https://github.com/cloud-pi-native/socle/commit/f476694782c869aa74cf26f4c510b83ea69de7f4))
* :bug: Fix certmanager install failure when values are empty ([b2ee1be](https://github.com/cloud-pi-native/socle/commit/b2ee1bee76d2e85362db3b8a6d1f489b83cb9192))
* :bug: postgresWalPvcSize definition check ([168ff03](https://github.com/cloud-pi-native/socle/commit/168ff03f94afc9aeff682365408fdbb9e42b1fbf))
* :wrench: add default dictionary values for certmanager ([5f5d5a0](https://github.com/cloud-pi-native/socle/commit/5f5d5a07bbb26150fa573fad255b41358fe2bc92))
* :wrench: add kube-apiserver clusterIP in no_proxy ([2f072ec](https://github.com/cloud-pi-native/socle/commit/2f072ec6b95c57b242715e5f6a0d80363dab4433))

## [2.9.0](https://github.com/cloud-pi-native/socle/compare/v2.8.0...v2.9.0) (2024-09-24)


### Features

* :arrow_up: Upgrade GitLab Operator and GitLab instance ([c538677](https://github.com/cloud-pi-native/socle/commit/c538677d45d207cefeb6f7e7c39d4cfc91735ee4))


### Bug Fixes

* :wrench: add .conf-dso-vault-internal in no_proxy ([61e1423](https://github.com/cloud-pi-native/socle/commit/61e14236a123bbc56104d6555cfa15a78f89f3cb))

## [2.8.0](https://github.com/cloud-pi-native/socle/compare/v2.7.0...v2.8.0) (2024-09-13)


### Features

* :sparkles: Add alert rules + fix some alert names ([cf43e63](https://github.com/cloud-pi-native/socle/commit/cf43e6350b2cf2cd231f616fe4eee8ec2c5af604))
* :sparkles: Add alerting rule ([e4b819f](https://github.com/cloud-pi-native/socle/commit/e4b819f4c8d143eb8fd191a3868163dec5508683))
* :sparkles: Add alerts for critical events and PVCs ([e0653fb](https://github.com/cloud-pi-native/socle/commit/e0653fb00030a3d1c31f0ec155519f0f4aba2b9b))
* :sparkles: Add alerts for sealed Vault + refactor ([11c005e](https://github.com/cloud-pi-native/socle/commit/11c005e4289f08b84e71a8af9eafbb2611b58ea0))
* :sparkles: Add and adapt alerting rules ([083c9eb](https://github.com/cloud-pi-native/socle/commit/083c9ebd325dbba52347da9b32766d90b4a6cecb))
* :sparkles: Add Cert-manager alerting rule ([ee335a2](https://github.com/cloud-pi-native/socle/commit/ee335a233f45a397c6e79dec841739472a078f29))
* :sparkles: Add CNPG Operator alerting rule ([aafc4fd](https://github.com/cloud-pi-native/socle/commit/aafc4fd56b76212d2cabeb5072b87a47b1c5de3c))
* :sparkles: Add controller alerting rules + fix redis metrics ([0bdf461](https://github.com/cloud-pi-native/socle/commit/0bdf4610f5d43c7d214dc5a78dc73e8bb0c343b2))
* :sparkles: Add database containes alerting rule ([bb99b3e](https://github.com/cloud-pi-native/socle/commit/bb99b3e1cbd9adfecaf8158c23bc33943bbf25c3))
* :sparkles: add dsc.global.profile: cis ([e1f6622](https://github.com/cloud-pi-native/socle/commit/e1f662216c7495200124c7ec7f29f9ddc73d55c5))
* :sparkles: Add DSO Console alerting ([8992444](https://github.com/cloud-pi-native/socle/commit/89924441f733638815d982a6ef69e2eefc1ceb4e))
* :sparkles: Add GitLab Operator alerting rules ([37521a8](https://github.com/cloud-pi-native/socle/commit/37521a8bc87efcbd05c3f4d8dd16e3d0261efd68))
* :sparkles: Add Harbor alerting rules ([8bc687b](https://github.com/cloud-pi-native/socle/commit/8bc687bae41486b2eb08e11407c9e79d171fdd8a))
* :sparkles: Add Kyverno alerting rules + new crd parameter ([5634d9f](https://github.com/cloud-pi-native/socle/commit/5634d9f97a97a5e9d0eac0e8a126c80e465d3714))
* :sparkles: add pluginDownloadUrl for Keycloak ([79c92f9](https://github.com/cloud-pi-native/socle/commit/79c92f93bd8670952cc294e3db95a06f44e47c2b))
* :sparkles: Add summary to alert rule ([2c7e366](https://github.com/cloud-pi-native/socle/commit/2c7e366f045e92455bc7e07ba2cf8dbe1d956c07))
* :sparkles: Adding Nexus alerting rules ([740dac8](https://github.com/cloud-pi-native/socle/commit/740dac84fe739c05af317eab2f8e3d95628ff8cb))
* :sparkles: Adding SonarQube alerting rules ([c1a4558](https://github.com/cloud-pi-native/socle/commit/c1a455879ff8bcab335f83af35bec75cec468887))
* :sparkles: Change value format on PVC alerting message ([8f7a2e1](https://github.com/cloud-pi-native/socle/commit/8f7a2e13d7090d8e5d98140b595a8636b60cfe68))
* :sparkles: enable argocd applicationset ingress ([ba50e45](https://github.com/cloud-pi-native/socle/commit/ba50e45274885df21bad77575ee01fa3626a63cb))
* :sparkles: Finalizing auto upgrade feature ([593454e](https://github.com/cloud-pi-native/socle/commit/593454e1a02b0f97b9b2dcd07cd90a25a410fd26))
* :sparkles: GitLab webservice alerting rules ([ba294b2](https://github.com/cloud-pi-native/socle/commit/ba294b20ede2e4b7efe8420dfdfb5c4f7e12e423))
* :sparkles: handle cnpg replication and add exposure option ([ddae834](https://github.com/cloud-pi-native/socle/commit/ddae834117394970dd21c21cd5cd877c00bdda4b))
* :sparkles: handle cnpg restore mode ([aa60d15](https://github.com/cloud-pi-native/socle/commit/aa60d15803cbdce606ceb61a7322af5ead2245e4))
* :sparkles: handle global image pull secret ([6d71f5e](https://github.com/cloud-pi-native/socle/commit/6d71f5e1561a247bb48260a223515d14784a79bf))
* :sparkles: handle vault backups ([31cc428](https://github.com/cloud-pi-native/socle/commit/31cc428b62dc665aebf455c4d063d8b414ed45f4))
* :sparkles: Introducing Manage Sonarqube upgrade when needed ([fa79512](https://github.com/cloud-pi-native/socle/commit/fa795123ee6bc5925cd86bada891092f04266c87))
* :sparkles: Keycloak DB PVC alerting + alerts renaming ([8b05f90](https://github.com/cloud-pi-native/socle/commit/8b05f90de7ed7a196ff1d49326562ed03859027f))
* :sparkles: Set alerting default config + enable Keycloak prometheusRule ([5174005](https://github.com/cloud-pi-native/socle/commit/5174005f2ab910b21e40ea1a3b0205eef08086de))
* :sparkles: Vault alerting rules. ([968324c](https://github.com/cloud-pi-native/socle/commit/968324c2e0227336ae1a6b03443598668e79b3f3))
* :wrench: Add overwrite limit for gitlab runner ([d210f0a](https://github.com/cloud-pi-native/socle/commit/d210f0a54a64fa14af11126b63797156e9c815fc))
* :wrench: enable approle authentication on vault ([69ae8bb](https://github.com/cloud-pi-native/socle/commit/69ae8bbe81b13d6b027575e09abdf844ccf0acc7))
* :zap: use cnpg cluster for gitlab ([e5fdd12](https://github.com/cloud-pi-native/socle/commit/e5fdd12b6d0b923775ed04d6180873ec9d8be3d6))
* ✨ add helm repo url ([#279](https://github.com/cloud-pi-native/socle/issues/279)) ([bd15c97](https://github.com/cloud-pi-native/socle/commit/bd15c973ee62b7aafe1bd2bf9b670ea1fff39730))
* upgrade sonarqube to v10.6.1 ([1f31f98](https://github.com/cloud-pi-native/socle/commit/1f31f988407fc009e254e242e378cbbb1941429b))


### Bug Fixes

* :ambulance: Fix use_image_pull_secret fact definition ([7137beb](https://github.com/cloud-pi-native/socle/commit/7137beb187a23d3a05bf51c319ca6d1458249460))
* :art: Change alert severity level ([96509fe](https://github.com/cloud-pi-native/socle/commit/96509fe5c4134d5347452ea58c9f606ed32d1848))
* :art: Fix alerting message ([b33b501](https://github.com/cloud-pi-native/socle/commit/b33b501f75970de1ba8eedeea56b96aae817906b))
* :art: Fix Argo CD dashboard to prevent deprecation ([5210ad9](https://github.com/cloud-pi-native/socle/commit/5210ad93ac9b184959d2c53c44bac3b70553f532))
* :art: Fix Gitaly dashboard to prevent deprecation ([1d64fbb](https://github.com/cloud-pi-native/socle/commit/1d64fbb66322d730dccb4759c5d7093a732463a8))
* :art: Fix GitLab CI Pipelines dashboard to prevent deprecation ([e94d142](https://github.com/cloud-pi-native/socle/commit/e94d14255f9baebf0dc8d045df9bb6654cae10b2))
* :art: Fix Keycloak dashboard to prevent deprecation ([f5d12c9](https://github.com/cloud-pi-native/socle/commit/f5d12c9ed9dd9ef5418cbf1330f5aede84d23d38))
* :art: Fix Nexus dashboard to prevent deprecation ([d6b1620](https://github.com/cloud-pi-native/socle/commit/d6b16208664521d24695f902e9924a079d31dbcd))
* :art: Fix Vault dashboard to prevent deprecation ([bf19a80](https://github.com/cloud-pi-native/socle/commit/bf19a8042637161e8e2e308398a38fefc2c7013e))
* :art: Remove Vault dashboard unnecessary panel ([8eff4cf](https://github.com/cloud-pi-native/socle/commit/8eff4cf27d71309b45c506681ed980762b885fd1))
* :art: Set alert time ([234888a](https://github.com/cloud-pi-native/socle/commit/234888abbc683101250c506ee3cdbb2b18d11c52))
* :art: Update condition for alert deployment ([369244f](https://github.com/cloud-pi-native/socle/commit/369244f80db70bda55fa13c9989c4f643fb8f261))
* :bug: Adapt Argo crb task for haproxy SA ([742ea3a](https://github.com/cloud-pi-native/socle/commit/742ea3a0f4d727f992793d274ecccb6218895baf))
* :bug: Adapt PVCs alerting rules ([9850f6a](https://github.com/cloud-pi-native/socle/commit/9850f6af1e2d888d11d33801e7afa806493e7d07))
* :bug: Add missing requirement (jmespath) ([e7d03cd](https://github.com/cloud-pi-native/socle/commit/e7d03cd0cc8ffcfc3f6d8098f10e715fc3092e94))
* :bug: Adjust time before alerts triggering ([e2d5a6c](https://github.com/cloud-pi-native/socle/commit/e2d5a6c1402816abfbbf81aacb27108019745e35))
* :bug: dispatch ingress requests to vault active node ([b3e43e6](https://github.com/cloud-pi-native/socle/commit/b3e43e6b3771752caba30528f84b4e93ccbcaa80))
* :bug: Fix "Vault Pod not healthy" alert rule. ([715030d](https://github.com/cloud-pi-native/socle/commit/715030df84acbbad5eccb13942e6e3cad6fec87e))
* :bug: Fix Argo CD dashboard ([6fe788d](https://github.com/cloud-pi-native/socle/commit/6fe788d76fc70a2cc5816fbb9f03e6d5718fc9ae))
* :bug: Fix Argo CD dashboard refs ([4219f01](https://github.com/cloud-pi-native/socle/commit/4219f0101d632d77a89f0a3e8f6912c7ab7b5400))
* :bug: Fix Argo CD Helm repo URL ([ed50f06](https://github.com/cloud-pi-native/socle/commit/ed50f06c0b46db9e0d0ff8d09fca44403453bfb8))
* :bug: Fix Argo CD naming + uninstall ([12d821b](https://github.com/cloud-pi-native/socle/commit/12d821b4c1ba5b356ecfba8bfa5432f92e926a5e))
* :bug: Fix default CNPG config ([27df125](https://github.com/cloud-pi-native/socle/commit/27df1254ab967f029fed92f3fd08dec488b5cfdc))
* :bug: Fix get-versions admin playbook ([afd3dd0](https://github.com/cloud-pi-native/socle/commit/afd3dd096e67f8ac53ab67a110a7a6685e95860e))
* :bug: Fix get-versions for cert-manager, CNPG Operator and Grafana Operator ([f580b2e](https://github.com/cloud-pi-native/socle/commit/f580b2e87e952cdb025ddca6a9da31c5b28f9261))
* :bug: Fix grafana template blocs order ([26caac2](https://github.com/cloud-pi-native/socle/commit/26caac2ce202c24b6729faa0799d69c521c94d80))
* :bug: Fix Harbor prometheusrule (name + time) ([4d97dfd](https://github.com/cloud-pi-native/socle/commit/4d97dfd9c30ed48bed10d857a13837ad0d1dee80))
* :bug: Fix missing cnpg default configs ([c05c1a0](https://github.com/cloud-pi-native/socle/commit/c05c1a0ed690d1fdcadb3f75850124b6b81de26a))
* :bug: Fix some alerts duration ([42c07b5](https://github.com/cloud-pi-native/socle/commit/42c07b51a20ea44287f2788a6a998f5b00229304))
* :bug: Fix some Keycloak alerting rules ([bfe0c61](https://github.com/cloud-pi-native/socle/commit/bfe0c61ba483783ca3364a3f19c9a25746feae3b))
* :bug: Fix typo + missing type in CRD ([2201d51](https://github.com/cloud-pi-native/socle/commit/2201d517b09787992987e355b1d00cb5c8395558))
* :bug: Fix Vault backup utils deployment tasks ([3969433](https://github.com/cloud-pi-native/socle/commit/39694338717cac42bd5e4533d9875ddb6743dccc))
* :bug: Get back global.alerting spec in CRD ([2f6c48e](https://github.com/cloud-pi-native/socle/commit/2f6c48ee3397538a38de85d2439209e6146f7d9b))
* :bug: Namespace name in alert message ([9306395](https://github.com/cloud-pi-native/socle/commit/93063956c3489140f6177b14d5d80ac46063e134))
* :bug: Remove legacy GitLab postgresql ServiceMonitor ([961a221](https://github.com/cloud-pi-native/socle/commit/961a221cc34a6755cd4740bd2e218b1231e7e9b5))
* :memo: Fix Argo CD chart refs ([e807345](https://github.com/cloud-pi-native/socle/commit/e807345bf7c789b400f5c993f06945d39fc88c14))
* :memo: Fix Argo CD chart refs + README ([f09cd81](https://github.com/cloud-pi-native/socle/commit/f09cd81c970a2ef257d9b6235eeda34aa0547857))
* :rotating_light: Obvious lint is obvious ([842894b](https://github.com/cloud-pi-native/socle/commit/842894bc1d69ead15b2220b56586655b4153e27f))
* :wrench: argocd ca yaml indent ([80fd035](https://github.com/cloud-pi-native/socle/commit/80fd035f73fc0de3108db09533f32e897dc118fc))
* :wrench: enable the use of proxy for grafana pod ([98f7cc0](https://github.com/cloud-pi-native/socle/commit/98f7cc029616bce2db281d69426e4b2319ca3a84))
* :wrench: enforce gitlab root user email ([2c0515d](https://github.com/cloud-pi-native/socle/commit/2c0515d709456c676fc81446da9ce75a234a20e2))
* :wrench: PascaleCase to camelCase ([45ae3fa](https://github.com/cloud-pi-native/socle/commit/45ae3fa481fdd53ee32cfc3a9a51f824f648c58d))
* :wrench: remove post renderer ([26da2ce](https://github.com/cloud-pi-native/socle/commit/26da2ce698c1a186891cf96a92612e0d2082bc35))
* :wrench: sonarqube db owner ([a494398](https://github.com/cloud-pi-native/socle/commit/a4943985d8615d865dcc86866c87c30da9516b41))


### Performance Improvements

* :zap: Adjusting alert rule ([6745254](https://github.com/cloud-pi-native/socle/commit/67452547cbb836bc4455bfce1abfbf742e3ca42b))
* :zap: One Pod alert to rule them all. ([743d549](https://github.com/cloud-pi-native/socle/commit/743d549e3407c5882897077a24220d059165aa4a))

## [2.7.0](https://github.com/cloud-pi-native/socle/compare/v2.6.0...v2.7.0) (2024-07-09)


### Features

* :sparkles: add dsc.global.offline ([87e6bd6](https://github.com/cloud-pi-native/socle/commit/87e6bd6c1a79cbbeb9113919f7cb73c16736fb0d))
* :sparkles: add dsc.global.platform: rke2 ([48403de](https://github.com/cloud-pi-native/socle/commit/48403de21de0e41a52fef90b0383a0870810942e))
* :sparkles: add proxy cache for Harbor ([77d3207](https://github.com/cloud-pi-native/socle/commit/77d3207691102ac80261fef22f18ea9e2812a8d1))
* :sparkles: Introducing get-versions playbook ([6c0893e](https://github.com/cloud-pi-native/socle/commit/6c0893e99c60d29bacbbf3283cc3902dbc7fabf6))


### Bug Fixes

* :ambulance: add vault jwt auth config ([39d226c](https://github.com/cloud-pi-native/socle/commit/39d226c5a883d9032b04b75fb7cce887da923582))
* :art: Indentation ([0b02c4d](https://github.com/cloud-pi-native/socle/commit/0b02c4df080e530cf3658f45662f8c0306b503a9))
* :bug: Add always tag to cert-manager role ([71e1b3f](https://github.com/cloud-pi-native/socle/commit/71e1b3f45f1795c55e526c49ffc35ee87de7b8a0))
* :bug: Fix placeholder file check ([c71d1e0](https://github.com/cloud-pi-native/socle/commit/c71d1e0b68186f3a4fbf558e46028726d9e04cd2))
* :bug: Fix ServiceMonitor and standalone config ([2b19515](https://github.com/cloud-pi-native/socle/commit/2b1951504eb72db90cdc946a4180ab3210d5ba01))
* :bug: Fix variable name ([0b351f2](https://github.com/cloud-pi-native/socle/commit/0b351f26cb69e629c74517da431e21a44fcfae7f))
* :bug: Fix Vault post-install ([ab06d38](https://github.com/cloud-pi-native/socle/commit/ab06d3889263843d94a5255aa2a569e8269fa3cc))
* :bug: gitlab ci catalog sync ([3421aa9](https://github.com/cloud-pi-native/socle/commit/3421aa9b4af932c3f5043fd4b12f1cd15f90bdef))
* :bug: Set default repo URL + sync.yaml filename ([6c3abde](https://github.com/cloud-pi-native/socle/commit/6c3abde54d964295e64d1ce2e2768caa4c2e7f2c))
* :bug: Vault admin group ([5ff2b52](https://github.com/cloud-pi-native/socle/commit/5ff2b522b1f0a99c38065766c96f3bcd34ed4dda))
* :pencil2: Fix typos ([b15e9d2](https://github.com/cloud-pi-native/socle/commit/b15e9d2ade4c15a640084a17a2bf902d520a854f))
* :wrench: block logic for first console deployment ([068376d](https://github.com/cloud-pi-native/socle/commit/068376dbab6e92364416bf5a79f1c57be9a2aafd))
* :wrench: populate VAULT_TOKEN in dso-config ([e9dad90](https://github.com/cloud-pi-native/socle/commit/e9dad90e5f1271fe6a0b9d9093cc2571d21f9257))
* :wrench: remove force true ([9a2eda6](https://github.com/cloud-pi-native/socle/commit/9a2eda65de245d769546c8f2c732c2cf2c59bfc5))
* 🐛 Fix first install for dso-console ([8ffe6a5](https://github.com/cloud-pi-native/socle/commit/8ffe6a5618ff0a15eb1b48bf44be3f87716ac2d7))

## [2.6.0](https://github.com/cloud-pi-native/socle/compare/v2.5.0...v2.6.0) (2024-06-14)


### Features

* :sparkles: add dsc.global.platform (Vanilla) ([682512f](https://github.com/cloud-pi-native/socle/commit/682512f3af1f97e58d4b9f376884857b89425b5c))
* :sparkles: Add gitlab-ci-pipelines-exporter ([9c47614](https://github.com/cloud-pi-native/socle/commit/9c476141cfe62aa4570bc8daa01076be866fbd61))
* :sparkles: Add keycloak binding, dashboards + refactor ([f447b31](https://github.com/cloud-pi-native/socle/commit/f447b31d39a0b93f157ff57c81511b7890098047))
* :sparkles: Add Keycloak CNPG PodMonitor ([f582691](https://github.com/cloud-pi-native/socle/commit/f582691871396065ec19f4b51f217dc95f24a3ac))
* :sparkles: Add PodMonitor for remaining CNPG clusters ([d8ba40f](https://github.com/cloud-pi-native/socle/commit/d8ba40f8fd7a7af98cc617ff07cbebeef86afae1))
* :sparkles: Declare CNPG Dashboard ([76350c2](https://github.com/cloud-pi-native/socle/commit/76350c23e125e437fd0a45d8f3a69372196b7ce8))
* :sparkles: enable keycloak dsfr theme ([445b819](https://github.com/cloud-pi-native/socle/commit/445b819ad1be5addc93e1e961a471048f2cba3ef))
* :sparkles: Reset Keycloak admin when keycloak secret disapeared ([42bd6cc](https://github.com/cloud-pi-native/socle/commit/42bd6cce27d0821c9e47c735193a4d66ee191b46))
* :sparkles: Set OTP encryption algorithm ([da9c416](https://github.com/cloud-pi-native/socle/commit/da9c416738b906ea556befe3a6b410dc480eb117))
* :sparkles: use cnpg clusters for all services ([400f429](https://github.com/cloud-pi-native/socle/commit/400f429a82a260bca193a1423942988e39b599bf))
* :sparkles: use console chart instead of embed helm in console repo ([64620a2](https://github.com/cloud-pi-native/socle/commit/64620a2d5012e4cb31ab334b47a5286c63a2dd07))
* :technologist: enable oidc connection for admins ([df339a9](https://github.com/cloud-pi-native/socle/commit/df339a9018da3e394cad426c43f73e4994fb5426))
* :zap: Improve Grafana stack install and uninstall ([406c202](https://github.com/cloud-pi-native/socle/commit/406c202bcd6bbbddf406a3a59c5f1dc0b66f4d89))
* :zap: We might need allowCrossNamespaceImport ([ece35a0](https://github.com/cloud-pi-native/socle/commit/ece35a022fb43bbd5baa4dbfe188543fd1bc393e))

:warning: This new version includes several migrations described in the following sections :warning:

#### Databases

Harbor and Console databases have been migrated to CNPG clusters, to perform the migration, follow the steps bellow :

1. Scale down deployments
2. Backup database
3. Deploy CNPG cluster
4. Restore database
5. Scale up deployments

To change Harbor database permission from the old user `registry` to the new one `harbor`, connect to the primary instance of the fresh CNPG cluster and run the following command :

```sh
for tbl in `psql -U postgres -qAt -c "select tablename from pg_tables where schemaname = 'public';" registry`; do
  psql -U postgres -c "alter table \"$tbl\" owner to harbor" registry
done

for tbl in `psql -U postgres -qAt -c "select sequence_name from information_schema.sequences where sequence_schema = 'public';" registry`; do  
  psql -U postgres -c "alter sequence \"$tbl\" owner to harbor" registry
done

for tbl in `psql  -U postgres -qAt -c "select table_name from information_schema.views where table_schema = 'public';" registry`; do  
  psql -U postgres -c "alter view \"$tbl\" owner to harbor" registry
done
```

For more informations, see. https://stackoverflow.com/questions/1348126/postgresql-modify-owner-on-all-tables-simultaneously-in-postgresql

#### Vault

The vault server is now running in HA, which involves migrating to the raft storage backend by following the steps below :

1. Retrieve the credentials for our standalone Vault instance, e.g. :
    ```bash
    ansible-playbook admin-tools/get-credentials.yaml -t vault
    ```

2. Connect to Vault and create a test secret if necessary, or check the secrets already present.

3. Launch Vault HA installation via Vault's Ansible role :
    ```bash
    ansible-playbook install.yaml -t vault
    ```

    The installation will create two new pods which will act as standby instances, but **it will fail to add them to the raft cluster**. This is normal, as the active instance does not yet have raft storage.

4. Open a shell in the vault container on the active Vault pod (vault-0), example in the context of a Vault configured via the conf-dso dsc :
    ```bash
    kubectl -n dso-vault exec -it -c vault conf-dso-vault-0 -- sh
    ```

    The `vi` command is available in the pod. Use it to create a migration configuration file in the `/home/vault` directory, which is writable :
    ```bash
    vi /home/vault/migrate.hcl
    ```

    With the following contents:
    ```bash
    storage_source "file" {
      path = "/vault/data
    }

    storage_destination "raft" {
      path = "/vault/data"
    }

    cluster_addr = "http://127.0.0.1:8201"
    ```

    Then run the following migration command:
    ```bash
    vault operator migrate -config /home/vault/migrate.hcl
    ```

    This will perform the migration and create a `/vault/data/raft` directory.

    Its last line should return the following output :
    ```bash
    Success! All of the keys have been migrated.
    ```

5. Delete the vault-0 pod so that it seals itself and wait for it to restart (state `0/1 Running`).

6. Restart the HA installation, which should now run to completion, and unseal the 3 Vault instances :
    ```bash
    ansible-playbook install.yaml -t vault
    ```

    The three vault pods are then set to READY (1/1) and we are now in **HA** mode.

__Check that the migration is done and healthy :__
- Connect to Vault and make sure our secrets are present.
- Open a shell on each pod and run the `vault status` command. It should tell us :
  - Storage Type" is raft.
  - HA enabled" is set to true.
  - The "HA Mode" of our node (active or standby).
  - The same value between each pod in the last two lines (Index). The value may vary slightly over time between pods, but must not drift too much, otherwise it indicates a synchronization problem.

__Troubleshoot :__

If the Vault cluster finds itself in a state where none of the nodes is a leader, it is possible to re-establish a leader via the following procedure:

1. Remove pods from the Vault cluster

2. Run the following command block:
	```bash
	# Namespace Vault
	VAULT_NS="dso-vault"

	# Vault internal service
	VAULT_INTERNAL_SVC="conf-dso-vault-internal:8201"

	# Vault cluster pod names
	NODES=(
		conf-dso-vault-0
		conf-dso-vault-1
		conf-dso-vault-2
	)

	PEERS="[]"
	for ((i=1; i <= ${#NODES[@]}; ++i)); do
		PEERS=$(echo "$PEERS" | jq --arg i "$(kubectl -n $VAULT_NS exec ${NODES[i]} -c vault -- cat /vault/data/node-id)" --arg s "$VAULT_INTERNAL_SVC" '. + [{ "id": $i, "address": $s, "non_voter": false }]')
	done

	for NODE in ${NODES[*]}; do
		kubectl -n $VAULT_NAMESPACE exec $NODE -c vault -- sh -c "cat > /vault/data/raft/peers.json << $PEERS"
	done
	```

3. Restart the HA installation, which should now run to completion, and unseal the Vault instances:
	```bash
	ansible-playbook install.yaml -t vault
	```

### Bug Fixes

* :ambulance: Add trailing slash to URLs ([6f6beaf](https://github.com/cloud-pi-native/socle/commit/6f6beaf899772e5c4b70c5a9511088415d3416a4))
* :ambulance: Fix dso-config secret ([c6ce806](https://github.com/cloud-pi-native/socle/commit/c6ce806dd78aafc6cc046745c40f42e313da61d2))
* :ambulance: Fix GitLab CI Pipelines Exporter role (token retrieval) ([7949c3e](https://github.com/cloud-pi-native/socle/commit/7949c3e4af1fcf9d7d02f975f15476057bc6c193))
* :ambulance: Removing YAML anchors generating Ansible errors ([5b6d23c](https://github.com/cloud-pi-native/socle/commit/5b6d23c6da339225e4b0c13bb0a0fe041e06f666))
* :art: Fix Argo CD Dashboard ([fcba600](https://github.com/cloud-pi-native/socle/commit/fcba600684511cf0d0b9041a99a82918d1ca4248))
* :art: Fix Keycloak and SonarQube dashboards ([588f986](https://github.com/cloud-pi-native/socle/commit/588f98663eb9f242855762e9f058be12cd042385))
* :art: Fix Nexus dashboard ([6126c2b](https://github.com/cloud-pi-native/socle/commit/6126c2b680671c354c40b8a39d5c031b1c2fc706))
* :art: Fix Vault dashboard ([ea42530](https://github.com/cloud-pi-native/socle/commit/ea425301e9c27af9d737fb2503c6054048350acf))
* :art: Manage datasource UID ([47c8451](https://github.com/cloud-pi-native/socle/commit/47c84517b3122ea23914ab7d088b97705ecbf439))
* :art: use native console cnpg cluster ([2f74868](https://github.com/cloud-pi-native/socle/commit/2f74868410ec24786b34634df6b7e5f87d033b36))
* :bug: Adapt join command for Vault node 3 ([41aa2c1](https://github.com/cloud-pi-native/socle/commit/41aa2c1aeb787e34df8b2769b88786260b9f4b0f))
* :bug: Add conditions to prevent some tasks from failing ([ca79f57](https://github.com/cloud-pi-native/socle/commit/ca79f57db7e9bd1094ae91bd0933045a2a31e325))
* :bug: Add missing postgres delete command ([78bce70](https://github.com/cloud-pi-native/socle/commit/78bce7069c99992043be987c80c99554abbbbe31))
* :bug: add wait endpoints tasks ([8f371ab](https://github.com/cloud-pi-native/socle/commit/8f371ab0a213d83ed2724f6e4bdf4a066e2deac9))
* :bug: cnpg backups management ([5bece28](https://github.com/cloud-pi-native/socle/commit/5bece2888e149df35e264ca74c38941c80a680c0))
* :bug: console deployment related tasks and templates ([742f2ab](https://github.com/cloud-pi-native/socle/commit/742f2ab67a1f94fc60f3be43c6edff4b542b3d07))
* :bug: Fix Argo CD job name ([4a4f6bf](https://github.com/cloud-pi-native/socle/commit/4a4f6bf37a5f0d4b28cfd11dbef68a0c493c804e))
* :bug: Fix CNPG Dashboard namespace selector ([3261b76](https://github.com/cloud-pi-native/socle/commit/3261b76f602d7331f4c61ce268cbd58349c1cef1))
* :bug: Fix conf kind + decoding values ([8504b71](https://github.com/cloud-pi-native/socle/commit/8504b710e664cfed628a7a041f3af2a458de95ca))
* :bug: Fix GitLab Runner and Gitaly dashboards ([960e98f](https://github.com/cloud-pi-native/socle/commit/960e98f5d8382f964a3b5dab1b24c835ea222e4a))
* :bug: Fix HA enablement + OIDC + get credentials ([76a8aa1](https://github.com/cloud-pi-native/socle/commit/76a8aa1ac70b5aeb143ced437f28211100e81a23))
* :bug: Fix Harbor dashboard ([95e317f](https://github.com/cloud-pi-native/socle/commit/95e317ff2f13192222ab259cf45e72f2e67f5895))
* :bug: Fix missing admin-creds secret update ([5724454](https://github.com/cloud-pi-native/socle/commit/57244541f1053f8025a18690eb2d383cebd8dec1))
* :bug: Fix Nexus admin password setting tasks ([b5707f3](https://github.com/cloud-pi-native/socle/commit/b5707f376ce900a0ab88b8367edd431d26b42dcb))
* :bug: Fix some tasks ([9d5bcf8](https://github.com/cloud-pi-native/socle/commit/9d5bcf8d7364b0c72514841bc66810d086213ba8))
* :bug: Fix Vault metric call ([76ded42](https://github.com/cloud-pi-native/socle/commit/76ded42c2cd5e8a3dfa4d532c12691781a3a76c2))
* :bug: get-credentials playbook ([7d91efd](https://github.com/cloud-pi-native/socle/commit/7d91efd74504d11c0bda1b2a10f2750ccdd4284f))
* :bug: gitlab catalog shell script ([e598083](https://github.com/cloud-pi-native/socle/commit/e5980838c6e5b48d332364b76ecc21145c10aafc))
* :bug: handle cnpg backups deactivation ([5563dd9](https://github.com/cloud-pi-native/socle/commit/5563dd94f8d78a58c1f4d22e96d3e9a94ba9d15d))
* :bug: missing pg secret on first console deployment ([dd101d8](https://github.com/cloud-pi-native/socle/commit/dd101d8abbe1007593edf766391c70cdaca06169))
* :bug: Refactor check tasks and fix root_token ([8bcc42a](https://github.com/cloud-pi-native/socle/commit/8bcc42aa25208d9b3d08462585522832a34e571e))
* :bug: Remove unneeded time range ([a0a2a17](https://github.com/cloud-pi-native/socle/commit/a0a2a17f6b94bd643e6ee5574b334374b8e48bba))
* :bug: Upgrade Argo CD to fix servicemonitor deployment ([2d2f417](https://github.com/cloud-pi-native/socle/commit/2d2f41780ca5c1c3014b4382c16a397664a754ce))
* :bug: vault oidc group mapping need full group path ([292d6eb](https://github.com/cloud-pi-native/socle/commit/292d6eb012c51ff81207bfc6bdc56addd1f7212d))
* :memo: Corrections de typos et reformulations ([477b6ad](https://github.com/cloud-pi-native/socle/commit/477b6ad614700d694943fbb4e7fc535840b4efe8))
* :zap: Update retries count ([85602eb](https://github.com/cloud-pi-native/socle/commit/85602eb75ece9d581ccdf70420f42c17bc66ae1c))


### Performance Improvements

* :zap: enable vault ha ([d90ee55](https://github.com/cloud-pi-native/socle/commit/d90ee559884b8eff9ef91075c4d00c42b4b79e74))


### Reverts

* :fire: Reverting commit 2d2f417 ([7ffefc7](https://github.com/cloud-pi-native/socle/commit/7ffefc75ae8000dcea0c963c29c60ae657866992))

## [2.5.0](https://github.com/cloud-pi-native/socle/compare/v2.4.0...v2.5.0) (2024-05-03)


### Features

* :sparkles: add dsc.general.registry ([bd0046c](https://github.com/cloud-pi-native/socle/commit/bd0046c02ba50c7288be5dac7dea60d5c066b091))

## [2.4.0](https://github.com/cloud-pi-native/socle/compare/v2.3.0...v2.4.0) (2024-04-23)


### Features

* :sparkles: Introducing Nexus dedicated blob store ([06c5659](https://github.com/cloud-pi-native/socle/commit/06c5659ffc971545116fad3c227e4f3e2c69d128))
* :zap: ([2a4913f](https://github.com/cloud-pi-native/socle/commit/2a4913f2fb72975ed463f83d20f30b6ffe9836e4))


### Bug Fixes

* :bug: Fix missing serviceAccountName for exporter ([7c53427](https://github.com/cloud-pi-native/socle/commit/7c5342777a4df9cbad36283d44d9823cff1edf1d))
* :bug: Upgrade Argo CD to fix servicemonitor deployment ([75476ee](https://github.com/cloud-pi-native/socle/commit/75476ee8acde2039f99d80e126df85482639a32c))

## [2.3.0](https://github.com/cloud-pi-native/socle/compare/v2.2.0...v2.3.0) (2024-04-12)


### Features

* :sparkles: add velero pre hook db backups ([04773cf](https://github.com/cloud-pi-native/socle/commit/04773cff6a512582f20197bb1479cde2b1a06beb))
* :sparkles: enable daily trivy scan on harbor ([cd77551](https://github.com/cloud-pi-native/socle/commit/cd7755194dc8dadc8e2db42e95a9a159606b1f3a))
* :sparkles: introduce prometheus crd management ([fc225de](https://github.com/cloud-pi-native/socle/commit/fc225deefcbe9e0df361c06abe8dea07f0414d03))


### Bug Fixes

* :bug: fix the ability to customize argo values + security context for AppSet ([4a4e175](https://github.com/cloud-pi-native/socle/commit/4a4e1755c79089d100a6a3381633d0a8afa7a439))
* :bug: in development mode allow 127.0.0.1 ([9476919](https://github.com/cloud-pi-native/socle/commit/94769194ff0b3bc1cf76f12c95d765b3272c39e7))
* add missing ServiceMonitor CRD ([828ae4a](https://github.com/cloud-pi-native/socle/commit/828ae4a1718501e16b7e715144e73eafd6aa91a8))
* regexp without tmp file ([861046e](https://github.com/cloud-pi-native/socle/commit/861046ec9f8bab63fd7fa6abfe2246c4ed96b410))
* remove prometheus CRD task ([f589940](https://github.com/cloud-pi-native/socle/commit/f5899403657a6acad8b17eee15d77f2485790a24))

## [2.2.0](https://github.com/cloud-pi-native/socle/compare/v2.1.1...v2.2.0) (2024-03-25)


### Features

* :sparkles: Enable directAccessGrants for argo-client ([be0843f](https://github.com/cloud-pi-native/socle/commit/be0843f3871a937e45c42c5b5645eead7f86abd0))
* :sparkles: Enable postgres super user (as we might need it) ([08a64ad](https://github.com/cloud-pi-native/socle/commit/08a64ad836d39448c1516a70215dfaa3a434a9e6))
* :sparkles: Enabling brute force detection ([c3d8f50](https://github.com/cloud-pi-native/socle/commit/c3d8f50bc67204ac578a57e9f838e0d2019cfe99))
* :sparkles: Set failureFactor for brute force protection ([dbe7b20](https://github.com/cloud-pi-native/socle/commit/dbe7b2034878ca8e1efdfd7ef1ba767d908b8709))


### Bug Fixes

* :bug: Change rbac policies (wrong syntax + disallow clusters for nada role) ([0ce8193](https://github.com/cloud-pi-native/socle/commit/0ce81930f09dd766c80640af6013e95135287dd5))
* :bug: Fix Argo CD rbac policy ([d9f03f1](https://github.com/cloud-pi-native/socle/commit/d9f03f1d2c84bcddb086a4cb0275ea7f1a386ed1))
* :bug: Fix clusters rbac policy ([ce5ca77](https://github.com/cloud-pi-native/socle/commit/ce5ca7777a418f667c902ccc7746450fa7ac5979))

## [2.1.1](https://github.com/cloud-pi-native/socle/compare/v2.1.0...v2.1.1) (2024-03-20)


### Performance Improvements

* :green_heart: disable KAS as we don't need Gitlab to deploy on kubernetes ([213be12](https://github.com/cloud-pi-native/socle/commit/213be124c59276d1759ec41e62729ac3711d75fa))

## [2.1.0](https://github.com/cloud-pi-native/socle/compare/v2.0.0...v2.1.0) (2024-03-13)


### Features

* :sparkles: Enable postgres user access ([71a2f70](https://github.com/cloud-pi-native/socle/commit/71a2f703ef221d45c976f015950021560d825aba))


### Bug Fixes

* :bug: Fix get version task (validate_certs) ([be646c8](https://github.com/cloud-pi-native/socle/commit/be646c806fe6c7dab11d64f8edcf533d6dcdbad4))

## [2.0.0](https://github.com/cloud-pi-native/socle/compare/v1.3.0...v2.0.0) (2024-03-01)


### ⚠ BREAKING CHANGES

* :sparkles: Kyverno as a Kubed replacement

### Features

* :art: Add Kyverno namespace to dsc + improve uninstall ([410e344](https://github.com/cloud-pi-native/socle/commit/410e344e09f2e8a9d7d295b87a086ec1fc6948e8))
* :art: Add uninstall for Grafana ingress ([eb33f15](https://github.com/cloud-pi-native/socle/commit/eb33f15ee8b709d7d4800ac66a23e3ba7f668deb))
* :art: Improve Kyverno uninstall ([b05d2b9](https://github.com/cloud-pi-native/socle/commit/b05d2b94b2744042a38c3752e3655e45b56cda22))
* :sparkles: Add keycloak binding, dashboards + refactor ([391eeb8](https://github.com/cloud-pi-native/socle/commit/391eeb845eb06b4cc52f6c99d4b2a4de165c3f78))
* :sparkles: Add some dashboards ([c29eeef](https://github.com/cloud-pi-native/socle/commit/c29eeefc75b72a13fcb62757da1077f0cf3c7087))
* :sparkles: Adding Harbor dashboard ([8e94d80](https://github.com/cloud-pi-native/socle/commit/8e94d80816b6453f5daa56cb03975dff511ec903))
* :sparkles: Adding new dashboards ([c78b738](https://github.com/cloud-pi-native/socle/commit/c78b738f7ecc857b1c0442588c1f4497f4534a9c))
* :sparkles: Change dashboards creation process ([6719e82](https://github.com/cloud-pi-native/socle/commit/6719e82fa57e7c7b79af77e79642f11c3dc53ee1))
* :sparkles: Kyverno as a Kubed replacement ([124e24e](https://github.com/cloud-pi-native/socle/commit/124e24e374e9074b4633a5a94432c586f0e33186))


### Bug Fixes

* :art: Fix some parameters for updated Argo CD ([ac40895](https://github.com/cloud-pi-native/socle/commit/ac40895c89bec6137ffc4031e7345720957447c7))
* :art: Remove useless force ([2d7fd26](https://github.com/cloud-pi-native/socle/commit/2d7fd26f216837bc0cc39ea6c09e39ec857bc5f0))
* :bug: Dashboards settings ([cd4aa01](https://github.com/cloud-pi-native/socle/commit/cd4aa019a241d4179bccf3047e515e7eaca4930f))
* :bug: Fix (typo) ([9de47fa](https://github.com/cloud-pi-native/socle/commit/9de47fa5ae4ae853d7dc7e812d49d20106498857))
* :bug: Fix get-credentials (grafana part) ([2ff5a4b](https://github.com/cloud-pi-native/socle/commit/2ff5a4b8c99339d0f1891175a5b1141475b13802))
* :bug: Fix get-credentials for grafana part ([e154dae](https://github.com/cloud-pi-native/socle/commit/e154dae5673b4a70ca70cdc3ba5bfc03afe31cdc))
* :bug: Refactor and fix GitLab metrics ([e09a138](https://github.com/cloud-pi-native/socle/commit/e09a138987cf091a6868dff9f86621b7300226a8))
* :bug: Refactor and fix GitLab metrics ([fbab543](https://github.com/cloud-pi-native/socle/commit/fbab54352d5a65ba361de5369995c628a8ef607e))

## [1.3.0](https://github.com/cloud-pi-native/socle/compare/v1.2.0...v1.3.0) (2024-01-31)


### Features

* :bookmark: Update Console version ([7a07b69](https://github.com/cloud-pi-native/socle/commit/7a07b69803d0913fea842689c77e4fa9a7f1979d))
* :lock: force images pull on gitlab runner to prevent cache abuse ([bbe1480](https://github.com/cloud-pi-native/socle/commit/bbe14807f8434c5cd11600ea1603a01e5029ec4b))
* :lock: force images pull on gitlab runner to prevent cache abuse ([62c701c](https://github.com/cloud-pi-native/socle/commit/62c701c206bbce54dae091a04631e38770037348))
* :sparkles: ([9487622](https://github.com/cloud-pi-native/socle/commit/94876223048655cf4420842a1fc2db8f3714c6c7))
* :sparkles: Activate keycloak basic metrics ([e7630fd](https://github.com/cloud-pi-native/socle/commit/e7630fd158fb4e12e9f8f98bc4724cef91645cb2))
* :sparkles: Activate metrics when dsc.global.metric.enabled ([49e91f8](https://github.com/cloud-pi-native/socle/commit/49e91f82a1447e1b38e8f633bab669f8cda8f7a1))
* :sparkles: Activate monitoring  for additionnal resources + refactor ([9c9f979](https://github.com/cloud-pi-native/socle/commit/9c9f979b05e23a0130371cecc02d216570664de5))
* :sparkles: Activate monitoring + small refactor ([255bb56](https://github.com/cloud-pi-native/socle/commit/255bb5657ad3dded213e8aa055c42f5b03b65f22))
* :sparkles: Activate Nexus metrics scraping ([0e53610](https://github.com/cloud-pi-native/socle/commit/0e53610ce121caa244e868154a67a5f8db3eaa28))
* :sparkles: Activate Vault metrics ([63ade45](https://github.com/cloud-pi-native/socle/commit/63ade457c10c5553df35ed08c097d87d01c7c5fb))
* :sparkles: Add checks + uninstall feature ([9d8c218](https://github.com/cloud-pi-native/socle/commit/9d8c218014c8fc97218ca1e4830313d464cf112d))
* :sparkles: Add directAccessGrantsEnabled to console-frontend client ([cc85b8b](https://github.com/cloud-pi-native/socle/commit/cc85b8bf6ddb5aaa0c79e0322bbbf6554a4abfc2))
* :sparkles: Add global metrics parameter ([7e0a919](https://github.com/cloud-pi-native/socle/commit/7e0a91912fe6f44e5ed5aa23f61c80fa0f191896))
* :sparkles: Add Grafana credentials retrieval and default datasource ([7fd54be](https://github.com/cloud-pi-native/socle/commit/7fd54beefc0cf0c12de9e0bd47d71e80935581bf))
* :sparkles: Add never tag for grafana + some SonarQube credentials ([26827dc](https://github.com/cloud-pi-native/socle/commit/26827dc851366d1bf6078ba418ec47a1446b0d05))
* :sparkles: Added the never tag so the role in only played on demand. ([738eff0](https://github.com/cloud-pi-native/socle/commit/738eff08be0250905488df622d958dedbfdb3e5a))
* :sparkles: Check Grafana instance before installing datasource ([a8da5e6](https://github.com/cloud-pi-native/socle/commit/a8da5e6a30c33e5ac48bf1c4266166681cf3f5f3))
* :sparkles: Conditionnal metrics enablement ([46f27c6](https://github.com/cloud-pi-native/socle/commit/46f27c6784b63f6f5973f7e65a66d466c62ab2c6))
* :sparkles: Enable GitLab Runner metrics, Service and ServiceMonitor ([2706849](https://github.com/cloud-pi-native/socle/commit/2706849496eb73474f6c06444dc9927853d7bf7b))
* :sparkles: Install Grafana instance + enable Keycloak metrics ([9ac6ff8](https://github.com/cloud-pi-native/socle/commit/9ac6ff8e197f652de8b1731be6611066cb711f82))
* :sparkles: Manage sealed Vault and configmap changes ([3d2033b](https://github.com/cloud-pi-native/socle/commit/3d2033bd3cc2a416f021177f97f0936b66640834))
* :sparkles: Metrics activated if enabled in dsc ([987f110](https://github.com/cloud-pi-native/socle/commit/987f110410b42a3e2265aee77e8329bfe726b20d))
* :sparkles: Metrics authentication enabled + patch ServiceMonitor ([8195910](https://github.com/cloud-pi-native/socle/commit/8195910dd94a52da1e918067935ee90b09a3b43b))
* :sparkles: Uninstall Grafana instance and/or its defaults datasource ([835a74b](https://github.com/cloud-pi-native/socle/commit/835a74b7ee2781a67b9801a4a76af57c5fb8a917))
* :zap: Update console version ([bac4144](https://github.com/cloud-pi-native/socle/commit/bac4144296bb3ea6b4f1c547f175ce9bf1ae49ae))
* :zap: Update GitLab chart version ([f5bc072](https://github.com/cloud-pi-native/socle/commit/f5bc0721ba8821a781a39452240167060bcf5af7))
* :zap: Update GitLab chart version ([f640320](https://github.com/cloud-pi-native/socle/commit/f640320154bfe47ceebfe49a2a53bc4863af658f))
* :zap: update keycloak replication to 3 containers ([7cca65f](https://github.com/cloud-pi-native/socle/commit/7cca65f7332577b746f3c2d499701823f4a6f0cd))
* :zap: update keycloak replication to 3 containers ([7e6ba96](https://github.com/cloud-pi-native/socle/commit/7e6ba96a1f7f30118979f1517bc30eb5ab2f9b65))


### Bug Fixes

* :ambulance: Move harbor values file ([fff3276](https://github.com/cloud-pi-native/socle/commit/fff32766d37caa71c7036ae88b29791038ed4d29))
* :bug: bad tls runner toml ([db5cea5](https://github.com/cloud-pi-native/socle/commit/db5cea550deadf27d2133d3aa2934bad2f2d6ac4))
* :bug: bad tls runner toml ([aba354c](https://github.com/cloud-pi-native/socle/commit/aba354c20bb5aaef75cf22101d56fa1bd1ef76b7))
* :bug: CRD and some values ([84fdcfd](https://github.com/cloud-pi-native/socle/commit/84fdcfd73aefa9d02e6b81bb043a7b117fa3ae4e))
* :bug: CRD and some values ([c4f9666](https://github.com/cloud-pi-native/socle/commit/c4f9666fed75944ecf40f4041d2b5e823029cd5b))
* :bug: Fix missing cert parth + condition dsc.exposedCA.type ([a25713e](https://github.com/cloud-pi-native/socle/commit/a25713eec6793ee1d75791f44820beee568942ea))
* :bug: Fix missing gitlabRunner as a dsc crd requirement ([672c96d](https://github.com/cloud-pi-native/socle/commit/672c96dcea0476b5c2665d8650c914c921b45581))
* :bug: Fix releases file ([5885825](https://github.com/cloud-pi-native/socle/commit/58858257d79f3fbdd6ebbbfb443326018c0faee6))
* :bug: Fix releases file ([6d0cd75](https://github.com/cloud-pi-native/socle/commit/6d0cd75cef9467b2959e734a4269a89889131cea))
* :bug: fix sonarqube deployment ([01c2442](https://github.com/cloud-pi-native/socle/commit/01c2442eeadfde45d43bcfced065aebbc5a41ad0))
* :bug: fix sonarqube deployment ([a753094](https://github.com/cloud-pi-native/socle/commit/a7530947cc0a86872202005845a66e4f39cbb862))
* :bug: Indentations ([b353fab](https://github.com/cloud-pi-native/socle/commit/b353fab0d7ea7c4d711c7df18b3759e4c5a93ffd))
* :bug: Prevent failure on PodMonitor creation ([f1ce65d](https://github.com/cloud-pi-native/socle/commit/f1ce65d770281df5f8bffaabec18a3fedd5cf9e6))
* :bug: We should allow downgrading too ([067e1e9](https://github.com/cloud-pi-native/socle/commit/067e1e9d03632da5cc7aa1e48447f2676ee08eee))
* :fire: We do not enable prometheus rules from helm chart ([40097c9](https://github.com/cloud-pi-native/socle/commit/40097c9c2b92c35b9e93365bf3eb657dc1bc97d1))


### Performance Improvements

* :zap: enable argocd replication ([a037b80](https://github.com/cloud-pi-native/socle/commit/a037b8008f9c5815e28ee10da93f9fac7a3a7603))
* :zap: enable argocd replication ([a09440c](https://github.com/cloud-pi-native/socle/commit/a09440c36f06b9e83ea0db9f2e79150a19688ca7))
* :zap: enable harbor replication ([558f2c2](https://github.com/cloud-pi-native/socle/commit/558f2c29670b7546ac7c4254f73972abe7b290dc))
* :zap: enable harbor replication ([954920c](https://github.com/cloud-pi-native/socle/commit/954920c77053d6f8a6798eb5c2a23c7795a9aad5))

## [1.2.0](https://github.com/cloud-pi-native/socle/compare/v1.1.1...v1.2.0) (2023-12-13)


### Features

* :sparkles: We don't install GitLab Operator when it's already here. ([a3298e4](https://github.com/cloud-pi-native/socle/commit/a3298e4f4acfa235e35c003f14603a479c67097b))
* :zap: Update console version ([92ee57f](https://github.com/cloud-pi-native/socle/commit/92ee57fa50c59fdfe5ec5f5a787f7e67bde10d84))


### Bug Fixes

* :ambulance: Fix CNPG Clusters instances number / Remove unnecessary PG image setting ([5877d4f](https://github.com/cloud-pi-native/socle/commit/5877d4f964560467366e1137088cdcefba02ef45))
* :bug: ([1561d78](https://github.com/cloud-pi-native/socle/commit/1561d78068db4001d83177867a7fc51e24616a1b))
* :bug: Fix dual installation (GitLab part) ([07ce30c](https://github.com/cloud-pi-native/socle/commit/07ce30c15e97e597f85c4e44a7bd71e9b9f86868))
* :bug: Fix Gitlab Operator uninstall and ns retrieval + GitLab values settings ([ada1f9e](https://github.com/cloud-pi-native/socle/commit/ada1f9e5ea1c0fbaf6c9b75b0c73e5270146ff8a))
* :bug: Fix missing cert parth + condition dsc.exposedCA.type ([8a7ddc0](https://github.com/cloud-pi-native/socle/commit/8a7ddc0a9df9ee13c6c124733101ebbd496f26dc))
* :bug: We want to use installed GitLab Operator namespace ([4049368](https://github.com/cloud-pi-native/socle/commit/404936899f3203ebfd7fc6fa3e2ef28cf7efc30b))

## [1.1.1](https://github.com/cloud-pi-native/socle/compare/v1.1.0...v1.1.1) (2023-11-23)


### Bug Fixes

* :bookmark: fix console release version number ([e0f5540](https://github.com/cloud-pi-native/socle/commit/e0f5540733a1c4cd3a7f881b7f374a3123c04b92))

## [1.1.0](https://github.com/cloud-pi-native/socle/compare/v1.0.1...v1.1.0) (2023-11-22)


### Features

* :sparkles: Nous évitons d'installer cert-manager si déjà présent. ([1b2bea2](https://github.com/cloud-pi-native/socle/commit/1b2bea2d88f68d104e10e899838fa3f773dd72f0))
* :sparkles: Nous évitons d'installer kubed si déjà présent. ([eb3fe80](https://github.com/cloud-pi-native/socle/commit/eb3fe800c745861972df6850fc9a7c88ed231ebb))
* :wrench: ability to inject additional gitlab vars ([0989614](https://github.com/cloud-pi-native/socle/commit/09896140b1a88c8bb8cfb2b9158d1650fdfedb5e))


### Bug Fixes

* :adhesive_bandage: Ajout du user dso admin dans les bons groupes ([14f9ee4](https://github.com/cloud-pi-native/socle/commit/14f9ee405abd921d8467c80588496a7959f705c5))
* :ambulance: Correctif cert-manager sur récupération des CRDS ([c77e78b](https://github.com/cloud-pi-native/socle/commit/c77e78bc57aa31d791e5042060b4d0ef7335cd6b))
* :ambulance: correctif du role nexus ([6763075](https://github.com/cloud-pi-native/socle/commit/67630759cd1e46f1c245f8b5784d5ed243c8e767))
* :bug: Correctif désinstallation GitLab ([d233e61](https://github.com/cloud-pi-native/socle/commit/d233e6179177ad3c415a136240dba57579eed9d2))
* :bug: correctif désinstallation Nexus ([ae997e3](https://github.com/cloud-pi-native/socle/commit/ae997e37973aabb55b35647af98b6293d7ba39f4))
* :bug: Correctif double quotes pour linter. ([5a62480](https://github.com/cloud-pi-native/socle/commit/5a62480f60819a5090373122230adfcbb491fcb8))
* :bug: Correctif fact npm_file ([bfa0deb](https://github.com/cloud-pi-native/socle/commit/bfa0debb7f89e4d492aaf48d5224d1f6476c1f10))
* :bug: Correctif indentations dans templates jinja + task token GitLab ([117c33f](https://github.com/cloud-pi-native/socle/commit/117c33f0a79a5ffe8df39a934e66c1c99fcfa7e4))
* :bug: Correctif playbook de désinstallation. ([0554fe7](https://github.com/cloud-pi-native/socle/commit/0554fe741a24949cc6de199d49b97e0a2139f9e4))
* :bug: fix cert-manager crds installation ([4378ee3](https://github.com/cloud-pi-native/socle/commit/4378ee389a5c283ad549b13381d4f2182ea1af18))
* :bug: fix extraCIVars in dsc ([953eb9f](https://github.com/cloud-pi-native/socle/commit/953eb9fb0a0b3eede7bec5306c0f5918639f774a))
* :fire: suppression variable anon_enabled qui n'est plus utilisée ([b5dae7a](https://github.com/cloud-pi-native/socle/commit/b5dae7a773b805e4b5770ed3fc8879f3cb3e216e))
* :sparkles: add community branch plugin ([3dcd5e1](https://github.com/cloud-pi-native/socle/commit/3dcd5e1e0d31862e9f14e4c811dc00a1837222bc))


### Performance Improvements

* :recycle: refactor helm values computation ([874b21c](https://github.com/cloud-pi-native/socle/commit/874b21c177fadafcc160cc20521715d06f70eab5))

## [1.0.1](https://github.com/cloud-pi-native/socle/compare/v1.0.0...v1.0.1) (2023-11-04)


### Bug Fixes

* :arrow_up: upgrade harbor ([cc42d17](https://github.com/cloud-pi-native/socle/commit/cc42d17bc80a23957cbe49b93f7328ac0be7d3c3))

## 1.0.0 (2023-11-03)


### Features

* :alien: adapt for console V3 deployment ([edb22d7](https://github.com/cloud-pi-native/socle/commit/edb22d7fb63439b88d25a4a5844b72af8181b516))
* :art: Get credentials + README ([729d1b7](https://github.com/cloud-pi-native/socle/commit/729d1b79b4a1692a040509c8d85667a334fed06b))
* :construction: FEAT: Adaptation partie Keycloak + get-credentials ([2662d12](https://github.com/cloud-pi-native/socle/commit/2662d123bb473ed3d84966d5a4d0a3adf729e40f))
* :construction: FEAT: implementing DsoSocleConfig CRD ([083e6e3](https://github.com/cloud-pi-native/socle/commit/083e6e3a53ba7c3c3a9d1e6ffe726d933595f1ac))
* :construction: variabilze gitlab installation ([96b746e](https://github.com/cloud-pi-native/socle/commit/96b746ef674526eb51b1ea798e780d73ed738092))
* :lock: add keycloak password policy ([e92669d](https://github.com/cloud-pi-native/socle/commit/e92669d4662d1c52db697393a13133d29b8a1573))
* :sparkles: Admin tools ([edcdcfd](https://github.com/cloud-pi-native/socle/commit/edcdcfd21e6a5df40aae4d2a7186ab4d786ed96a))
* :sparkles: ajout de paramètre dsc pour fixer la version PostgreSQL de Keycloak + README ([21b6c05](https://github.com/cloud-pi-native/socle/commit/21b6c055ca6eb758a719678940351892e79363f0))
* :sparkles: ajout du playbook install-requirements et adaptation du README ([e64d3ed](https://github.com/cloud-pi-native/socle/commit/e64d3ed9500af5f38b7765f2d61b80f2326ec08b))
* :sparkles: arbitrary values can be passed to helm harbor ([82ba737](https://github.com/cloud-pi-native/socle/commit/82ba737bcf4c2a04c00f29a65d3cb6510282f63d))
* :sparkles: arbitrary values can be passed to helm vault ([3102895](https://github.com/cloud-pi-native/socle/commit/3102895e88ef9daa418c392548ef2be23da0c6fd))
* :sparkles: configure ingress with tls secret ([30d199a](https://github.com/cloud-pi-native/socle/commit/30d199aeff0afdf8633652293cddd21d02745e2c))
* :sparkles: control ingressClassName with dsc ([51b2dc6](https://github.com/cloud-pi-native/socle/commit/51b2dc6e040232384b2799916d9723970fbdf74e))
* :sparkles: évolution de l'installation des opérateurs : remplacés par helm ([c143697](https://github.com/cloud-pi-native/socle/commit/c143697c4e52b9aafb99a157d08e28472c4d9305))
* :sparkles: FEAT : freeze version Argo CD + update README ([380c89d](https://github.com/cloud-pi-native/socle/commit/380c89d5926c49562a8d5e7e35843cfe6b100282))
* :sparkles: FEAT : freeze version GitLab + update README + correctifs validate_cert ([69fe0b4](https://github.com/cloud-pi-native/socle/commit/69fe0b468fd4b2106b6691ff2c7bc429ec8eb4b1))
* :sparkles: FEAT : freeze version Harbor + update README ([5588035](https://github.com/cloud-pi-native/socle/commit/5588035f48166e091054822fecb0a21a9a50554e))
* :sparkles: FEAT : freeze version Kubed + update README ([ace3f1b](https://github.com/cloud-pi-native/socle/commit/ace3f1bbb440a16a7fc7b0ac47573b64f3710823))
* :sparkles: FEAT : freeze version Nexus + update README ([fa84da8](https://github.com/cloud-pi-native/socle/commit/fa84da84017c4dc9772cc2d805ad5b2e11e8332e))
* :sparkles: FEAT : freeze version SonarQube + update README ([220752e](https://github.com/cloud-pi-native/socle/commit/220752ebd7023a5556ca051b9915c4f82f64a5d9))
* :sparkles: FEAT : freeze version SOPS + update README ([63ba6f3](https://github.com/cloud-pi-native/socle/commit/63ba6f3ee11d87cc05ff1777b11cd3c29b7b7509))
* :sparkles: FEAT : freeze version Vault + update README ([88d27d3](https://github.com/cloud-pi-native/socle/commit/88d27d384b2bc672abe5961b510868cc20a23786))
* :sparkles: FEAT: Adaptation playbook uninstall + refactorisation tâche de debug ([452db9a](https://github.com/cloud-pi-native/socle/commit/452db9a05140cdbcad9f2c5417f51dc401c810b7))
* :sparkles: FEAT: Add argocd values to dso-socle CRD + update arocd role ([d659ede](https://github.com/cloud-pi-native/socle/commit/d659ede1632655df3fd8515092059eb516803e9c))
* :sparkles: FEAT: Ajout check d'initialisation cert-manager ([7385da9](https://github.com/cloud-pi-native/socle/commit/7385da9d83d3135f3acf7483b48f378984bb39f8))
* :sparkles: FEAT: Ajout checks et wait conditions Keycloak + update README ([e9748c9](https://github.com/cloud-pi-native/socle/commit/e9748c9ae635e3224df9d158fe19fe37b6d6fb40))
* :sparkles: FEAT: Ajout proxy env vars au deploiement Nexus ([bd93396](https://github.com/cloud-pi-native/socle/commit/bd93396fa495efd61049bc22aa448cb565a41d0f))
* :sparkles: FEAT: Ajout proxy env vars au déploiement SOPS + refactor du rôle ([a771149](https://github.com/cloud-pi-native/socle/commit/a771149556a7ee789e0b12ed20cd41f4ab9b5ae1))
* :sparkles: FEAT: Ajouts de wait conditions pour Vault ([e143236](https://github.com/cloud-pi-native/socle/commit/e1432368b01a64dfcc0c4fbf2337439305fb8757))
* :sparkles: FEAT: Ajouts proxy env vars aux déploiement SonarQube ([484d654](https://github.com/cloud-pi-native/socle/commit/484d6545ad8dfd13d6728677fc9500bf88282e08))
* :sparkles: FEAT: Ajustement wait conditions SonarQube ([3af6c82](https://github.com/cloud-pi-native/socle/commit/3af6c825a2b47a3c7a19ec636e4f215e539bc167))
* :sparkles: FEAT: améliorations Gitlab et Harbor + évolution CRD et cert-manager pour ACME ([55061ee](https://github.com/cloud-pi-native/socle/commit/55061eeade4068e87922e0cb8a1da1a4dcd612ef))
* :sparkles: FEAT: finalisation utilisation resource dsc conf-dso ([19caa01](https://github.com/cloud-pi-native/socle/commit/19caa01b31571621a7edc221557509deeac6bdfc))
* :sparkles: FEAT: Pull policy des images d'install ArgoCD et  Harbor + correctifs README ([c4cd503](https://github.com/cloud-pi-native/socle/commit/c4cd5031a6799301c0c5017878448d0cec6b1ea7))
* :sparkles: FEAT: Réécriture uninstall.yaml + doc du sujet dans README + fix mineur get-credential ([674eea8](https://github.com/cloud-pi-native/socle/commit/674eea8754ef128967174e0fcfd2d09cd3f29956))
* :sparkles: FEAT: tâche de désinstallation de cert-manager + update README ([1ee479e](https://github.com/cloud-pi-native/socle/commit/1ee479e536e775c50ae35f7fbd25aba247669d0f))
* :sparkles: fetch custom CA from configmap ([df6b596](https://github.com/cloud-pi-native/socle/commit/df6b5968c156bb5028875ece2e83c47dc2f43bee))
* :sparkles: finalisation adaptation de l'installation keycloak via helm ([3f95cc9](https://github.com/cloud-pi-native/socle/commit/3f95cc9414def4b9006893c73e4db7ed7879aeba))
* :sparkles: Initialisation du role sops ([5ed9ac8](https://github.com/cloud-pi-native/socle/commit/5ed9ac856e4e429a5de83f3b8dc714205513c0dc))
* :sparkles: inject ca bundle in ci variable ([ac11110](https://github.com/cloud-pi-native/socle/commit/ac111107cde85e7fbcd68cf66aec9d7f74f8102b))
* :sparkles: installation via helm chart officiel ([a5515f2](https://github.com/cloud-pi-native/socle/commit/a5515f20e2f29dcce2f7ad50004d2e6867a64168))
* :sparkles: MAJ du README et adaptations role keycloak ([952b453](https://github.com/cloud-pi-native/socle/commit/952b453dc18876abd493c8fdad19f67c77bc8d98))
* :sparkles: separate exposed_ca from additionals_ca ([a4ab9d3](https://github.com/cloud-pi-native/socle/commit/a4ab9d3a54250479fdeeb63a988940e46eb2a64c))
* :sparkles: sonarqube use keycloak ([a6007e9](https://github.com/cloud-pi-native/socle/commit/a6007e9fabc90ccd18d71361383773f06b300e14))
* :sparkles: Tools (get-credentials : new tools added) ([9485951](https://github.com/cloud-pi-native/socle/commit/9485951dd730a24de9047e2d8e79d7a519c307d5))
* :sparkles: Tools (get-credentials) : adding DSO tools ([1daf512](https://github.com/cloud-pi-native/socle/commit/1daf51264f34551790fd688ad7d57f42bba11070))
* :sparkles: uninstall playbook, not perfect yet ([9020ba5](https://github.com/cloud-pi-native/socle/commit/9020ba5606ee63a8bf2340583c304c1b8efb04dc))
* :sparkles: user can override gitlab helm values ([f578668](https://github.com/cloud-pi-native/socle/commit/f578668feb4b4f1f1750b47e018b28ae596ba3e8))
* :sparkles: variabilize argo installation ([2e14309](https://github.com/cloud-pi-native/socle/commit/2e14309317e3a82f9e7021ce9eca8fb4626f90a8))
* :sparkles: variabilize harbor installation, use cluster issuer ([18c45d4](https://github.com/cloud-pi-native/socle/commit/18c45d4759f8d64ee06438743329b0a49af16e4e))
* :sparkles: variabilize keycloak installation ([017c59b](https://github.com/cloud-pi-native/socle/commit/017c59b13fa8f58c09c11d167fb19ee943a483da))
* :sparkles: variabilize nexus installation ([eda0c47](https://github.com/cloud-pi-native/socle/commit/eda0c478e04ba112cac7ec5333caa3c9d8ebbc89))
* :sparkles: variabilize nexus pvc size and management ([54121ae](https://github.com/cloud-pi-native/socle/commit/54121aeca7498fc8938e3415f4eef582a7d2e7bc))
* :sparkles: variabilize runner installation ([4bc5e5a](https://github.com/cloud-pi-native/socle/commit/4bc5e5a8e8bfab02f7d67621eaab1124b54aaabf))
* :sparkles: variabilize sonar installation ([a15556b](https://github.com/cloud-pi-native/socle/commit/a15556b6c8e8e3044745b64b2cfa1375d76c5d47))
* :sparkles: variabilize vault installation ([8feda5d](https://github.com/cloud-pi-native/socle/commit/8feda5dc892a428f1f3040390fb3658ed842ca1d))
* :synchronize a catalog from github repo ([59b504a](https://github.com/cloud-pi-native/socle/commit/59b504a0e45fbd003414f022f5f29bdfe96d1e1f))
* :tada: Init project ([4b493cc](https://github.com/cloud-pi-native/socle/commit/4b493cc28f96eb28b9b59f4ac0d4490846f57b6a))
* :wrench: Use configmap to store socle config ([87c2d81](https://github.com/cloud-pi-native/socle/commit/87c2d814120e304b2d689e97970c15dfdde10a3f))
* :zap: Augmentation nbre de retries ([f7f4a11](https://github.com/cloud-pi-native/socle/commit/f7f4a115e6f7a001a97b5b5a5ef8ee28d88589c0))
* :zap: Display tags list + tags optimisation ([54d9112](https://github.com/cloud-pi-native/socle/commit/54d9112e25242d9b27f2d9d6cdbe7b687da16439))
* parallel deployment (+ adaptation README, uninstall et get-credentials) ([0e78b62](https://github.com/cloud-pi-native/socle/commit/0e78b627702ad66a4470df2a57a8ab608a3f8bcc))


### Bug Fixes

* fix:  ([166c076](https://github.com/cloud-pi-native/socle/commit/166c07628581de4c895873168cab870612fc299b))
* fix:  ([aec0457](https://github.com/cloud-pi-native/socle/commit/aec04579294b2a50cd9f0a7875cac55ea1525fb7))
* :adhesive_bandage: FIX: Tasks de suppression du vars.yaml obsolètes + correctif README ([7658878](https://github.com/cloud-pi-native/socle/commit/76588788e8521b3a9cb07872c22869dcda1e4670))
* :alien: changement de méthode d'enregistrement des runners ([7a1488d](https://github.com/cloud-pi-native/socle/commit/7a1488d1bd270551d8ef7b491808b20da91fcb34))
* :alien: gitlab token needs expiration date ([b445353](https://github.com/cloud-pi-native/socle/commit/b4453532ec21113f1c92340cf6ac2bc178b69abe))
* :alien: set outbound whitelist for gitlab ([0f7cffe](https://github.com/cloud-pi-native/socle/commit/0f7cffe1a11661a0bf3988e8a32d0d55d2b3e88c))
* :ambulance: hardcode chart version, fix helm values ([32cb8ba](https://github.com/cloud-pi-native/socle/commit/32cb8ba633c671b0ef15059b94edbd3bd0e867b4))
* :ambulance: HOTFIX: Oubli du tag always sur task de check custom config ([76a8aad](https://github.com/cloud-pi-native/socle/commit/76a8aadc696a44cb13838ebd68cb17242b333bb1))
* :ambulance: on a fait n'imp ([34bda7b](https://github.com/cloud-pi-native/socle/commit/34bda7b662b3d6c1005dc86141c307fa17bc0d71))
* :ambulance: tls broken on gitlab ([e0ecd39](https://github.com/cloud-pi-native/socle/commit/e0ecd39550d726b453bedd72c1d860b59d229179))
* :art: can provide harbor pvc size ([b445353](https://github.com/cloud-pi-native/socle/commit/b4453532ec21113f1c92340cf6ac2bc178b69abe))
* :art: finish variabilize argo ([b445353](https://github.com/cloud-pi-native/socle/commit/b4453532ec21113f1c92340cf6ac2bc178b69abe))
* :art: ingresses share the same cluster issuer ([d3d0658](https://github.com/cloud-pi-native/socle/commit/d3d065849e6648186b31cf8dd413073aead7b7f7))
* :art: réécriture du playbook pour utilisation de Homebrew + adaptation README ([6ce409b](https://github.com/cloud-pi-native/socle/commit/6ce409b3d3c71080f48d8202bf521631b6172c25))
* :art: sort socle-config.yaml ([5f4ea43](https://github.com/cloud-pi-native/socle/commit/5f4ea4357aa7459ce0e8feecb8296827dd966cf6))
* :art: support helm values for console ([7b72c48](https://github.com/cloud-pi-native/socle/commit/7b72c48ce6dca623dcbd6111c60d0ce19c5b8cd1))
* :art: variabilize postgres clusters pvc size ([10db02d](https://github.com/cloud-pi-native/socle/commit/10db02db63d3bacaa76083c902df75e01d727846))
* :bookmark: FIX : version Harbor par défaut dans CRD ([6e10c3c](https://github.com/cloud-pi-native/socle/commit/6e10c3c8e1a3d11182ca195d28bdc84080403176))
* :bug: adaptation de déclaration du fact gitlab_token ([747aa10](https://github.com/cloud-pi-native/socle/commit/747aa1074f3d20dc65fd545487e0387a62ef4231))
* :bug: Ajout console.dso.local au client console-frontend ([3b2dc9d](https://github.com/cloud-pi-native/socle/commit/3b2dc9df064f1a9f1826981153e35a627d7586eb))
* :bug: ajout de la variable environment dans la CRD et utilisation côté keycloak ([6d700ba](https://github.com/cloud-pi-native/socle/commit/6d700ba274082f05c28a18c2648fd14cb6a8713b))
* :bug: Ajout tag always dans task cert manager. ([9c98dad](https://github.com/cloud-pi-native/socle/commit/9c98dad14d21eb4ddeeaa3b642e096523422c7c3))
* :bug: bad harbor version ([721e28c](https://github.com/cloud-pi-native/socle/commit/721e28cef300996d22912d08a48a9db56f17791d))
* :bug: ci insecure args ([a882c95](https://github.com/cloud-pi-native/socle/commit/a882c9532e0a6749fff17ac05b2803661af2da98))
* :bug: correctif absence endif sur dernier if ([d82d873](https://github.com/cloud-pi-native/socle/commit/d82d873d8a1ab4503c8af198eb990a5e82041726))
* :bug: correctif certsSecretName ([666bf4f](https://github.com/cloud-pi-native/socle/commit/666bf4f512f7cc2eac86f7b09acdc182a70d5b3d))
* :bug: correctif désinstallation Keycloak + ajout désinstallation CNPG + README ([5bde389](https://github.com/cloud-pi-native/socle/commit/5bde3896052f890ba0b2498846f5d48c2e30261c))
* :bug: correctif indentation syncPolicy ([d7e4e2f](https://github.com/cloud-pi-native/socle/commit/d7e4e2f1f07f6540f08e1db0e359003a8ffca0cb))
* :bug: correctif partie cert-manager ([de415ae](https://github.com/cloud-pi-native/socle/commit/de415aeaea00ee99301d599fefd015cb6f095674))
* :bug: correctif task de création du token GitLab ([8fc0d5a](https://github.com/cloud-pi-native/socle/commit/8fc0d5a2121238934a051a522696e027d86d62e2))
* :bug: Correctif task récup admin ([25722a9](https://github.com/cloud-pi-native/socle/commit/25722a9b04eed0501a1736023360084323f6cf46))
* :bug: Correctif utilisation http si environement de dev ([e1df3fc](https://github.com/cloud-pi-native/socle/commit/e1df3fc960588168d49dc1896f1e93f85deeecc9))
* :bug: correctifs pour outil get-credentials et installation keycloak + console ([ca934dd](https://github.com/cloud-pi-native/socle/commit/ca934dd3ac4cfadc9f482fde80682c1b5cf757cc))
* :bug: correction erreur permission denied sur /.gitlabconfig ([c3d1c23](https://github.com/cloud-pi-native/socle/commit/c3d1c2352e8c45161fff11896eafba1cb35ec63c))
* :bug: Correction task "Deploy helm" ([73f331d](https://github.com/cloud-pi-native/socle/commit/73f331d11a16861932ff181f018e116faeae1d8a))
* :bug: Correction task "patch openshift config trustedCA" ([25c5922](https://github.com/cloud-pi-native/socle/commit/25c5922846d7a49bbf1fba41824bd473ce9526c1))
* :bug: Corrections indentation et variable dans keycloak-frontend ([a8e6661](https://github.com/cloud-pi-native/socle/commit/a8e6661d138fc15d4b99ad55709d50a8c29aabdc))
* :bug: couldn't remove proxy vars gitlab ci ([b445353](https://github.com/cloud-pi-native/socle/commit/b4453532ec21113f1c92340cf6ac2bc178b69abe))
* :bug: enable admin group on harbor oidc ([8a4dc61](https://github.com/cloud-pi-native/socle/commit/8a4dc61af169816b6391e89268f0aa0d254f8d6f))
* :bug: fix bad ca secret name for runner ([d82202c](https://github.com/cloud-pi-native/socle/commit/d82202c94cfe87acae0a4a6fdfa3d857b7632108))
* :bug: fix CATALOG_PATH, minor settings, chore ([c97cb3a](https://github.com/cloud-pi-native/socle/commit/c97cb3a4fd4cf7d4ffc5cc795d652d5268708558))
* :bug: fix import ca from secret ([b445353](https://github.com/cloud-pi-native/socle/commit/b4453532ec21113f1c92340cf6ac2bc178b69abe))
* :bug: Fix ingresses + comment ([d2a5f8a](https://github.com/cloud-pi-native/socle/commit/d2a5f8a4af2dc430bd0821eeb82c1907e7b12757))
* :bug: fix proxy vars for harbor ([b445353](https://github.com/cloud-pi-native/socle/commit/b4453532ec21113f1c92340cf6ac2bc178b69abe))
* :bug: fix visibility, add CI var CATALOG_PATH ([27c0a67](https://github.com/cloud-pi-native/socle/commit/27c0a673d0a9c64ec293a590855ea5a031121811))
* :bug: FIX: Activation proxy pour Harbor si besoin ([83dda29](https://github.com/cloud-pi-native/socle/commit/83dda29cd86bd063e05aae8f55205d43abcda514))
* :bug: FIX: Ajout paramètre GitLab nécessaire pour gitlab catalog ([d18b525](https://github.com/cloud-pi-native/socle/commit/d18b525c6baf65fb5442dda109444efce84c4348))
* :bug: FIX: Correctif déploiement app console ([9fd35b5](https://github.com/cloud-pi-native/socle/commit/9fd35b5b3733ad1a3facd0e03373ab5e68f019ff))
* :bug: FIX: Correctif tasks sonarqube et vault ([66d0022](https://github.com/cloud-pi-native/socle/commit/66d0022028e011984d60d1da2a3f8116dc40e985))
* :bug: FIX: correctif validate_certs sur Keycloak client scope ([201dc46](https://github.com/cloud-pi-native/socle/commit/201dc46d50a4d29641669bf49813584387a3f345))
* :bug: FIX: tâche de vérification + CatalogSource gitlab-runner ([964e13e](https://github.com/cloud-pi-native/socle/commit/964e13efb7e7bcb952db61480428e54c9a4d8aed))
* :bug: hardcode vault images ([20ca5a0](https://github.com/cloud-pi-native/socle/commit/20ca5a03b147d442a10cfc13ceda7264a6acbb1b))
* :bug: keycloak tlsSecret support ([b445353](https://github.com/cloud-pi-native/socle/commit/b4453532ec21113f1c92340cf6ac2bc178b69abe))
* :bug: lot of things ([eab1629](https://github.com/cloud-pi-native/socle/commit/eab162917df48e17a959396323d645ed1a312fa0))
* :bug: maven_config_file should not be configured in CI ([b445353](https://github.com/cloud-pi-native/socle/commit/b4453532ec21113f1c92340cf6ac2bc178b69abe))
* :bug: minor fix ([209e8c4](https://github.com/cloud-pi-native/socle/commit/209e8c4dd2429fe56f685b954ce2ca4b0a44fb8f))
* :bug: minor fixes ([edc35ae](https://github.com/cloud-pi-native/socle/commit/edc35aeccdfd798830a5eb6cd04cb2db9bd4ceb2))
* :bug: missing registry prefix in harbor values ([77af3d6](https://github.com/cloud-pi-native/socle/commit/77af3d6f512f7e54ed8d03662941d2c0816258c8))
* :bug: Nexus image version ([72a9d34](https://github.com/cloud-pi-native/socle/commit/72a9d345e869eb10c3ad4e7a834c31e98e898209))
* :bug: pass proxy values to console ([8a947e4](https://github.com/cloud-pi-native/socle/commit/8a947e48b6706571927619deb9dbd90cdb5c8098))
* :bug: rewrite client keycloak generation, add missing validate_certs ([e4a9fcb](https://github.com/cloud-pi-native/socle/commit/e4a9fcb51185d90c930b6b36b19998a8899a4d91))
* :bug: set CA_BUNDLE as fle ([8beb903](https://github.com/cloud-pi-native/socle/commit/8beb903906a3656b6d3cccd9ab43b1284b96a9f1))
* :bug: so much to say ! ([f2efb86](https://github.com/cloud-pi-native/socle/commit/f2efb869d688afd9276cbb9f536635da221c517a))
* :bug: stabilize ingress tls type switching ([70ddab2](https://github.com/cloud-pi-native/socle/commit/70ddab2c232b81ce0e033fd9ced26a28c94e37b2))
* :bug: Tools (get-credentials) : fix Keycloak DSO user creds task ([2ee0ebc](https://github.com/cloud-pi-native/socle/commit/2ee0ebc17008f42fc6f6d5725f6c13993e5f3a56))
* :bug: update runner configurations ([c75bfc7](https://github.com/cloud-pi-native/socle/commit/c75bfc7c7690da451b9235222864c4a2abf56bec))
* :bug: variabilize PROXY usage ([cb43f34](https://github.com/cloud-pi-native/socle/commit/cb43f34c58ab59e98b4ce7d33f7f323a92772833))
* :bug: vault iss configuration ([618efc2](https://github.com/cloud-pi-native/socle/commit/618efc265b00401a0356caa0988b0ddc9b04effe))
* :construction: Import labels and annotations for ingresses ([37e21b8](https://github.com/cloud-pi-native/socle/commit/37e21b853b3ae354270a8b409911e9b4e851eccf))
* :construction: need review before squash, all ingress are configured ([5b8911f](https://github.com/cloud-pi-native/socle/commit/5b8911fcfd3f5930a52951244b00548a258a923c))
* :construction: progress on ingress ([83c407f](https://github.com/cloud-pi-native/socle/commit/83c407fd15ca97fd2f531d504926337759f6b825))
* :green_heart: Fix error while fetching snapshot ([827dbfb](https://github.com/cloud-pi-native/socle/commit/827dbfbc431590b33876a4fe278095eed2ded80c))
* :memo: FIX: Ajout buildOptions pour argocd + correctif README ([79b0d8e](https://github.com/cloud-pi-native/socle/commit/79b0d8ec1892a705af9a650877376b147f6eb6a3))
* :poop: test keycloak ingress parameters ([5565507](https://github.com/cloud-pi-native/socle/commit/5565507c7bec21a9cb2a0d13fe9dc31d02d767bd))
* :rewind: test revert ingress sonar ([c8e5ab2](https://github.com/cloud-pi-native/socle/commit/c8e5ab26eefad81003c180f357df6d4cc52b616b))
* :zap: add base keycloak group ([354e131](https://github.com/cloud-pi-native/socle/commit/354e131f9534ce267df2212ee22e36a0d601b7a4))
* :zap: projectsRootDir, gitlab-catalog, fixes ([bd1f61b](https://github.com/cloud-pi-native/socle/commit/bd1f61b5a6074f7dc188704464bd8d416094ab1b))
* :zap: remove fsGroup and runAsUser values from argocd ([b445353](https://github.com/cloud-pi-native/socle/commit/b4453532ec21113f1c92340cf6ac2bc178b69abe))
* :zap: set sonar pg cluster replicas to 2 ([b445353](https://github.com/cloud-pi-native/socle/commit/b4453532ec21113f1c92340cf6ac2bc178b69abe))
* FIX: Correctif tasks sonarqube et vault pour éviter d'avoir à relancer l'install ([66d0022](https://github.com/cloud-pi-native/socle/commit/66d0022028e011984d60d1da2a3f8116dc40e985))
