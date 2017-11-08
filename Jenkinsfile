node('master'){
  stage('Pull aws infra repo') {
    /* Pull aws infrastructure builder repo */

     git url: 'https://github.com/cchen1103/aws.git'

  }
  stage('Show build plan') {
    /* Show terraform build plan */

    sh('terraform plan')
  }

}
