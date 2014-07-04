#!/bin/bash
URL="file:///home/$USER/.m2/repository"

# This script extracts the necessary libraries from the ditributable

DISTRO=$1
if [ "x$DISTRO" == "x" ]; then
  echo "Please pass distro zip as a parameter, ie:"
  echo "  maven-install-drools5.sh brms-p-5.3.1.GA-deployable.zip"
  exit
fi

binaryVersion=$(echo $DISTRO | grep -oE "([0-9]{1}\.)*GA" | sed "s/GA/BRMS/")

rm -rf tmp
unzip $DISTRO -d tmp
unzip tmp/jboss-brms-engine.zip -d tmp
unzip tmp/jboss-brms-manager.zip -d tmp
unzip tmp/jboss-jbpm-engine.zip jbpm-bpmn2-5.3.1.BRMS.jar -d tmp/binaries
cd tmp/jboss-brms.war
# change the auth method so it accepts any user/password
sed -i.bak1 s/jaas\-config\-name=\"jmx\-console\"//g WEB-INF/components.xml
sed -i.bak2 s/authenticator\.authenticate/defaultAuthenticator\.authenticate/g WEB-INF/components.xml
zip -r ../binaries/jboss-brms-$binaryVersion.war *
cd -
cd tmp/binaries



# This script installs the necessary libraries from the drools runtime into a maven repo

FILES=$(find . -name "*BRMS*.[w|j]ar")
echo -e "\nInstalling the following files:"
for filename in $FILES
do
  echo "  $filename"
done
echo ""

for filename in $FILES
do
  brmsVersion=$(echo $filename | grep -oE "([0-9]{1}\.)*BRMS")
  artifactId=$(echo $filename | grep -oE ".*/(.*)-" | sed "s/\.\///")
  packaging=$(echo $filename | grep -oE "(.ar)$")
#  mvn deploy:deploy-file -Dfile=$filename -DgroupId=org.drools -DartifactId=${artifactId%?} -Dversion=$brmsVersion -Dpackaging=$packaging -DgeneratePom=true -DcreateChecksum=true -Durl=$URL
  mvn deploy:deploy-file -Dfile=$filename -DgroupId=org.drools -DartifactId=${artifactId%?} -Dversion=$binaryVersion -Dpackaging=$packaging -DgeneratePom=true -DcreateChecksum=true -Durl=$URL
done

ECJ=*ecj*
for filename in $ECJ
do
  ecjVersion=$(echo $filename | grep -oE "([0-9]{1})\.([0-9]{1})\.([0-9]{1})")
#  mvn deploy:deploy-file -Dfile=$filename -DgroupId=org.eclipse.jdt.core.compiler -DartifactId=ecj -Dversion=$ecjVersion -Dpackaging=jar -DgeneratePom=true -DcreateChecksum=true -Durl=$URL
  mvn deploy:deploy-file -Dfile=$filename -DgroupId=org.eclipse.jdt.core.compiler -DartifactId=ecj -Dversion=$binaryVersion -Dpackaging=jar -DgeneratePom=true -DcreateChecksum=true -Durl=$URL
done

MVEL=*mvel2*
for filename in $MVEL
do
  mvelVersion=$(echo $filename | grep -oE "([0-9]{1})\.([0-9]{1})\.([0-9]{1}).([A-Za-z])*([0-9])*")
#  mvn deploy:deploy-file -Dfile=$filename -DgroupId=org.mvel -DartifactId=mvel2 -Dversion=$mvelVersion -Dpackaging=jar -DgeneratePom=true -DcreateChecksum=true -Durl=$URL
  mvn deploy:deploy-file -Dfile=$filename -DgroupId=org.mvel -DartifactId=mvel2 -Dversion=$binaryVersion -Dpackaging=jar -DgeneratePom=true -DcreateChecksum=true -Durl=$URL
done

ANTLR=*antlr-runtime*
for filename in $ANTLR
do 
  antlrVersion=$(echo $filename | grep -oE "([0-9]{1})\.([0-9]{1})")
#  mvn deploy:deploy-file -Dfile=$filename -DgroupId=org.antlr -DartifactId=antlr-runtime -Dversion=$antlrVersion -Dpackaging=jar -DgeneratePom=true -DcreateChecksum=true -Durl=$URL
  mvn deploy:deploy-file -Dfile=$filename -DgroupId=org.antlr -DartifactId=antlr-runtime -Dversion=$binaryVersion -Dpackaging=jar -DgeneratePom=true -DcreateChecksum=true -Durl=$URL
done

JXL=*jxl*
for filename in $JXL
do 
  jxlVersion=$(echo $filename | grep -oE "([0-9]{1})\.([0-9]{1})\.([0-9]{1})")
#  mvn deploy:deploy-file -Dfile=$filename -DgroupId=jxl -DartifactId=jxl -Dversion=$jxlVersion -Dpackaging=jar -DgeneratePom=true -DcreateChecksum=true -Durl=$URL
  mvn deploy:deploy-file -Dfile=$filename -DgroupId=jxl -DartifactId=jxl -Dversion=$binaryVersion -Dpackaging=jar -DgeneratePom=true -DcreateChecksum=true -Durl=$URL
done

cd -
