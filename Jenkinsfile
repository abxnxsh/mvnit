pipeline {
    agent any

    parameters {
        // String parameter to input the branch name manually
        string(name: 'BRANCH_NAME', defaultValue: 'master', description: 'Branch to build')
    }

    environment {
        DOCKER_IMAGE = "myapp:latest"  // Docker image name
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Checkout the specified branch based on the parameter
                    echo "Checking out branch: ${params.BRANCH_NAME}"
                    checkout([$class: 'GitSCM', branches: [[name: "*/${params.BRANCH_NAME}"]], 
                             userRemoteConfigs: [[url: 'https://github.com/abxnxsh/mvnit.git']]])
                }
            }
        }

        stage('Git Info') {
            steps {
                script {
                    // Confirm the checked-out branch
                    echo "Current branch is: ${params.BRANCH_NAME}" // Should show the branch specified in the parameter
                }
            }
        }

        stage('Build with Maven') {
            steps {
                script {
                    def buildProfile = 'local'  // Default to 'local' profile
                    if (params.BRANCH_NAME == 'staging') {
                        buildProfile = 'staging'  // Use staging profile for staging branch
                    } else if (params.BRANCH_NAME == 'master') {
                        buildProfile = 'production'  // Use production profile for master branch
                    }

                    // Build the project with the specified profile
                    echo "Building the application with Maven - Profile: ${buildProfile}"
                    sh "docker build --build-arg BUILD_PROFILE=${buildProfile} -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Deploy to Staging') {
            when {
                expression { params.BRANCH_NAME == 'staging' }  // Only deploy to staging for the staging branch
            }
            steps {
                script {
                    echo "Deploying to Staging"
                    sh 'docker run -d -p 8081:8080 ${DOCKER_IMAGE}'
                }
            }
        }

        stage('Deploy to Production') {
            when {
                expression { params.BRANCH_NAME == 'master' }  // Only deploy to production for the master branch
            }
            steps {
                script {
                    echo "Deploying to Production"
                    sh 'docker run -d -p 8082:8080 ${DOCKER_IMAGE}'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    echo "Running tests after deployment"
                    sh 'mvn test'  // Modify if needed for your test suite
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Please check the logs.'
        }
    }
}
