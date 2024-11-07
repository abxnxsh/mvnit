pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = "myapp:latest"  // Docker image name
        // You can skip Docker Hub push for now, so no registry variables
    }

    stages {


        stage('Checkout') {
            steps {
                // Checkout the code from Git
                checkout scm
            }
        }
        stage('Check Branch') {
            steps {
                script {
                    // Print the branch name to the Jenkins console log
                    echo "Current branch is: ${env.BRANCH_NAME}"
                    echo "Current branch is: ${env.BRANCH_NAME}"
                    echo "Current branch is: ${env.BRANCH_NAME}"
                }
            }
        }

        stage('Build with Maven') {
            steps {
                // Build the application with Maven inside Docker
                script {
                    def buildProfile = 'local'  // Default to 'local' profile
                    if (env.BRANCH_NAME == 'staging') {
                        buildProfile = 'staging'  // Use staging profile for staging branch
                    } else if (env.BRANCH_NAME == 'master') {
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
                branch 'staging'  // Only deploy to staging for the staging branch
            }
            steps {
                script {
                    // Deploy Docker container to a staging environment
                    echo "Deploying to Staging"
                    // Run Docker container on a staging environment (using port 8081 for staging, for example)
                    sh 'docker run -d -p 8081:8080 ${DOCKER_IMAGE}'
                }
            }
        }

        stage('Deploy to Production') {
            when {
                branch 'master'  // Only deploy to production for the master branch
            }
            steps {
                script {
                    // Deploy Docker container to a production environment
                    echo "Deploying to Production"
                    // Run Docker container on a production environment (using port 8080 for production, for example)
                    sh 'docker run -d -p 8082:8080 ${DOCKER_IMAGE}'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Run tests to verify the deployment
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
