Enum TestItemResult
{
    Passed
    Failed
}

class TestItem
{
    [String] $Group
    [String] $Description
    [TestItemResult] $Result
    [String] $Message

    TestItem([string] $Description, [string] $Group)
    {
        $this.Description = $Description
        $this.Group = $Group
    }

    [void] Passed()
        { $this.Result = [TestItemResult]::Passed }

    [void] Passed([System.Exception] $Exception)
    {
        $this.Result = [TestItemResult]::Passed
        $this.Message = $Exception.Message
    }

    [void] Failed([string] $Message)
    {
        # We only set the test as failed if was not set as passed.
        if ($this.Result -ne [TestItemResult]::Passed)
        {
            $this.Result = [TestItemResult]::Failed
            $this.Message = $Message
        }
    }

    [void] Failed([System.Exception] $Exception)
    {
        # We only set the test as failed if was not set as passed.
        if ($this.Result -ne [TestItemResult]::Passed)
        {
            $this.Result = [TestItemResult]::Failed
            $this.Message = $Exception.Message
        }
    }
}

# Returns a test document, if it exists; raises an exception if not.
function Get-TestDocument([String] $DocumentName)
{
    if( $global:TestDocuments.Keys -notcontains($DocumentName))
        { throw $( "Test document '" + $DocumentName + "' not found!") }
    return $global:TestDocuments[$DocumentName]
}

function New-TestItem([String] $Description, [String] $Group = "")
{
    New-Object -Type TestItem -ArgumentList $Description,$Group
}