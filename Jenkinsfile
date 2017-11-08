node('master'){
  stage('Pull aws infra repo') {
    /* Pull aws infrastructure builder repo */

    dir('tf') {

      git url: 'https://github.com/cchen1103/aws.git'

     }
  }
  stage('Show build plan') {
    /* Show terraform build plan */

    docker.image('alpine').inside('--user=root -v ./tf:/tf'){

      sh 'apk --update add terraform'
      sh 'terraform plan /tf'
      
    }
  }

}
