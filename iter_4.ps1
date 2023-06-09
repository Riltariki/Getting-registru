# Import the necessary assembly for Windows Forms
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

#SearchByHiveFunction--------------------------------------------------------------------------------------
# Function for handling the "Next" button click when selecting a subkey based on the chosen hive
Function Button_Next_Click_Begin($text)
{
    # Create a new Windows Form
    $Form = New-Object system.Windows.Forms.Form
    $Form.ClientSize = New-Object System.Drawing.Point(700,400)
    $Form.text = "Choose the subkey name."
    $Form.TopMost = $false

    # Create a ListBox control for displaying subkey options
    $objListBox = New-Object System.Windows.Forms.ListBox
    $objListBox.Location = New-Object System.Drawing.Point(27,100)
    $objListBox.Size = New-Object System.Drawing.Size(600,200) 
    $objListBox.Items.Add("Firstly, choose the subkey!")
    $objListBox.Font = New-Object System.Drawing.Font('Microsoft Sans Serif',8)

    # Create a ComboBox control for selecting the hive
    $ComboBox1 = New-Object system.Windows.Forms.ComboBox
    $ComboBox1.text = "SubKey names"
    $ComboBox1.width = 150
    $ComboBox1.height = 30

    $newComboBox = New-Object System.Windows.Forms.ComboBox
    $newComboBox.location = New-Object System.Drawing.Point(27,90)
    $newComboBox.width = 150
    $newComboBox.height = 30
    $form.Controls.Add($newComboBox)
    $newComboBox.Visible = $false
    $newComboBox.Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

    # Check the chosen hive and populate the ComboBox with subkey names accordingly
    if ($text -eq 'HKCU') {
        Write-Host "The HKCU hive has been chosen."
        $subkey = [Microsoft.Win32.Registry]::CurrentUser.GetSubKeyNames()
        foreach ($subkey in $subkey) {
            $ComboBox1.Items.Add("$subkey")
        }
    }
    elseif ($text -eq 'HKLM') {
        Write-Host "The HKLM hive has been chosen."
        $subkey = [Microsoft.Win32.Registry]::LocalMachine.GetSubKeyNames()
        foreach ($subkey in $subkey) {
            $ComboBox1.Items.Add("$subkey")
        }
    }
    elseif ($text -eq 'HKCR') {
        Write-Host "The HKCR hive has been chosen."
        $subkey = [Microsoft.Win32.Registry]::ClassesRoot.GetSubKeyNames()
        foreach ($subkey in $subkey) {
            $ComboBox1.Items.Add("$subkey")
        }
    }
    elseif ($text -eq 'HKU') {
        Write-Host "The HKU hive has been chosen."
        $subkey = [Microsoft.Win32.Registry]::Users.GetSubKeyNames()
        foreach ($subkey in $subkey) {
            $ComboBox1.Items.Add("$subkey")
        }
    }
    elseif ($text -eq 'HKCC') {
        Write-Host "The HKCC hive has been chosen."
        $subkey = [Microsoft.Win32.Registry]::CurrentConfig.GetSubKeyNames()
        foreach ($subkey in $subkey) {
            $ComboBox1.Items.Add("$subkey")
        }
    }
    $ComboBox1.location = New-Object System.Drawing.Point(27,50)
    $ComboBox1.Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

    # Add an event handler for when the ComboBox selection changes
    $ComboBox1.Add_SelectedIndexChanged({
        $TextForView = $text + ":\" + $ComboBox1.SelectedItem
        $Label1.text = $TextForView
        $newComboBox.Visible = $false

        $objListBox.Location = New-Object System.Drawing.Point(27,100)
        $button = New-Object System.Windows.Forms.Button
        $button.Location = '186, 48'
        $button.Text = '...'
        $button.width = 30
        $button.height = 30

        # Add an event handler for when the button is clicked
        $button.Add_Click({
            $objListBox.Location = New-Object System.Drawing.Point(27,130)
            $newComboBox.Visible = $true
            if ($text -eq 'HKCU') {
            $registryKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey($ComboBox1.SelectedItem)

            }
            elseif ($text -eq 'HKLM') {
                $registryKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey($ComboBox1.SelectedItem)

            }
            elseif ($text -eq 'HKCR') {
                $registryKey = [Microsoft.Win32.Registry]::ClassesRoot.OpenSubKey($ComboBox1.SelectedItem)

            }
            elseif ($text -eq 'HKU') {
                $registryKey = [Microsoft.Win32.Registry]::Users.OpenSubKey($ComboBox1.SelectedItem)

            }
            elseif ($text -eq 'HKCC') {
                $registryKey = [Microsoft.Win32.Registry]::CurrentConfig.OpenSubKey($ComboBox1.SelectedItem)

            }
    
     
            # Get the subkey names under the selected registry key
            $subselectedKeys = $registryKey.GetSubKeyNames()

            # Add the subkey names to the new ComboBox
            if ($subselectedKeys) {
                foreach ($subselectedKey in $subselectedKeys) {
                    $newComboBox.Items.Add($subselectedKey)
                }
            }
        })

        $form.Controls.Add($button)
    })


    $newComboBox.Add_SelectedIndexChanged({
        $TextForView = $text + ":\" + $ComboBox1.SelectedItem + "\" + $newComboBox.SelectedItem
        $Label1.text = $TextForView
    })

    $BackButton1 = New-Object system.Windows.Forms.Button
    $BackButton1.text = "Back"
    $BackButton1.width = 60
    $BackButton1.height = 30
    $BackButton1.location = New-Object System.Drawing.Point(241,48)
    $BackButton1.Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
    $BackButton1.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#c96b76")

    $NextButton2 = New-Object system.Windows.Forms.Button
    $NextButton2.text = "Show"
    $NextButton2.width = 60
    $NextButton2.height = 30
    $NextButton2.location = New-Object System.Drawing.Point(326,48)
    $NextButton2.Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
    $NextButton2.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#b8e986")

    $TextAfterInitialization = $text + ':'
    $TextForView = $TextAfterInitialization
    $Label1 = New-Object system.Windows.Forms.Label
    $Label1.text = $TextForView
    $Label1.AutoSize = $true
    $Label1.width = 25
    $Label1.height = 10
    $Label1.location = New-Object System.Drawing.Point(27,22)
    $Label1.Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

    $Form.controls.AddRange(@($ComboBox1,$BackButton1,$NextButton2,$Label1, $objListBox))

    $BackButton1.Add_Click({$Form.Close()})
    $NextButton2.Add_Click({
        $selectedItem = $Label1.text
        if ($selectedItem -ne $null) {
            if (Test-Path $selectedItem) {
            $objListBox.Items.Clear()
            $objListBox.Items.Add('Subkey Access:')
            $acl = (Get-Acl $selectedItem).Access | Out-String 
            $accessArray = $acl -split "`n"
            foreach ($access in $accessArray) {
                $objListBox.Items.Add($access)
            }
        }
    else {
        Write-Host "Path does not exist: $selectedItem"
    }
}
    })

    [void]$Form.ShowDialog()
}







