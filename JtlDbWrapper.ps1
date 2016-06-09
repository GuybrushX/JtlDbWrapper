Param(
    [Parameter(Mandatory=$true)]
    $ObjectName,
    [Parameter(Mandatory=$true)]
    $PkValue,
    [Parameter(Mandatory=$true)]
    $ColumnName,
    [Parameter(Mandatory=$true)]
    $NewValue
)

# Add JTL Database types
Add-Type -Path "C:\Program Files (x86)\JTL-Software\jtlDatabase.dll"

# Set up connection to the database
[jtlDatabase.DB]::baueConString("(local)\JTLWAWI,1433", "eazybusiness", "sa", "sa04jT14")
#[jtlDatabase.DB]::baueConString("192.168.10.23\JTLWAWI,1433", "Mandant_1", "sa", "sa04jT14")

# Debug with single parameter for the constructor
<#
$TableName = "jtlKunde"
$PkValue = @(13622)
$ColumnName = "nZahlungsziel"
$NewValue = 14
#$NewValue = $jtlDbObject.$ColumnName + 7
#>

# Debug with multiple parameters for the constructor
<#
$TableName = "jtlPf_amazon_angebot"
$PkValue = @("SKU", 1, 51)
$ColumnName = "cASIN1"
$NewValue = "XXX"
#$NewValue = $jtlDbObject.$ColumnName + "Test"
#>

# Initialize an object from database with the specified primary key(s)
$jtlDbObject = New-Object "jtlDatabase.classes.jtlDBClasses.${ObjectName}" ${PkValue}

# Output current value
$jtlDbObject.$ColumnName

# Set the new value
$jtlDbObject.SetValue($ColumnName, $NewValue)

# Save to database
$jtlDbObject.Save()

# Exit the console host
[Environment]::Exit(1)