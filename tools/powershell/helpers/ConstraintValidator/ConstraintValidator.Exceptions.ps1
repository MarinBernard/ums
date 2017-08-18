###############################################################################
#   Exception class ConstraintValidatorException
#==============================================================================
#
#   Parent type for all exceptions thrown by the [ConstraintValidator] class.
#
###############################################################################

class ConstraintValidatorException : UmsException
{
    ConstraintValidatorException() : base() {}
}

###############################################################################
#   Exception class CVValidationFailureException
#==============================================================================
#
#   Thrown by the [ConstraintValidator]::Validate() method when a
#   configuration item cannot be retrieved because it has a bad type or name.
#
###############################################################################

class CVValidationFailureException : ConstraintValidatorException
{
    CVValidationFailureException(
        [UmsFile] $File,
        [PSCustomObject] $Constraint,
        [string] $BadValue)
        : base()
    {
        $this.MainMessage = (
            "The following UMS item failed constraint validation: {0} " `
            -f $File.FullName)

        $this.SubMessages += ("Constraint id: {0}" -f $Constraint.Id)
        $this.SubMessages += ("Constraint value: {0}" -f $Constraint.Value)
        $this.SubMessages += ("Item value: {0}" -f $BadValue)
    }
}