#SearchBySubkeyFunction--------------------------------------------------------------------------------------
Function Button_Extended_Click_Begin() {

    $Form = New-Object system.Windows.Forms.Form
    $Form.ClientSize = New-Object System.Drawing.Point(700,400)
    $Form.text = "Extended search to permission's list searching."
    $Form.TopMost = $false

    $objListBox = New-Object System.Windows.Forms.ListBox
    $objListBox.Location = New-Object System.Drawing.Point(27,100)
    $objListBox.Size = New-Object System.Drawing.Size(600,200) 
    $objListBox.Items.Add("Firstly, enter the pass to the subkey!")
    $objListBox.Font = New-Object System.Drawing.Font('Microsoft Sans Serif',8)

    $textbox = New-Object System.Windows.Forms.TextBox
    $textbox.Location = New-Object System.Drawing.Point(27, 52)
    $textbox.Size = New-Object System.Drawing.Size(450, 35)

    $BackButton1 = New-Object system.Windows.Forms.Button
    $BackButton1.text = "Back"
    $BackButton1.width = 60
    $BackButton1.height = 30
    $BackButton1.location = New-Object System.Drawing.Point(490,48)
    $BackButton1.Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
    $BackButton1.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#c96b76")

    $NextButton2 = New-Object system.Windows.Forms.Button
    $NextButton2.text = "Show"
    $NextButton2.width = 60
    $NextButton2.height = 30
    $NextButton2.location = New-Object System.Drawing.Point(570,48)
    $NextButton2.Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
    $NextButton2.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#b8e986")

    $Label1 = New-Object system.Windows.Forms.Label
    $Label1.text = 'Enter the pass to the subkey.  (Example: HKLM:\Software\Microsoft)'
    $Label1.AutoSize = $true
    $Label1.width = 25
    $Label1.height = 10
    $Label1.location = New-Object System.Drawing.Point(25,22)
    $Label1.Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

    $Form.controls.AddRange(@($BackButton1,$NextButton2,$Label1,$textbox,$objListBox))

    $BackButton1.Add_Click({ $Form.Close() })
    
    $NextButton2.Add_Click({
        $selectedItem = $textbox.Text
        if (![string]::IsNullOrEmpty($selectedItem)) {
            # Получаем список разрешений для выбранного подраздела реестра
            $objListBox.Items.Clear()
            if (Test-Path -Path $selectedItem) {
            $objListBox.Items.Add('Subkey Access:')
            $acl = (Get-Acl $selectedItem).Access | Out-String
            $accessArray = $acl -split "`n"
            foreach ($access in $accessArray) {
                $objListBox.Items.Add($access)
            }
            }else {
            $objListBox.Items.Add("Enter the valid path!")
}

        }
    })

    [void]$Form.ShowDialog()
}







