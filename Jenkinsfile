pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building....'
                echo 'Build done'
                echo 'Uploading artifact'
            }
        }
        stage('UI Tests') {
            steps {                
                script {

                    def newSandboxData = null

                    try {
                        //Start Sandbox
                        //TODO replace latest with current artifact from Build stage 
                        newSandboxData = colony.blueprint(
                            'promotions-manager',                      // space name
                            'promotions-manager-all-eks',              // blueprint name
                            'pm-ui-test-sandobx-' + env.BUILD_NUMBER,  // sandbox name
                            'PT2H',                                    // sandbox duration according to ISO 8601 duration
                            ['promotions-manager-ui': 'artifacts/latest/promotions-manager-ui.master.tar.gz', 
                               'promotions-manager-api': 'artifacts/latest/promotions-manager-api.master.tar.gz', 
                               'mongodb': 'artifacts/test-data/test-data-db.tar'],    // artifacts              
                            ['PORT': '3000', 'API_PORT': '3001', 'RELEASE_NUMBER': 'none', 'API_BUILD_NUMBER': 'none'],       // inputs
                            30)                                        // timeout
                            .startSandbox()

                        def endpoint = getEndpoint(newSandboxData)

                        echo 'Running UI tests against endpoint: ' + endpoint

                        // TBD - run tests
                    }
                    catch(Exception e) {
                         if (newSandboxData != null) {
                            colony.endSandbox('promotions-manager', newSandboxData.id)
                        }
                        print e.getClass().getName()
                        print e.message
                        throw e
                    }
                    finally {
                        if (newSandboxData != null) {
                            colony.endSandbox('promotions-manager', newSandboxData.id)
                        }
                    }
                }                
            }
        }
        stage('Integration Tests') {
            steps {                
                echo 'Running integration tests....'

                echo 'Done'
            }
        }
        stage('Load Tests') {
            steps {
                echo 'Running load tests....'

                echo 'Done'
            }
        }
        stage('Security Tests') {
            steps {
                echo 'Running security tests....'

                echo 'Done'
            }
        }
        stage('Backwards Compatibility Tests') {
            steps {
                echo 'Running tests....'

                echo 'Done'
            }
        }
        stage('Deploy Green') {
            steps {
                input "Deploy green?"

                echo 'Deploying new green....'
            }
        }
        stage('Cleanup Artifacts'){ 
            steps { 
                echo 'Cleaning artifacts from Artifacts Repo'
            }
        }
        stage('Expose Green') {
            steps {
                input "Expose green?"

                echo 'Exposing new green....'

                httpRequest customHeaders: [[maskValue: false, name: 'Authorization', value: 'Bearer cc621796736c3f47355a3a8eaa11430810a06dd10af6a974563edd1de736f9e2']], httpMode: 'PUT', ignoreSslErrors: true, responseHandle: 'NONE', url: 'https://colony-demo.cloudshellcolony.com/api/spaces/promotions-manager/production/1ooxv2mxtk00z6/green/exposure?value=100'
            }
        }
        stage('Promote Green') {
            steps {
                input "Promote green?"

                echo 'Promoting green enviorment....'
            }
        }
    }
}

// get the first application shortcut for the UI app
def getEndpoint(def newSandboxData) {
    
    def endpoint = ''

    for (app in newSandboxData.applications) {
        if (app.name == 'promotions-manager-ui') {
            endpoint = app.shortcuts[0]
            break
        }
    }

    if (endpoint == '') {
        throw new Exception('couldnt get application endpoint from sandbox details')
    }

    return endpoint
}