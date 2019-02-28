pipeline {
  agent none
  stages {
    stage('Hello') {
      steps {
        echo 'Hello World!'
      }
    }
    stage('shellcheck') {
      steps {
        sh 'shellcheck ./script/log4.sh'
        sh 'shellcheck ./template4.sh'
      }
    }
  }
}