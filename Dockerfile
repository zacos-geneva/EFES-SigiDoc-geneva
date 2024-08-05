FROM eclipse-temurin:11-jre-alpine


COPY . /sigidoc
WORKDIR /sigidoc

RUN ["apk", "--no-cache", "add", "bash"]

RUN ["chmod", "+x", "build.sh"]
RUN ["chmod", "+x", "sw/ant/bin/ant"]
RUN ["chmod", "+x", "scripts/create-kiln.sh"]
RUN ["chmod", "+x", "scripts/harvest-rdfs.sh"]
RUN ["chmod", "+x", "scripts/index-all.sh"]


CMD ["./build.sh"]