#main--------------------------------------------------------------------------------------

# Check if HKCC drive exists, if not create it
$existingDrive = Get-PSDrive -Name HKCC -ErrorAction SilentlyContinue

if ($existingDrive -eq $null) {
    New-PSDrive -PSProvider registry -Root HKEY_CURRENT_CONFIG -Name HKCC
}

# Check if HKU drive exists, if not create it
$existingDrive = Get-PSDrive -Name HKU -ErrorAction SilentlyContinue

if ($existingDrive -eq $null) {
    New-PSDrive -PSProvider registry -Root HKEY_USERS -Name HKU
}

# Check if HKCR drive exists, if not create it
$existingDrive = Get-PSDrive -Name HKCR -ErrorAction SilentlyContinue

if ($existingDrive -eq $null) {
    New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR
}




# Create the main form
$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(280,150)
$Form.text                       = "Subkey permission's viewer"
$Form.TopMost                    = $false

$NextButton1                         = New-Object system.Windows.Forms.Button
$NextButton1.text                    = "Next"
$NextButton1.width                   = 60
$NextButton1.height                  = 30
$NextButton1.location                = New-Object System.Drawing.Point(200,100)
$NextButton1.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$NextButton1.BackColor               = [System.Drawing.ColorTranslator]::FromHtml("#b8e986")
$Form.Controls.Add($NextButton1)
#Add Button event 
$NextButton1.Add_Click({
if ($ComboBox1.text -eq 'Hives'){
    [System.Windows.Forms.MessageBox]::Show("Choose the hive!")
}
else {
    Button_Next_Click_Begin($ComboBox1.text) }
})



$ExtendedSearchlButton1                         = New-Object system.Windows.Forms.Button
$ExtendedSearchlButton1.text                    = "Extended Search"
$ExtendedSearchlButton1.width                   = 120
$ExtendedSearchlButton1.height                  = 30
$ExtendedSearchlButton1.location                = New-Object System.Drawing.Point(70,100)
$ExtendedSearchlButton1.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Form.Controls.Add($ExtendedSearchlButton1)
#Add Button event 
$ExtendedSearchlButton1.Add_Click({
Button_Extended_Click_Begin($ComboBox1.text)
})



# ComboBox for choosing the hive
$ComboBox1                       = New-Object system.Windows.Forms.ComboBox
$ComboBox1.text                  = "Hives"
$ComboBox1.width                 = 100
$ComboBox1.height                = 20
@('HKCR','HKCU','HKLM', 'HKU', 'HKCC') | ForEach-Object {[void] $ComboBox1.Items.Add($_)}
$ComboBox1.location              = New-Object System.Drawing.Point(22,38)
$ComboBox1.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

# Label for instruction
$Label1                          = New-Object system.Windows.Forms.Label
$Label1.text                     = "Choose the hive."
$Label1.AutoSize                 = $true
$Label1.width                    = 25
$Label1.height                   = 10
$Label1.location                 = New-Object System.Drawing.Point(22,13)
$Label1.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

# Add controls to the form
$Form.controls.AddRange(@($NextButton1,$ExtendedSearchlButton1,$ComboBox1,$Label1))


$NextButton1.Add_AutoSizeChanged({  })



[void]$Form.ShowDialog()
