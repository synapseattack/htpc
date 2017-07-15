pipeline {
  agent any
  stages {
    stage('Email Start') {
      steps {
        mail(subject: 'BO email test', body: 'This is an email test from Blue Ocean', from: 'mad.dba@gmail.com', to: 'mad.dba@gmail.com')
      }
    }
  }
}