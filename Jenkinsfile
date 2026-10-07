pipeline {
  agent any
  environment {
    ACR_NAME    = 'acrdemoa8187c8a'
    IMAGE       = "${ACR_NAME}.azurecr.io/demo"
    SONAR_TOKEN = credentials('sonar-token')
  }
  stages {
    stage('Build & tests') {
      steps { sh 'mvn -B clean verify' }
      post { always { junit allowEmptyResults: true, testResults: 'target/surefire-reports/*.xml' } }
    }
    stage('SCA - Trivy') {
      steps {
        sh 'trivy fs --scanners vuln --severity HIGH,CRITICAL --skip-dirs target --exit-code 0 -o trivy-sca.txt .'
        archiveArtifacts artifacts: 'trivy-sca.txt'
      }
    }
    stage('SAST - SonarQube') {
      steps {
        sh '''mvn -B org.sonarsource.scanner.maven:sonar-maven-plugin:sonar \
          -Dsonar.host.url=http://10.20.1.5:9000 \
          -Dsonar.projectKey=demo-azure \
          -Dsonar.qualitygate.wait=true'''
      }
    }
    stage('Image Docker') {
      steps {
        script { env.TAG = "${env.BUILD_NUMBER}-" + sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim() }
        sh '''az login --identity --output none
          az acr login --name $ACR_NAME
          docker build -t $IMAGE:$TAG .
          docker push $IMAGE:$TAG'''
      }
    }
    stage('Deploiement AKS (Helm)') {
      steps {
        sh '''az aks get-credentials -g rg-demo -n aks-demo --overwrite-existing
          helm upgrade --install demo helm/demo -n demo --create-namespace \
            --set image.repository=$IMAGE --set image.tag=$TAG --atomic --timeout 5m'''
      }
    }
    stage('Smoke test') {
      steps {
        sh '''for i in $(seq 1 30); do
            IP=$(kubectl -n demo get svc demo -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
            if [ -n "$IP" ]; then break; fi
            sleep 10
          done
          curl -fsS --max-time 10 --retry 15 --retry-delay 10 --retry-connrefused --retry-all-errors "http://$IP/hello?name=Jenkins"'''
      }
    }
  }
}
