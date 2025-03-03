# Important to remember, always add the < /dev/null
# to every Jenkins CLI execution. Depending of the
# connection mode used, the CLI consumes all the
# STDIN, causing any outer loops (in caller scripts)
# to stop silently. This was discovered @ MDLSITE-5313
# and we need to keep it (until we move to REST from CLI)

# We want to launch always a sqlsrv PHPUNIT
echo -n "PHPUnit (sqlsrv): " >> "${resultfile}.jenkinscli"
${jenkinsreq} "DEV.02 - Developer-requested PHPUnit" \
    -p REPOSITORY=${repository} \
    -p BRANCH=${branch} \
    -p DATABASE=sqlsrv \
    -p PHPVERSION=${php_version} \
    -w >> "${resultfile}.jenkinscli" < /dev/null

# We want to launch always a Behat (goutte) job
echo -n "Behat (goutte - boost and classic): " >> "${resultfile}.jenkinscli"
${jenkinsreq} "DEV.01 - Developer-requested Behat" \
    -p REPOSITORY=${repository} \
    -p BRANCH=${branch} \
    -p DATABASE=pgsql \
    -p PHPVERSION=${php_version} \
    -p BROWSER=goutte \
    -p BEHAT_SUITE=ALL \
    -w >> "${resultfile}.jenkinscli" < /dev/null

# We want to launch always a Behat (firefox - boost) job
echo -n "Behat (firefox - boost): " >> "${resultfile}.jenkinscli"
${jenkinsreq} "DEV.01 - Developer-requested Behat" \
    -p REPOSITORY=${repository} \
    -p BRANCH=${branch} \
    -p DATABASE=pgsql \
    -p PHPVERSION=${php_version} \
    -p BROWSER=firefox \
    -w >> "${resultfile}.jenkinscli" < /dev/null

# We want to launch a Behat (firefox - classic) job
# only if the target branch is master.
if [[ ${target} == "master" ]]; then
    echo -n "Behat (firefox - classic): " >> "${resultfile}.jenkinscli"
    ${jenkinsreq} "DEV.01 - Developer-requested Behat" \
        -p REPOSITORY=${repository} \
        -p BRANCH=${branch} \
        -p DATABASE=pgsql \
        -p PHPVERSION=${php_version} \
        -p BROWSER=firefox \
        -p BEHAT_SUITE=classic \
        -w >> "${resultfile}.jenkinscli" < /dev/null
fi

# We want to launch a Behat (latest-test, @app only) job
# only if the target branch is master.
if [[ ${target} == "master" ]]; then
    echo -n "App tests (stable app version): " >> "${resultfile}.jenkinscli"
    ${jenkinsreq} "DEV.01 - Developer-requested Behat" \
        -p REPOSITORY=${repository} \
        -p BRANCH=${branch} \
        -p DATABASE=pgsql \
        -p PHPVERSION=${php_version} \
        -p BROWSER=chrome \
        -p BEHAT_INCREASE_TIMEOUT=4 \
        -p MOBILE_VERSION=latest-test \
        -p INSTALL_PLUGINAPP=ci \
        -p TAGS="@app&&~@performance&&~@local_behatsnapshots&&~@ci_jenkins_skip" \
        -w >> "${resultfile}.jenkinscli" < /dev/null
fi
