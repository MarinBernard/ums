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

        if ($Level -eq [LoggedEventLevel]::Exception)
        {
            if ($Data.MainMessage) { $_message = $Data.MainMessage}
            else { $_message = $Data.Message }

            $_event = (
                New-Object -Type PSCustomObject -Property (
                    [ordered] @{
                        Level = $Level
                        Exception = $Data
                        Message  = $_message
                        Location = $_eventData.Location
                        SourceFunction = $_eventData.FunctionName
                    }))
        }
        else
        {
            $_event = (
                New-Object -Type PSCustomObject -Property (
                    [ordered] @{
                        Level = $Level
                        Message  = $Data
                        Location = $_eventData.Location
                        SourceFunction = $_eventData.FunctionName
                    }))
        }

        [EventLogger]::LoggedEvents += $_event
        [EventLogger]::ShowEvent($_event)
    }

    # Logs an exception
    static [void] LogException([System.Exception] $Exception)
    {
        [EventLogger]::LogEvent([LoggedEventLevel]::Exception, $Exception)
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
                Write-Host -NoNewLine -ForegroundColor DarkGray "  DEBUG  "
            }

            "Verbose"
            {
                Write-Host -NoNewLine -ForegroundColor Cyan " VERBOSE "
            }

            "Warning"
            {
                Write-Host -NoNewLine -ForegroundColor Yellow " WARNING "
            }

            "Error"
            {
                Write-Host -NoNewLine -ForegroundColor Red "  ERROR  "
            }

            "Exception"
            {
                Write-Host -NoNewLine -ForegroundColor DarkRed "EXCEPTION"
            }
        }

        Write-Host -NoNewLine -ForegroundColor White "] "
        Write-Host -NoNewLine -ForegroundColor White "("
        Write-Host -NoNewLine -ForegroundColor DarkGray $Event.SourceFunction
        Write-Host -NoNewLine -ForegroundColor White ", "
        Write-Host -NoNewLine -ForegroundColor DarkGray $Event.Location
        Write-Host -NoNewLine -ForegroundColor White ") "
        Write-Host -NoNewLine -ForegroundColor Gray $Event.Message
        Write-Host ""
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
}

Enum LoggedEventLevel
{
    Debug
    Error
    Verbose
    Warning
    Exception
}