###########################################################################
# Check whether UmsAbstractClassInstantiationException are thrown
###########################################################################

# Retrieve test document
$_testDocument = Get-TestDocument "Music_Composer"

# Test 1: Instantiate abstract entity class UmsAeEntity
$_test = New-TestItem "Forbid instantiation of abstract entity class UmsAeEntity" "UmsAeEntity"
try { New-Object -Type UmsAeEntity -ArgumentList $_testDocument.DocumentElement | Out-Null }
catch [UmsAbstractClassInstantiationException] { $_test.Passed($_.Exception) }
catch { $_test.Failed($_.Exception) }
$_test.Failed("No exception raised.")
$_test

###########################################################################
# Check the value of properties inherited from UmsAeEntity
###########################################################################

# Retrieve test document
$_testDocument = Get-TestDocument "Music_Composer"

# Test 1: Check value of the XmlNamespaceUri inherited property in an UmsMceComposer instance
$_test = New-TestItem "Check value of inherited property 'XmlNamespaceUri'" "UmsAeEntity"
try
{
    $_instance = New-Object -Type UmsMaeEntity -ArgumentList $_testDocument.DocumentElement
    if ($_instance.XmlNamespaceUri = $_testDocument.DocumentElement.NamespaceUri) { $_test.Passed() }
}
catch { $_test.Failed($_.Exception) }
$_test.Failed($("Bad value: " + $_instance.NamespaceUri))
$_test

# Test 2: Check value of the XmlElementName inherited property in an UmsMceComposer instance
$_test = New-TestItem "Check value of inherited property 'XmlElementName'" "UmsAeEntity"
try
{
    $_instance = New-Object -Type UmsMaeEntity -ArgumentList $_testDocument.DocumentElement
    if ($_instance.XmlElementName = $_testDocument.DocumentElement.LocalName) { $_test.Passed() }
}
catch { $_test.Failed($_.Exception) }
$_test.Failed($("Bad value: " + $_instance.LocalName))
$_test

# Test 3: Check value of the Uid inherited property in an UmsMceComposer instance
$_test = New-TestItem "Check value of inherited property 'Uid'" "UmsAeEntity"
try
{
    $_instance = New-Object -Type UmsMaeEntity -ArgumentList $_testDocument.DocumentElement
    if ($_instance.Uid = $_testDocument.DocumentElement.Uid) { $_test.Passed() }
}
catch { $_test.Failed($_.Exception) }
$_test.Failed($("Bad value: " + $_instance.Uid))
$_test