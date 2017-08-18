class EventLogger
{
    ###########################################################################
    # Static properties
    ###########################################################################

    # Collection of logged exceptions
    static [System.Exception[]] $LoggedExceptions

    # Collection of logged events
    static [PSCustomObject[]] $LoggedEvents

    ###########################################################################
    # Loggers
    ###########################################################################

    # Logs an event
    static LogEvent([LoggedEventLevel] $Level, $Data)
    { 
        $_eventData = (Get-PSCallStack)[2]

        $_event = (
            New-Object -Type PSCustomObject -Property (
                [ordered] @{
                    Level = $Level
                    Message  = $Data
                    Location = $_eventData.Location
                    SourceFunction = $_eventData.FunctionName
                }))

        [EventLogger]::LoggedEvents += $_event
        [EventLogger]::ShowEvent($_event)
    }

    # Logs an exception
    static [void] LogException([System.Exception] $Exception)
    {
        [EventLogger]::LoggedExceptions += $Exception
    }

    # Proxy method for logging a debug event
    static LogDebug([string] $Data)
    {
        if ([bool] (Write-Debug ([String]::Empty) 5>&1))
        {
            [EventLogger]::LogEvent([LoggedEventLevel]::Debug, $Data)
        }        
    }

    # Proxy method for logging a verbose event
    static LogVerbose([string] $Data)
    {
        if ([bool] (Write-Verbose ([String]::Empty) 4>&1))
        {
            [EventLogger]::LogEvent([LoggedEventLevel]::Verbose, $Data)
        }
    }

    # Proxy method for logging an error event
    static LogWarning([string] $Data)
    {
        if ([bool] (Write-Warning ([String]::Empty) 3>&1))
        {
            [EventLogger]::LogEvent([LoggedEventLevel]::Warning, $Data)
        } 
    }

    # Proxy method for logging an error event
    static LogError([string] $Data)
    {
        if ([bool] (Write-Error ([String]::Empty) 2>&1))
        {
            [EventLogger]::LogEvent([LoggedEventLevel]::Error, $Data)
        } 
    }

    ###########################################################################
    # Dumpers
    ###########################################################################

    # Shows a single event on the console
    # Dumps the whole event log to the console then flushes the event log.
    static [void] ShowEvent([PSCustomObject] $Event)
    {
        Write-Host -NoNewLine -ForegroundColor Gray "["
        
        switch ($Event.Level)
        {
            "Debug"
            {
                Write-Host -NoNewLine -ForegroundColor DarkGray " DEBUG "
            }

            "Verbose"
            {
                Write-Host -NoNewLine -ForegroundColor Cyan "VERBOSE"
            }

            "Warning"
            {
                Write-Host -NoNewLine -ForegroundColor Yellow "WARNING"
            }

            "Error"
            {
                Write-Host -NoNewLine -ForegroundColor Red " ERROR "
            }
        }

        Write-Host -NoNewLine -ForegroundColor White "]"

        Write-Host -NoNewLine " "

        Write-Host -NoNewLine -ForegroundColor Gray "("
        Write-Host -NoNewLine -ForegroundColor DarkGray $Event.SourceFunction
        Write-Host -NoNewLine -ForegroundColor Gray ", "
        Write-Host -NoNewLine -ForegroundColor DarkGray $Event.Location
        Write-Host -NoNewLine -ForegroundColor Gray ")"

        Write-Host -NoNewLine " "

        Write-Host -ForegroundColor White $Event.Message
    }

    # Dumps the whole event log to the console then flushes the event log.
    static [void] DumpEvents()
    {
        foreach ($_event in ([EventLogger]::LoggedEvents))
        {
            [EventLogger]::ShowEvent($_event)
        }

        [EventLogger]::LoggedEvents = @()
    }

    # Dumps the exception chain to the console
    static [void] DumpExceptions()
    {
        $ExceptionDelimiter = "################################################################################"
        $ExceptionSectionDelimiter = "--------------------------------------------------------------------------------"

        foreach( $_exception in ([EventLogger]::LoggedExceptions))
        {
            Write-Host -ForegroundColor DarkBlue $ExceptionDelimiter
            Write-Host -ForegroundColor DarkBlue -NoNewLine "Exception: "
            Write-Host -ForegroundColor Blue $_exception.GetType().FullName
            Write-Host -ForegroundColor DarkBlue $ExceptionSectionDelimiter

            if ($_exception.MainMessage)
            {
                Write-Host -ForegroundColor Yellow $_exception.MainMessage
                foreach ($_line in $_exception.SubMessages)
                {
                    Write-Host -ForegroundColor Gray $("`t" + $_line)
                }
            }
            else
            {
                Write-Host -ForegroundColor Yellow $_exception.Message
            }

            Write-Host -ForegroundColor DarkBlue $ExceptionDelimiter
            Write-Host ""
        }
    }
}

Enum LoggedEventLevel
{
    Debug
    Error
    Verbose
    Warning
}