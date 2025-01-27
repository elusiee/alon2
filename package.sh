#!/bin/sh
VERSION=$11.0.0
if [ -x ${VERSION} ];
then
	echo VERSION not defined
	exit 1
fi
APPLICATION="alon"
PACKAGE=${APPLICATION}-client-${VERSION}.zip
echo PACKAGE="${PACKAGE}"

FILES="changelogs classes conf html lib src resource addons"
FILES="${FILES} ${APPLICATION}.jar ${APPLICATION}service.jar"
FILES="${FILES} 3RD-PARTY-LICENSES.txt AUTHORS.txt LICENSE.txt JPL-NRS.pdf"
FILES="${FILES} DEVELOPERS-GUIDE.md OPERATORS-GUIDE.md README.md README.txt USERS-GUIDE.md"
FILES="${FILES} mint.bat mint.sh run.bat run.sh run-tor.sh run-desktop.sh start.sh stop.sh compact.sh compact.bat sign.sh sign.bat passphraseRecovery.sh passphraseRecovery.bat"
FILES="${FILES} nxt.policy nxtdesktop.policy Wallet.url"
FILES="${FILES} compile.sh javadoc.sh jar.sh package.sh"

echo compile
./compile.sh
echo jar
./jar.sh
echo javadoc
rm -rf html/doc/*
./javadoc.sh

rm -rf ${APPLICATION}
rm -rf ${PACKAGE}
mkdir -p ${APPLICATION}/
mkdir -p ${APPLICATION}/logs
echo copy resources
cp -a ${FILES} ${APPLICATION}
echo gzip
for f in `find ${APPLICATION}/html -name *.gz`
do
	rm -f "$f"
done
for f in `find ${APPLICATION}/html -name *.html -o -name *.js -o -name *.css -o -name *.json -o -name *.ttf -o -name *.svg -o -name *.otf`
do
	gzip -9c "$f" > "$f".gz
done
echo zip
zip -q -X -r ${PACKAGE} ${APPLICATION} -x \*/.idea/\* \*/.gitignore \*/.git/\* \*/\*.log \*.iml ${APPLICATION}/conf/nxt.properties ${APPLICATION}/conf/logging.properties ${APPLICATION}/conf/localstorage/\*
rm -rf ${APPLICATION}
echo done
