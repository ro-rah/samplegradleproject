WORKSPACE=`pwd`
JOB_NAME="ronak_gradle_test"
BRANCH="main"
BUILD_NUMBER=`date -I date -I hours -I minutes -I seconds`

echo '************** GET SL AGENT **********'
wget -nv https://agents.sealights.co/sealights-java/sealights-java-latest.zip
unzip -oq sealights-java-latest.zip
echo '************** GENERATE TOKEN FILE **********'
echo 'eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL0RFVi1jcy5hdXRoLnNlYWxpZ2h0cy5pby8iLCJqd3RpZCI6IkRFVi1jcyxpLTBlOGE5MTJiYTE4YzI1ZTM2LEFQSUdXLWVjM2JhZjMyLTMyYTUtNDM2ZS04OTFkLWJlM2YyMTA4MGU2YSwxNjQ2MDQ4OTQ2MTcxIiwic3ViamVjdCI6IlNlYUxpZ2h0c0BhZ2VudCIsImF1ZGllbmNlIjpbImFnZW50cyJdLCJ4LXNsLXJvbGUiOiJhZ2VudCIsIngtc2wtc2VydmVyIjoiaHR0cHM6Ly9kZXYtY3MtZ3cuZGV2LnNlYWxpZ2h0cy5jby9hcGkiLCJzbF9pbXBlcl9zdWJqZWN0IjoiIiwiaWF0IjoxNjQ2MDQ4OTQ2fQ.dNWaFbLRWMmJ1TNRslDpO5GSOEuCwU60Sm1yByl83f9q0_b5W-E5dsEinV5UFJ9K3xwuvWZAwIAG0ASEZAdNBkx7ytqI20_y2aR3ab_MxTlk6aRHPbh1EtrQpC5SpMygdCyJ2vMls4gDQQJALyOr2ECz-IvbjsGP4cGV_Swcf9v-PGN-VyM7QaGVgMU3qBbWmJ2h4uzMqb2n2M9ziTaYoc_p_AQGrknQUms4DtZV4osJvf71OEoRU8EDdGzfnY2-LF2rxnJEjxWzQNTqBFpe6reECPlBzu-d1Chp_jcCGaFtq7wRbJHqy5VuFq6damOihlIQrCeAJd8OYbXTX3bLnodpZm3kOWQ93aLneie5kuW2aPi-1WO0U5D8emTTRZ07d9EodVZLKjN3ATVHYG4pp0mdh74jK2-HlKL7gBWKaqy3vHwzfLo67Da8OtAnakWC2jaCKCtkF8VkBiHEE60rhIaxg3RBE65rJ4gN7dtzXa3eq4fMWxRctG5Mw4ZGOQaOtEbrKOUmb8V1r3cyGfDPjWDGiEgF2lvP1lxCkpcyUd3E7xOPVMdPmqFunc_YFXiBEiFECDAhgEY2zqnLAkpRu5W483CDB6yE6T49gKhH-mM96Nxkxpu6Snd80-Xjb19Wpawo1diXRV79y_mBtf2ZfkpySLSfG-nINBiLsXTDwUM' > sltoken.txt
#echo '************** GENERATE SESSION ID **********'
#java -jar sl-build-scanner.jar -config -tokenfile ${WORKSPACE}/sltoken.txt -appname $JOB_NAME -branchname $BRANCH -buildname $BUILD_NUMBER -pi "com.khartec.*" 


#update the java process maven is starting to include the test listener java options

echo '************** SCAN BUILD **********'
echo '{
  "tokenFile": "'${WORKSPACE}'/sltoken.txt",
  "createBuildSessionId": true,
  "appName": "'${JOB_NAME}'",
  "branchName": "'${BRANCH}'",
  "buildName": "SL_Timestamp",
  "packagesIncluded": "*com.khartec.waltz.*",
  "includeResources": true,
  "executionType": "full",
  "testStage": "Unit Tests",
  "logLevel": "info",
  "sealightsJvmParams": {
    "sl.featuresData.enableLineCoverage": "true"
  },
  "failsafeArgLine": "@{sealightsArgLine} -Dsl.testStage=\"Integration Tests\""
}' > slgradle.json
java -jar sl-build-scanner.jar -gradle -configfile slgradle.json -workspacepath "."
#java -jar sl-build-scanner.jar -scan -tokenfile sltoken.txt -buildsessionidfile buildSessionId.txt -workspacepath "." -r

echo '*************** BUILD ****************'
#mvn -Dmaven.test.failure.ignore=true clean install -P waltz-mariadb,dev-maria
#java -jar sl-build-scanner.jar -restore -workspacepath "."

#If I were to break up the test stage section:
#Start test stage (here I will define the testStage)
#Run tests
#mvn test
#End test session
