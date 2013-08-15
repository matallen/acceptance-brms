acceptance-brms
===============



install the "brms-bulk-importer" from https://github.com/matallen/maven-guvnor-bulk-importer

install the "maven-guvnor-uploader-plugin" from http://github.com/matallen/maven-guvnor-uploader-plugin


# Structure
rule-domain      - this is where any model classes go that as used in the rules
business-rules   - In src/main/resources/rules is where you write your rules, and write unit tests in src/test/java as usual.
                   This module contains a RuleTestBase which provides easy rule compilation and execution helper methods
                   This module also contains a RulePackageDownloader which means the interface to download rule packages remains the same
                     whether in test or a production environment.
                   The bulk importer plugin generates a guvnor-import.xml in target/classes and the artifact jar (so its versioned thru maven) which can be imported into a clean Guvnor instance
                     and will be used in the acceptance testing.
acceptance       - this module contains Cucumber BDD acceptance test statements and a test implementation to get you started.


# to build the project
mvn clean install

# to run acceptance for CI (ie. start containers, deploy apps, run tests and stop containers)
acceptance/mvn clean install -Pbrms,itest -o

# to develop (ie. start containers, deploy apps and pause so a dev can develop tests against the containers)
acceptance/mvn clean package cargo:run -o

head pom.xml - gives you the two commands to copy/paste quickly


# To add more webapps to the acceptance tests
in the cargo plugin config, add a <deployable> entry for your webapps maven GAV (groupId, artifactId and version) and it will be deployed


# To change the container to a JBoss AS
in the cargo plugin config, change the <containerId> to jboss5x (for example)

