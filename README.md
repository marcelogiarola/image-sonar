## Openshift

```shell
# com acesso a internet
$ oc import-image openjdk/openjdk-11-rhel7 --from=registry.redhat.io/openjdk/openjdk-11-rhel7 -n openshift --confirm

$ oc import-image postgresql:10 --from=registry.redhat.io/rhscl/postgresql-10-rhel7 -n openshift --confirm

$ oc new-app postgresql-persistent \
    --param POSTGRESQL_USER=sonar \
    --param POSTGRESQL_PASSWORD=sonar \
    --param POSTGRESQL_DATABASE=sonar \
    --param VOLUME_CAPACITY=10Gi \
    --param POSTGRESQL_VERSION=10 \
    --param DATABASE_SERVICE_NAME=postgresql-sonar \
    -l app=sonarqube

$ ./openshift-build.sh
    
$ oc new-app sonarqube-custom \
    -e SONARQUBE_JDBC_USERNAME=sonar \
    -e SONARQUBE_JDBC_PASSWORD=sonar \
    -e SONARQUBE_JDBC_URL=jdbc:postgresql://postgresql-sonar/sonar \
    -l app=sonarqube

$ oc expose service sonarqube-custom --port 9000
```

## Usuário default do SonarQube
 Por padrão o SonarQube cria um usuário administrador **admin** com senha **aadmin**

## Requisitos Instalação no HOST

 Ao iniciar a instalação do sonarqube (cuja referência é [customização do Oficial](https://hub.docker.com/_/sonarqube) para usar as imagens oficiais do RHEL-7) ocorreu o erro anexo e resumo a seguir:

- [1]: max virtual memory areas vm.max_map_count [65530] is too low, **increase to at least** [262144]

Ao avaliar nas [documentações](https://docs.sonarqube.org/latest/setup/upgrade-notes/) entende ser um **requisito** necessário aumentar o parâmetro (max_map_count) do HOSTS das máquinas que rodam CICD, que seriam as seguintes:

1. p0lvoc01s35.sfb
2. p0lvoc01s36.sfb
3. p0lvoc01s37.sfb

​     *Obs: estes HOSTS são os que rodam atualmente projetos do tipo CICD e foram identificado com o comando: oc get nodes --show-labels | grep cicd*



Entendemos que não há impacto imediato de maior consumo de memórias contudo presume que a aplicação quando necessitar fará mais uso de memória - como pode ser observado no link [What is the parameter "max_map_count" and does it affect the server performance?](https://access.redhat.com/solutions/99913)



Por fim o valor **padrão** deste parâmetro é (**65530**) para atualizar proceder conforme a documentação (https://docs.sonarqube.org/latest/requirements/requirements/) que inclusive relata sobre **requisitos mínimos**
