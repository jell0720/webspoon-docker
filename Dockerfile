FROM tomcat:jre8
MAINTAINER Hiromu Hota <hiromu.hota@hal.hitachi.com>
ENV JAVA_OPTS="-Xms1024m -Xmx2048m"
RUN rm /etc/java-8-openjdk/accessibility.properties
RUN rm -rf ${CATALINA_HOME}/webapps/* \
    && mkdir ${CATALINA_HOME}/webapps/ROOT \
    && echo "<% response.sendRedirect(\"spoon\"); %>" > ${CATALINA_HOME}/webapps/ROOT/index.jsp

ARG base=8.0
ARG patch=16
ARG version=0.$base.$patch
ARG dist=8.0.0.0-28
RUN wget https://github.com/HiromuHota/pentaho-kettle/releases/download/webspoon%2F$version/spoon.war \
    && mkdir ${CATALINA_HOME}/webapps/spoon \
    && unzip -q spoon.war -d ${CATALINA_HOME}/webapps/spoon \
    && rm spoon.war

ADD https://github.com/HiromuHota/pentaho-kettle/releases/download/webspoon%2F$version/webspoon-security-$dist-$patch.jar ${CATALINA_HOME}/lib/
RUN echo "CLASSPATH="$CATALINA_HOME"/lib/webspoon-security-$dist-$patch.jar" | tee ${CATALINA_HOME}/bin/setenv.sh
COPY catalina.policy ${CATALINA_HOME}/conf/
RUN mkdir -p $HOME/.kettle/users && mkdir -p $HOME/.pentaho/users
