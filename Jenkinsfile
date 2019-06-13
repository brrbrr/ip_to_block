pipeline { 
    agent { 
                    docker { 
						image 'myhttpie2' 
                        args '--mount source=bbcorp-devops,target=/root/data -u 0:0'
                    }
    } 
    options {
        skipStagesAfterUnstable()
        disableConcurrentBuilds()
    }
    environment {
         // Assumes you have defined a Jenkins environment variable 'PATH+EXTRA'
        PROJ = "/bin:/usr/local/bin:/usr/bin"
        // Name of CSV file containing network list
        NLFILE = "list.csv"
        // Name of network list to update
        NLNAME = "bbcorp_IP_block"
        // Link to VCS project containing network list
        NLSCM = "https://github.com/brrbrr/ip_to_block.git"
        // Comma-seperated e-mail list
        NLEMAIL = "admin@bbcorp.com"
        // Path to python project, if NL pipeline script are not in PATH
        NLPATH = "/root/data"
    }
    parameters {
        choice(name: 'NETWORK', choices: ['staging', 'production'], description: 'The network to activate the network list.')
        choice(name: 'ACTION', choices: ['append', 'overwrite'], description: 'Append to or overwrite the target list based on the supplied file contents.')
    }
    stages {
     stage('Clone NL project') {
            steps {
                git "${env.NLSCM}"
                archiveArtifacts "${env.NLFILE}"
                echo "${env.JOB_NAME} - Pulling updated network list from SCM. List Name: ${env.NLNAME}"
            }
        }
        stage('Update Network List') {
            steps {
                step([  $class: 'CopyArtifact',
                        filter: '*.csv',
                        fingerprintArtifacts: true,
                        projectName: '${JOB_NAME}',
                        selector: [$class: 'SpecificBuildSelector', buildNumber: '${BUILD_NUMBER}']
                ])
                withEnv(["PATH+EXTRA=$PROJ"]) {
                    sh 'python3 $NLPATH/updateNetworkList.py $NLNAME --file $NLFILE --action ${ACTION}'
                }
                echo "${env.JOB_NAME} - Updating network list ${env.NLNAME}"
            }
        }
        stage('Activate Network List'){
            steps {
                echo "${env.JOB_NAME} - Activating network list on ${env.NETWORK}"
                withEnv(["PATH+EXTRA=$PROJ"]) {
                    sh 'python3 $NLPATH/activateNetworkList.py $NLNAME --network ${NETWORK} --email $NLEMAIL'
                }
                echo "${env.JOB_NAME} - Network list activated!"
            }
        }
    }
    post {
        success {
            echo "${env.JOB_NAME} - Network List updated successfully."
        }
        failure {
            echo "${env.JOB_NAME} - Network List update failed!"
        }
    }
}
