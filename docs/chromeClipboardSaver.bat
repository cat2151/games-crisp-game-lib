@powershell -NoProfile -ExecutionPolicy Unrestricted "$s=[scriptblock]::create((gc \"%~f0\"|?{$_.readcount -gt 1})-join\"`n\");&$s" %*&goto:eof
#↑ps1として編集するときは、この行を#でコメントアウトし、拡張子をps1にする

# chromeクリップボードsaver
# クリップボードが変化し、かつ、アクティブウィンドウ.Name が $target（デフォルトはchrome） の場合、
#   指定したファイルにセーブします
# 用途の例
#   GitHubのMarkdownで書かれたサンプルコードのコードブロックが大量にあるとき、
#   それぞれの右上のコピーボタンをクリックしてゆくだけで
#   サンプルコードをどんどん実行していける。
#   そうするには、当ツールを起動して「npm run watch_games等で更新監視中のmain.js等」を指定すればよい。

# 設定
$target = "chrome"

# ファイル選択ダイアログを開く
Add-Type -AssemblyName PresentationFramework
function openFileDialog($title) {
    $dlg = New-Object Microsoft.Win32.OpenFileDialog -Property @{ 
        InitialDirectory = Get-Location
        #Filter = ''
        Title = $title
    }
    if ($dlg.ShowDialog()) {
        $dlg.FileName
    } else {
        exit
    }
}

# バックアップファイルを作成する
function backup($backupSource) {
    $todayTime = Get-Date -Format "yyyyMMdd_HHmmss"
    Copy-Item -Path $backupSource -Destination "$backupSource.$todayTime"
}

# アクティブプロセスを得る
function getActiveProcessInformation() {
$code = @'
    [DllImport("user32.dll")]
     public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")]
    public static extern IntPtr GetWindowThreadProcessId(IntPtr hWnd, out int ProcessId);
'@

    Add-Type $code -Name Utils -Namespace Win32
    $myPid = [IntPtr]::Zero;
    $hwnd = [Win32.Utils]::GetForegroundWindow()
    $null = [Win32.Utils]::GetWindowThreadProcessId($hwnd, [ref] $myPid)
    return (Get-Process | Where-Object ID -eq $myPid | Select-Object Name,processName,Id,Path,MainWindowTitle)
}

# クリップボードを監視する
function monitorClipboardText() {
    (Get-Host).UI.RawUI.WindowTitle = $MyInvocation.MyCommand
    Add-Type -AssemblyName System.Windows.Forms
    $clipText = [Windows.Forms.Clipboard]::GetText()
    while ($true) {
        $latestClipText = [Windows.Forms.Clipboard]::GetText()
        if ($latestClipText -ne $clipText) {
            $clipText = $latestClipText
            onChangeClipboardText
        }
        Start-Sleep -Milliseconds 16
    }
}

# クリップボードが変化した場合、 $filename にセーブする
function onChangeClipboardText() {
    $info = getActiveProcessInformation
    if ($info.Name -eq $target) {
        $clipText | Set-Content -Encoding UTF8 $filename # UTF8 with BOMになる。BOMなしを選ぶ場合は別の手を使うこと
        "---"
        "クリップボードをセーブしました：[" + $filename + "]"
        $clipText
    } else {
        "アクティブウィンドウのNameが [" + $target + "] の場合のみセーブします"
        "このアクティブウィンドウはクリップボードセーブの対象外です："
        $info
    }
}

#
$filename = openFileDialog "クリップボードセーブするファイルを選んでください"
"バックアップします：[" + $filename + "]"
backup $filename
"クリップボードを監視してセーブします：[" + $filename + "]"
monitorClipboardText
