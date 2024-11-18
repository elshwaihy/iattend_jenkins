def sendEmailNotification() {
    def jobName = env.JOB_NAME 
    def buildNumber = env.BUILD_NUMBER 
    def pipelineStatus = currentBuild.result ?: 'UNKNOWN' 
    def bannerColor = pipelineStatus.toUpperCase() == 'SUCCESS' ? 'green' : 'red'
    def body = 
    """ 
        <html> 
        <body> 
        <div style="border: 4px solid ${bannerColor}; padding: 10px;"> 
        <h2>${jobName} - Build ${buildNumber}</h2> 
        <div style="background-color: ${bannerColor}; padding: 10px;"> 
        <h3 style="color: white;">Pipeline Status: ${pipelineStatus.toUpperCase()}</h3> 
        </div> 
        <p>Check the <a href="${env.BUILD_URL}">console output</a>.</p> 
        </div> 
        </body> 
        </html> 
    """
        emailext ( 
            subject: "${jobName} - Build ${buildNumber} - ${pipelineStatus.toUpperCase()}", 
            body: body, 
            to: 'melshwaihy@gmail.com', 
            from: 'jenkins@example.com', 
            replyTo: 'jenkins@example.com', 
            mimeType: 'text/html' ) 
}

return this