Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Root folder of the script (where setup.exe is located)
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$setupExe   = Join-Path $scriptRoot "setup.exe"

$form = New-Object System.Windows.Forms.Form
$form.Text = "Office 2024 Installer"
$form.Size = New-Object System.Drawing.Size(420,700)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

# -----------------------------
# Language Dropdown
# -----------------------------
$langLabel = New-Object System.Windows.Forms.Label
$langLabel.Text = "Choose Language:"
$langLabel.Location = New-Object System.Drawing.Point(20,20)
$langLabel.Size = New-Object System.Drawing.Size(200,20)
$form.Controls.Add($langLabel)

$langDropdown = New-Object System.Windows.Forms.ComboBox
$langDropdown.Location = New-Object System.Drawing.Point(20,45)
$langDropdown.Size = New-Object System.Drawing.Size(200,25)
$langDropdown.DropDownStyle = "DropDownList"
$langDropdown.Items.Add("fr-fr")
$langDropdown.Items.Add("en-us")
$langDropdown.SelectedIndex = 0
$form.Controls.Add($langDropdown)

# -----------------------------
# Scrollable Panel for Checkboxes
# -----------------------------
$panel = New-Object System.Windows.Forms.Panel
$panel.Location = New-Object System.Drawing.Point(20,90)
$panel.Size = New-Object System.Drawing.Size(360,380)
$panel.AutoScroll = $true
$form.Controls.Add($panel)

# -----------------------------
# App Checkboxes
# -----------------------------
$apps = @{
    "Word"       = $true
    "Excel"      = $true
    "PowerPoint" = $true
    "Outlook"    = $true
    "Access"     = $false
    "Publisher"  = $false
    "OneNote"    = $false
    "OneDrive"   = $false
    "Teams"      = $false
    "Visio"      = $false
    "Project"    = $false
}

$checkboxes = @{}
$y = 10

foreach ($app in $apps.Keys) {
    $cb = New-Object System.Windows.Forms.CheckBox
    $cb.Text = $app
    $cb.Checked = $apps[$app]
    $cb.Location = New-Object System.Drawing.Point(10,$y)
    $cb.Size = New-Object System.Drawing.Size(200,25)
    $panel.Controls.Add($cb)
    $checkboxes[$app] = $cb
    $y += 30
}

# -----------------------------
# Download Button
# -----------------------------
$downloadBtn = New-Object System.Windows.Forms.Button
$downloadBtn.Text = "Download"
$downloadBtn.Size = New-Object System.Drawing.Size(150,40)
$downloadBtn.Location = New-Object System.Drawing.Point(20, 500)
$form.Controls.Add($downloadBtn)

