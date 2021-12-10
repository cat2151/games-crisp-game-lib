@powershell -NoProfile -ExecutionPolicy Unrestricted "$s=[scriptblock]::create((gc \"%~f0\"|?{$_.readcount -gt 1})-join\"`n\");&$s" %*&goto:eof
#��ps1�Ƃ��ĕҏW����Ƃ��́A���̍s��#�ŃR�����g�A�E�g���A�g���q��ps1�ɂ���

# chrome�N���b�v�{�[�hsaver
# �N���b�v�{�[�h���ω����A���A�A�N�e�B�u�E�B���h�E.Name �� $target�i�f�t�H���g��chrome�j �̏ꍇ�A
#   �w�肵���t�@�C���ɃZ�[�u���܂�
# �p�r�̗�
#   GitHub��Markdown�ŏ����ꂽ�T���v���R�[�h�̃R�[�h�u���b�N����ʂɂ���Ƃ��A
#   ���ꂼ��̉E��̃R�s�[�{�^�����N���b�N���Ă䂭������
#   �T���v���R�[�h���ǂ�ǂ���s���Ă�����B
#   ��������ɂ́A���c�[�����N�����āunpm run watch_games���ōX�V�Ď�����main.js���v���w�肷��΂悢�B

# �ݒ�
$target = "chrome"

# �t�@�C���I���_�C�A���O���J��
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

# �o�b�N�A�b�v�t�@�C�����쐬����
function backup($backupSource) {
    $todayTime = Get-Date -Format "yyyyMMdd_HHmmss"
    Copy-Item -Path $backupSource -Destination "$backupSource.$todayTime"
}

# �A�N�e�B�u�v���Z�X�𓾂�
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

# �N���b�v�{�[�h���Ď�����
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

# �N���b�v�{�[�h���ω������ꍇ�A $filename �ɃZ�[�u����
function onChangeClipboardText() {
    $info = getActiveProcessInformation
    if ($info.Name -eq $target) {
        $clipText | Set-Content -Encoding UTF8 $filename # UTF8 with BOM�ɂȂ�BBOM�Ȃ���I�ԏꍇ�͕ʂ̎���g������
        "---"
        "�N���b�v�{�[�h���Z�[�u���܂����F[" + $filename + "]"
        $clipText
    } else {
        "�A�N�e�B�u�E�B���h�E��Name�� [" + $target + "] �̏ꍇ�̂݃Z�[�u���܂�"
        "���̃A�N�e�B�u�E�B���h�E�̓N���b�v�{�[�h�Z�[�u�̑ΏۊO�ł��F"
        $info
    }
}

#
$filename = openFileDialog "�N���b�v�{�[�h�Z�[�u����t�@�C����I��ł�������"
"�o�b�N�A�b�v���܂��F[" + $filename + "]"
backup $filename
"�N���b�v�{�[�h���Ď����ăZ�[�u���܂��F[" + $filename + "]"
monitorClipboardText
