pipeline {
    agent  {
        label 'AGENT-1'
    }
    environment { 
        appVersion = ''
        REGION = "us-east-1"
        ACC_ID = "021891615305"
        PROJECT = "roboshop"
        COMPONENT = "catalogue"
        USERNAME = "acavinash"
    }
    options {
        timeout(time: 30, unit: 'MINUTES') 
        disableConcurrentBuilds()
    }
    // parameters {
    //     string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
    //     text(name: 'BIOGRAPHY', defaultValue: '', description: 'Enter some information about the person')
    //     booleanParam(name: 'TOGGLE', defaultValue: true, description: 'Toggle this value')
    //     choice(name: 'CHOICE', choices: ['One', 'Two', 'Three'], description: 'Pick something')
    //     password(name: 'PASSWORD', defaultValue: 'SECRET', description: 'Enter a password') 
    // }
    // Build
    stages {
        stage('Read package.json') {
            steps {
                script {
                    def packageJson = readJSON file: 'package.json'
                    appVersion = packageJson.version
                    echo "Package version: ${appVersion}"
                }
            }
        }
        stage('Install Dependencies') {
            steps {
                script {
                    sh """
                    npm install
                    """
                }
            }
        }

        stage('Unit Testing') {
            steps {
                script {
                    sh """
                    echo "unit tests"
                    """
                }
            }
        }
stage('Docker build') {
    steps {
        script {
            withAWS(credentials: 'aws-cred', region: 'us-east-1') {

                sh """
                # Login to ECR
                aws ecr get-login-password --region ${REGION} | docker login \
                --username AWS \
                --password-stdin ${ACC_ID}.dkr.ecr.${REGION}.amazonaws.com

                # Build Docker image
                docker build -t ${COMPONENT}:${appVersion} .

                # Tag Image
                docker tag ${COMPONENT}:${appVersion} \
                ${ACC_ID}.dkr.ecr.${REGION}.amazonaws.com/${COMPONENT}:${appVersion}

                # Push to ECR
                docker push ${ACC_ID}.dkr.ecr.${REGION}.amazonaws.com/${COMPONENT}:${appVersion}
                """
            }
        }
    }
}

        
    }

    post { 
        always { 
            echo 'I will always say Hello again!'
            deleteDir()
        }
        success { 
            echo 'Hello Success'
        }
        failure { 
            echo 'Hello Failure'
        }
    }
}