$downloadBtn.Add_Click({
    $selectedLang = $langDropdown.SelectedItem

    $sb = New-Object System.Text.StringBuilder
    $null = $sb.AppendLine('<Configuration>')
    $null = $sb.AppendLine('  <Add OfficeClientEdition="64" Channel="PerpetualVL2024">')
    $null = $sb.AppendLine('    <Product ID="ProPlus2024Volume" PIDKEY="XJ2XN-FW8RK-P4HMP-DKDBV-GCVGB">')
    $null = $sb.AppendLine("      <Language ID=""$selectedLang"" />")
    $null = $sb.AppendLine('    </Product>')
    $null = $sb.AppendLine('  </Add>')
    $null = $sb.AppendLine('</Configuration>')

    $configsFolder = Join-Path $scriptRoot "configs"
    if (!(Test-Path $configsFolder)) { New-Item -ItemType Directory -Path $configsFolder | Out-Null }

    $downloadPath = Join-Path $configsFolder "download.xml"
    $sb.ToString() | Out-File -Encoding utf8 $downloadPath

    $absoluteDownload = (Resolve-Path $downloadPath).Path

    Start-Process $setupExe `
        -ArgumentList "/download `"$absoluteDownload`"" `
        -WorkingDirectory $scriptRoot `
        -Wait

    [System.Windows.Forms.MessageBox]::Show("Download started.")
})

# -----------------------------
# Install Button
# -----------------------------
$installBtn = New-Object System.Windows.Forms.Button
$installBtn.Text = "Install"
$installBtn.Size = New-Object System.Drawing.Size(150,40)
$installBtn.Location = New-Object System.Drawing.Point(200, 500)
$form.Controls.Add($installBtn)

$installBtn.Add_Click({
    $selectedLang = $langDropdown.SelectedItem

    $sb = New-Object System.Text.StringBuilder
    $null = $sb.AppendLine('<Configuration>')
    $null = $sb.AppendLine('  <Add OfficeClientEdition="64" Channel="PerpetualVL2024">')
    $null = $sb.AppendLine('    <Product ID="ProPlus2024Volume" PIDKEY="XJ2XN-FW8RK-P4HMP-DKDBV-GCVGB">')
    $null = $sb.AppendLine("      <Language ID=""$selectedLang"" />")

    foreach ($app in $apps.Keys) {
        if (-not $checkboxes[$app].Checked) {
            $null = $sb.AppendLine("      <ExcludeApp ID=""$app"" />")
        }
    }

    $null = $sb.AppendLine('    </Product>')
    $null = $sb.AppendLine('  </Add>')
    $null = $sb.AppendLine('</Configuration>')

    $configsFolder = Join-Path $scriptRoot "configs"
    if (!(Test-Path $configsFolder)) { New-Item -ItemType Directory -Path $configsFolder | Out-Null }

    $configPath = Join-Path $configsFolder "generated.xml"
    $sb.ToString() | Out-File -Encoding utf8 $configPath

    $absoluteConfig = (Resolve-Path $configPath).Path

    Start-Process $setupExe `
        -ArgumentList "/configure `"$absoluteConfig`"" `
        -WorkingDirectory $scriptRoot `
        -Wait

    [System.Windows.Forms.MessageBox]::Show("Installation started.")
})

# -----------------------------
# Generate XML Only Button
# -----------------------------
$generateBtn = New-Object System.Windows.Forms.Button
$generateBtn.Text = "Generate XML Only"
$generateBtn.Size = New-Object System.Drawing.Size(330,40)
$generateBtn.Location = New-Object System.Drawing.Point(20, 550)
$form.Controls.Add($generateBtn)

$generateBtn.Add_Click({
    $selectedLang = $langDropdown.SelectedItem

    $sb = New-Object System.Text.StringBuilder
    $null = $sb.AppendLine('<Configuration>')
    $null = $sb.AppendLine('  <Add OfficeClientEdition="64" Channel="PerpetualVL2024">')
    $null = $sb.AppendLine('    <Product ID="ProPlus2024Volume" PIDKEY="XJ2XN-FW8RK-P4HMP-DKDBV-GCVGB">')
    $null = $sb.AppendLine("      <Language ID=""$selectedLang"" />")

    foreach ($app in $apps.Keys) {
        if (-not $checkboxes[$app].Checked) {
            $null = $sb.AppendLine("      <ExcludeApp ID=""$app"" />")
        }
    }

    $null = $sb.AppendLine('    </Product>')
    $null = $sb.AppendLine('  </Add>')
    $null = $sb.AppendLine('</Configuration>')

    $configsFolder = Join-Path $scriptRoot "configs"
    if (!(Test-Path $configsFolder)) { New-Item -ItemType Directory -Path $configsFolder | Out-Null }

    $xmlPath = Join-Path $configsFolder "generated.xml"
    $sb.ToString() | Out-File -Encoding utf8 $xmlPath

    [System.Windows.Forms.MessageBox]::Show("XML generated:`n$xmlPath")
})

# -----------------------------
# Cancel Button
# -----------------------------
$cancelBtn = New-Object System.Windows.Forms.Button
$cancelBtn.Text = "Cancel"
$cancelBtn.Size = New-Object System.Drawing.Size(150,40)
$cancelBtn.Location = New-Object System.Drawing.Point(20, 600)
$form.Controls.Add($cancelBtn)

$cancelBtn.Add_Click({
    $form.Close()
})

$form.ShowDialog()
