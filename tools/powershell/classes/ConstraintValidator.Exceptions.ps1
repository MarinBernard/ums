###############################################################################
#   Exception class CVValidationFailureException
#==============================================================================
#
#   Thrown by the [ConstraintValidator]::Validate() method when a
#   configuration item cannot be retrieved because it has a bad type or name.
#
###############################################################################

class CVValidationFailureException : UmsException
{
    CVValidationFailureException(
        [UmsItem] $Item,
        [PSCustomObject] $Constraint,
        [string] $BadValue)
        : base()
    {
        $this.MainMessage = (
            "The following UMS item failed constraint validation: {0} " `
            -f $Item.FullName)

        $this.SubMessages += ("Constraint id: {0}" -f $Constraint.Id)
        $this.SubMessages += ("Constraint value: {0}" -f $Constraint.Value)
        $this.SubMessages += ("Item value: {0}" -f $BadValue)
    }
}