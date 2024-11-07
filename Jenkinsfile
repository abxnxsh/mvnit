pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = "myapp:latest"  // Docker image name
        //REGISTRY = "your-docker-registry"  // If using a registry like DockerHub or private registry
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout code from Git
                checkout scm
            }
        }

        stage('Build with Maven') {
            steps {
                // Run Maven to build the application
                script {
                    def buildProfile = 'local'  // Default to local profile
                    if (env.BRANCH_NAME == 'staging') {
                        buildProfile = 'staging'  // Use staging profile for staging branch
                    } else if (env.BRANCH_NAME == 'master') {
                        buildProfile = 'production'  // Use production profile for main branch
                    }
                    
                    // Build the project with the correct profile
                    sh "mvn clean install -P${buildProfile} -DskipTests"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build the Docker image from the Dockerfile
                script {
                    // Make sure Docker is running and accessible
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }

        stage('Push Docker Image') {
            when {
                branch 'master'  // Push to Docker registry only for main branch
            }
            steps {
                echo "Skipping as we are omitting it for now"
                // script {
                //     // Login to Docker registry (replace with actual login steps)
                //     sh 'docker login -u $DOCKER_USER -p $DOCKER_PASSWORD'

                //     // Push the Docker image to the registry
                //     sh 'docker push ${DOCKER_IMAGE}'
                // }
            }
        }

        stage('Deploy to Staging') {
            when {
                branch 'staging'  // Only deploy to staging for the staging branch
            }
            steps {
                script {
                    // Deploy Docker container to a staging environment
                    sh 'docker run -d -p 8080:8080 ${DOCKER_IMAGE}'
                }
            }
        }

        stage('Deploy to Production') {
            when {
                branch 'master'  // Deploy to production for the main branch
            }
            steps {
                script {
                    // Deploy Docker container to a production environment
                    sh 'docker run -d -p 8080:8080 ${DOCKER_IMAGE}'
                }
            }
        }

        stage('Run Tests') {
            steps {
                // Run automated tests to verify the deployment
                script {
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
