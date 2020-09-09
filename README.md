# k8s-test
K8s-test is een container om scienta helm-files op syntax te testen (dus zonder k8s test-deploy).
Hiervoor wordt [helm v2](https://v2.helm.sh/docs/) en [kubeval](https://www.kubeval.com/) gebruikt.

## toolset
In deze container zitten de volgende tools:
- [helm v2](https://v2.helm.sh/docs/)
- [kubeval](https://www.kubeval.com/)
- [scienta-helm-versioning](https://github.com/ScientaNL/scienta-helm-versioning) (php-code)
- [kube-score](https://github.com/zegl/kube-score) (nu nog ongebruikt)

## gebruik van helm
Helm kan zonder k8s-cluster gebruikt worden om de yaml-files in combinatie met de values te renderen.
Dit doe je met het [`helm template`](https://v2.helm.sh/docs/helm/#helm-template) commando.
De output wordt dan naar `stdout` geschreven waarna het gepiped kan worden naar een andere tool.

Aangezien de scienta repo helm templates heeft die geprepareerd moeten worden 
met `scienta-helm-versioning` (Harmens obscure tooltje) voor ze door helm geparsed kunnen worden 
is deze parse-stap eerst nodig.

Het idee is dat de ongeparste scienta helm-files in `/helmsource` gemount worden en dan naar 
de WORKDIR `/helmfiles` ge-output worden waar de door helm gerenderd kunnen worden.

Om het parsen met php en `helm template` gecombineerd te draaien 
is een shell-script: `./parse-helm-template` gemaakt. 

Dit maakt o.a. de volgende commando's beschikbaar vanuit `/helmfiles` (de workdir):
- `./parse-helm-template` 
    - Parse en run `helm template` (output hemlfiles naar stdout)
- `./parse-helm-template | kubeval kubeval -v $K8S_VERSION --strict -`
    - Pipe helm-files naar kubeval en test ze
- `./parse-helm-template -x templates/configmap/nginx.cm.yaml --debug`
    - Parse en output 1 gegenereerde helm-file naar stdout (in debug mode)

`./parse-helm-template` is een alias voor:
```shell script
php /scienta-helm-versioning/bin/convert-versions.php convert -s$CHART_SUFFIX -c$COMMIT_SHA -- /helmsource /helmfiles $CHART_VERSION $SCIENTA_VERSION 1>/dev/null \
&& helm template /helmfiles/scienta$CHART_SUFFIX/v$CHART_VERSION
```
