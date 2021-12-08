# k8s-serverless-demo Project

This project uses Quarkus, the Supersonic Subatomic Java Framework.

If you want to learn more about Quarkus, please visit its website: https://quarkus.io/ .

## How To: Start k3s-cluster and serverless demo

You can create an initial k3s cluster for testing with the included scripts under k3s-cluster. These should also work under linux.
At first, you have to install Multipass ([multipass](https://multipass.run/))

1. Crate intial cluster with

```bash
chmod +x k3s-cluster/*
cd k3s-cluster && ./addCluster demo 1 1 && cd ..
```

Per default the cube.config will be wirtten to the folder ~/.kube/config. Existing configs will be overridden.
2. get and rename cube config
```bash
./k3s-cluster/getKubeconfig demo && mv $HOME/.kube/config $HOME/.kube/config-serverless-demo
```

3. Install knative

```bash
chmod +x k8s/knative/knative_install.sh
cd k8s/knative && ./knative_install.sh && cd ../..
```

Check if the endpoints are successfully bound with

```bash
kubectl --kubeconfig=$HOME/.kube/config-serverless-demo --namespace kourier-system get service kourier
```

The output should look like this:

```http request
NAME      TYPE           CLUSTER-IP     EXTERNAL-IP                 PORT(S)                      AGE
kourier   LoadBalancer   10.43.20.145   192.168.64.7,192.168.64.8   80:31145/TCP,443:32158/TCP   45s
```

4. Build quarkus app container image

```bash
./mvnw clean package -Pnative -Dquarkus.native.container-build=true -Dquarkus.container-image.build=true -Dquarkus.native.container-runtime=docker
```
5. Copy docker imges into cluster or push to private registry

```bash
chmod +x k3s-cluster/push_docker_image_to_cluster.sh
./k3s-cluster/push_docker_image_to_cluster.sh
```

6. Deploy serverless demo
```bash
chmod +x k8s/deploy_serverless_demo.sh
cd k8s && ./deploy_serverless_demo.sh && cd .. 
```

7. Get local IP of your cluster master

```bash
multipass info k3s-demo-master-0
```

8. add IP with hostname in /etc/hosts file
```bash
echo "192.168.64.7 serverless-demo.serverless.example.com" >> /etc/hosts
```

Now you can send a get request to the service:

```http request
http://serverless-demo.serverless.example.com/hello
```

To send massive load to the cluster. You could a tool like [hey](https://github.com/rakyll/hey)

```bash
hey -z 30s -c 50 "http://serverless-demo.serverless.example.com/json"
```

With increasing the load. You can watch the increasing number of pods inside the cluster.

```bash
kubectl get pods -w -n serverless --kubeconfig=$HOME/.kube/config-serverless-demo
```

## Stop or Purg the cluster

```bash
./k3s-cluster/purgeCluster demo
```


```bash
./k3s-cluster/stopCluster demo
```

## Running the application in dev mode

You can run your application in dev mode that enables live coding using:

```shell script
./mvnw compile quarkus:dev
```

> **_NOTE:_**  Quarkus now ships with a Dev UI, which is available in dev mode only at http://localhost:8080/q/dev/.

## Packaging and running the application

The application can be packaged using:

```shell script
./mvnw package
```

It produces the `quarkus-run.jar` file in the `target/quarkus-app/` directory. Be aware that it’s not an _über-jar_ as the dependencies are
copied into the `target/quarkus-app/lib/` directory.

The application is now runnable using `java -jar target/quarkus-app/quarkus-run.jar`.

If you want to build an _über-jar_, execute the following command:

```shell script
./mvnw package -Dquarkus.package.type=uber-jar
```

The application, packaged as an _über-jar_, is now runnable using `java -jar target/*-runner.jar`.

## Creating a native executable

You can create a native executable using:

```shell script
./mvnw package -Pnative
```

Or, if you don't have GraalVM installed, you can run the native executable build in a container using:

```shell script
./mvnw package -Pnative -Dquarkus.native.container-build=true
```

You can then execute your native executable with: `./target/k8s-serverless-demo-1.0-SNAPSHOT-runner`

If you want to learn more about building native executables, please consult https://quarkus.io/guides/maven-tooling.html.

## Related Guides

- YAML Configuration ([guide](https://quarkus.io/guides/config#yaml)): Use YAML to configure your Quarkus application
- RESTEasy JAX-RS ([guide](https://quarkus.io/guides/rest-json)): REST endpoint framework implementing JAX-RS and more

## Provided Code

### YAML Config

Configure your application with YAML

[Related guide section...](https://quarkus.io/guides/config-reference#configuration-examples)

The Quarkus application configuration is located in `src/main/resources/application.yml`.

### RESTEasy JAX-RS

Easily start your RESTful Web Services

[Related guide section...](https://quarkus.io/guides/getting-started#the-jax-rs-resources)
