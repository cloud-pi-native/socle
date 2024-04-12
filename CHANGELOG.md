# Changelog

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
