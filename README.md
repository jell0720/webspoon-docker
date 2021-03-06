# How to build an image

## Without plugins

```
$ docker build -t hiromuhota/webspoon:latest .
```

## With plugins

```
$ docker build -f ./Dockerfile-base -t hiromuhota/webspoon:0.8.0-base .
$ docker build --no-cache -f ./Dockerfile-full -t hiromuhota/webspoon:latest-full .
```

# How to use the image

## Basic usage

### Without plugins

```
$ docker run -d -p 8080:8080 hiromuhota/webspoon:latest
```

### With plugins

```
$ docker run -d -p 8080:8080 hiromuhota/webspoon:latest-full
```

In either case, please access `http://ip-address:8080/spoon/spoon`.

## Advanced usage

### Java heap size

The Java heap size is configured as `-Xms1024m -Xmx2048m` by default, but can be overridden as `-Xms1024m -Xmx1920m` for example when a server has only 2GB of memory.

```
$ docker run -e JAVA_OPTS="-Xms1024m -Xmx1920m" -d -p 8080:8080 hiromuhota/webspoon:latest-full
```

### User config and data persistence/share

If the configuration files should be shared among containers, add `-v kettle:/root/.kettle -v pentaho:/root/.pentaho` as

```
$ docker run -d -p 8080:8080 -v kettle:/root/.kettle -v pentaho:/root/.pentaho hiromuhota/webspoon:latest-full
```

or execute the following docker-compose command

```
$ docker-compose up -d
```

### webSpoon config

From 0.8.0.14, spoon.war is pre-extracted at `$CATALINA_HOME/webapps/spoon` so that configs such as `web.xml` can be configured at run-time using a bind mount.
If you want to enable user authentication, for example, download [web.xml](https://github.com/HiromuHota/pentaho-kettle/blob/webspoon-8.0/assemblies/pdi-ce/src/main/resources-filtered/WEB-INF/web.xml) and edit it as described [here](https://github.com/HiromuHota/pentaho-kettle#user-authentication).
Then add `-v $(pwd)/web.xml:/usr/local/tomcat/webapps/spoon/WEB-INF/web.xml` to the command.

```
$ docker run -d -p 8080:8080 -v $(pwd)/web.xml:/usr/local/tomcat/webapps/spoon/WEB-INF/web.xml hiromuhota/webspoon:lastest-full
```

Similarly, `$CATALINA_HOME/webapps/spoon/WEB-INF/spring/security.xml` can be configured at run-time.

### Security manager

To enable the [custom security manager](https://github.com/HiromuHota/pentaho-kettle/wiki/Security#file-access-control-by-a-custom-security-manager-experimental), enable [user authentication
](https://github.com/HiromuHota/pentaho-kettle#user-authentication) and add `-e CATALINA_OPTS="-Djava.security.manager=org.pentaho.di.security.WebSpoonSecurityManager -Djava.security.policy=/usr/local/tomcat/conf/catalina.policy"` to the run command.

```
$ docker run -d -p 8080:8080 -e CATALINA_OPTS="-Djava.security.manager=org.pentaho.di.security.WebSpoonSecurityManager -Djava.security.policy=/usr/local/tomcat/conf/catalina.policy" -v $(pwd)/web.xml:/usr/local/tomcat/webapps/spoon/WEB-INF/web.xml hiromuhota/webspoon:latest-full
```

## Debug

```
$ docker run -e JAVA_OPTS="-Xms1024m -Xmx2048m" -e JPDA_ADDRESS=8000 -e CATALINA_OPTS="-Dorg.eclipse.rap.rwt.developmentMode=true" -d -p 8080:8080 -p 8000:8000 hiromuhota/webspoon:latest-full catalina.sh jpda run
```