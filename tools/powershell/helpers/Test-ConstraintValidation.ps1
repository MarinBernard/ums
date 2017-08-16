# Helper function which performs constraint validation on a UmsItem/UmsManagedItem instance.
function Test-ConstraintValidation
{
    [CmdletBinding(DefaultParametersetName='None')]
    Param(
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [UmsItem] $Item,

        [Parameter(Position=1,Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [array] $Constraints
    )

    Process
    {
        try
        {
            foreach ($_constraint in $Constraints)
            {
                # No need to check the remaining constraints if we're already false
                if ($_isValid = $false) { continue }

                switch ($_constraint.Id)
                {
                    "binding-element-namespace"
                    {
                        if ($Item.BindingNamespace -ne $_constraint.Value)
                        {
                            throw [IncompatibleBindingNamespace]::New(
                                $Item, $_constraint.Value)
                        }
                    }

                    "binding-element-name"
                    {
                        if ($Item.BindingElementName -ne $_constraint.Value)
                        {
                            # TODO: more generic exceptions
                            throw [IncompatibleBindingElement]::New(
                                $Item, $_constraint.Value)
                        }
                    }

                    "document-element-namespace"
                    {
                        if ($Item.XmlNamespace -ne $_constraint.Value)
                        {
                            # TODO: more generic exceptions
                            throw [IncompatibleBindingNamespace]::New(
                                $Item, $_constraint.Value)
                        }
                    }

                    "document-element-name"
                    {
                        if ($Item.XmlElementName -ne $_constraint.Value)
                        {
                            # TODO: more generic exceptions
                            throw [IncompatibleBindingElement]::New(
                                $Item, $_constraint.Value)
                        }
                    }

                    "item-cardinality"
                    {
                        # Build the list of allowed cardinalities
                        [UICardinality[]] $_allowedCardinalities = @()

                        switch ($_constraint.Value)
                        {
                            "SidecarOrOrphan"
                            {
                                $_allowedCardinalities = @(
                                [UICardinality]::Sidecar,
                                [UICardinality]::Orphan)
                            }
                        }

                        # Check cardinality
                        if ($_allowedCardinalities -notcontains($Item.Cardinality))
                        {
                            # TODO: more generic exceptions
                            throw [IncompatibleCardinalityException]::New(
                                $Item, $_allowedCardinalities)
                        }
                    }

                    "item-static-version-status"
                    {
                        # Build the list of allowed statuses
                        [UIVersionStatus[]] $_allowedVersionStatuses = @()
                        
                        switch ($_constraint.Value)
                        {
                            "CurrentOrExpired"
                            {
                                $_allowedVersionStatuses = @(
                                [UIVersionStatus]::Current,
                                [UIVersionStatus]::Expired)
                            }
                        }

                        # Check cardinality
                        if ($_allowedVersionStatuses -notcontains($Item.StaticVersion))
                        {
                            # TODO: more generic exceptions
                            throw [IncompatibleCardinalityException]::New(
                                $Item, $_allowedVersionStatuses)
                        }
                    }
                }
            }
        }

        catch [UmsException]
        {
            Write-Error $_.Exception.MainMessage
            throw [ConstraintValidationFailure]::New($Item)
        }
    }
}