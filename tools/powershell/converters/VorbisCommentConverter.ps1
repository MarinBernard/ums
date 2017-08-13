class VorbisCommentConverter
{
    ###########################################################################
    # Static properties
    ###########################################################################

    # Catalog of namespace URIs for all instances.
    static [hashtable] $NamespaceUri = @{
        "Base"  = Get-UmsConfigurationItem -ShortName "BaseSchemaNamespace";
        "Audio" = Get-UmsConfigurationItem -ShortName "AudioSchemaNamespace";
        "Music" = Get-UmsConfigurationItem -ShortName "MusicSchemaNamespace";
    }

    # The non-breaking space character constant
    static [string] $NonBreakingSpace = $([char] 0x00A0)

    # One or several characters which will be inserted between the names of
    # played instruments.
    static [string] $InstrumentListDelimiter = 
    (Get-UmsConfigurationItem -ShortName "InstrumentListDelimiter")

    # One or several characters which will be inserted before the name of the
    # played instrument in a performer/instrumentalist/artist suffix.
    static [string] $InstrumentListPrefix = 
        (Get-UmsConfigurationItem -ShortName "InstrumentListPrefix")

    # One or several characters which will be inserted after the name of the
    # played instrument in a performer/instrumentalist/artist suffix.
    static [string] $InstrumentListSuffix = 
        (Get-UmsConfigurationItem -ShortName "InstrumentListSuffix")

    ###########################################################################
    # Hidden properties
    ###########################################################################

    ###########################################################################
    # Visible properties
    ###########################################################################

    [hashtable] $Features = @{
        DynamicAlbums                               =   $false;
        ComposerAsArtist                            =   $false;
        ConductorAsArtist                           =   $false;
        EnsembleAsArtist                            =   $false;
        EnsembleAsArtistInstrumentSuffix            =   $false;
        EnsembleInstrumentSuffix                    =   $false;
        InstrumentalistAsArtist                     =   $true;
        InstrumentalistAsArtistInstrumentSuffix     =   $false;
        InstrumentalistAsPerformer                  =   $true;
        InstrumentalistAsPerformerInstrumentSuffix  =   $true;
        InstrumentalistInstrumentSuffix             =   $false;
        MusicalFormAsGenre                          =   $false;
    }

    # Rendering options for dynamic albums
    [hashtable] $DynamicAlbumRendering = @{
        # When dynamic albums are enabled, the composer of the performed work
        # is used as an album artist. When a work has several composers, the
        # names of these composers are merged into a single album artist
        # comment. This string will be inserted between each composer name.
        AlbumArtistDelimiter        =   " & ";
        # If set to $true, dynamic album artist will be created from
        # sort-friendly variants of composer names. If set to false, full
        # composer names will be used instead.
        AlbumArtistUseSortVariants  =   $true;
    }

    # Rendering options
    [hashtable] $Rendering = @{
        # A prefix which will be inserted before the name of a musical form
        # when it is rendered as a GENRE Vorbis Comment. Use this prefix to
        # group musical forms together in the genre list.
        MusicalFormAsGenrePrefix    =   "";
    }

    # Default Vorbis Comment labels.
    # May be altered by configuration values passed to the constructor.
    [hashtable] $VorbisLabels = @{
        AlbumArtist                     =   "ALBUMARTIST"
        AlbumFullTitle                  =   "ALBUM";
        AlbumSortTitle                  =   "ALBUMSORT";
        AlbumSubtitle                   =   "";
        ArtistFullName                  =   "ARTIST";
        ArtistShortName                 =   "ARTISTSHORT";
        ArtistSortName                  =   "ARTISTSORT";
        ComposerFullName                =   "COMPOSER";
        ComposerShortName               =   "COMPOSERSHORT";
        ComposerSortName                =   "COMPOSERSORT";
        ConductorFullName               =   "CONDUCTOR";
        ConductorShortName              =   "CONDUCTORSHORT";
        ConductorSortName               =   "CONDUCTORSORT";
        EnsembleFullLabel               =   "ENSEMBLE";
        EnsembleShortLabel              =   "ENSEMBLESHORT";
        EnsembleSortLabel               =   "ENSEMBLESORT";
        Genre                           =   "GENRE";
        InstrumentalistFullName         =   "INSTRUMENTALIST";
        InstrumentalistShortName        =   "INSTRUMENTALISTSHORT";
        InstrumentalistSortName         =   "INSTRUMENTALISTSORT";
        LabelFullLabel                  =   "LABEL";
        MediumNumberCombined            =   "MEDIUMNUM";
        MediumNumberSimple              =   "MEDIUM";
        MediumTotal                     =   "MEDIUMTOTAL";
        MusicalForm                     =   "MUSICALFORM";
        OriginalAlbumArtist             =   "ORIGINALALBUMARTIST";
        OriginalAlbumFullTitle          =   "ORIGINALALBUM";
        OriginalAlbumSortTitle          =   "ORIGINALALBUMSORT";
        OriginalAlbumSubtitle           =   "ORIGINALALBUMSUBTITLE";
        OriginalMediumNumberCombined    =   "ORIGINALMEDIUMNUM";
        OriginalMediumNumberSimple      =   "ORIGINALMEDIUM";
        OriginalMediumTotal             =   "ORIGINALMEDIUMTOTAL";
        OriginalTrackNumberCombined     =   "ORIGINALTRACKNUM";
        OriginalTrackNumberSimple       =   "ORIGINALTRACK";
        OriginalTrackFullTitle          =   "ORIGINALTITLE";
        OriginalTrackSortTitle          =   "ORIGINALTITLESORT";
        OriginalTrackSubtitle           =   "ORIGINALSUBTITLE";
        OriginalTrackTotal              =   "ORIGINALTRACKTOTAL";
        PerformerFullName               =   "PERFORMER";
        PerformerShortName              =   "PERFORMERSHORT";
        PerformerSortName               =   "PERFORMERSORT";
        TrackFullTitle                  =   "TITLE";
        TrackNumberCombined             =   "TRACKNUM";
        TrackNumberSimple               =   "TRACK";
        TrackSortTitle                  =   "TITLESORT";
        TrackSubtitle                   =   "SUBTITLE";
        TrackTotal                      =   "TRACKTOTAL";
    }

    ###########################################################################
    # Constructors
    ###########################################################################

    VorbisCommentConverter([object[]] $Options)
    {
        foreach ($_option in $Options)
        {
            # Optional features
            if ($_option.Name -like "feature-*")
            {
                $_label = $_option.Name.
                    Replace("feature-", "").
                    Replace("-", "")
                if ($this.Features.ContainsKey($_label))
                {
                    $this.Features[$_label] = $_option.Value
                }
            }

            # Rendering options for dynamic albums
            if ($_option.Name -like "dynamic-album-rendering-*")
            {
                $_label = $_option.Name.
                    Replace("dynamic-album-rendering-", "").
                    Replace("-", "")
                if ($this.DynamicAlbumRendering.ContainsKey($_label))
                {
                    $this.DynamicAlbumRendering[$_label] = $_option.Value
                }
            }

            # Rendering options
            if ($_option.Name -like "rendering-*")
            {
                $_label = $_option.Name.
                    Replace("rendering-", "").
                    Replace("-", "")
                if ($this.Rendering.ContainsKey($_label))
                {
                    $this.Rendering[$_label] = $_option.Value
                }
            }

            # Vorbis labels
            elseif ($_option.Name -like "vorbis-label-*")
            {
                $_label = $_option.Name.
                    Replace("vorbis-label-", "").
                    Replace("-", "")
                if ($this.VorbisLabels.ContainsKey($_label))
                {
                    $this.VorbisLabels[$_label] = $_option.Value
                }
            }
        }
    }

    ###########################################################################
    # Vorbis Comment handling
    ###########################################################################

    [string] CreateVorbisComment([string] $LabelId, [string] $LabelValue)
    {
        $_vc = ""
        $_sanitizedValue = $LabelValue.Trim()

        # We only return the comment if the label ID is known,
        # if the label is not blank, and if the value is not empty.
        # Else, the comment is silently discarded.
        if (
            ($this.VorbisLabels.ContainsKey($LabelId)) -and
            ($this.VorbisLabels[$LabelId]) -and
            ($_sanitizedValue))
        {
            
            $_vc = $($this.VorbisLabels[$LabelId] + "=" + $_sanitizedValue)
        }

        return $_vc
    }

    ###########################################################################
    #   Converters
    #--------------------------------------------------------------------------
    #
    #   Method arguments are typeless since we may work on deserialized
    #   metadata, which do not allow static typing.
    #
    ###########################################################################

    # Main entry point. This method acts as a dispatch box, routing conversion
    # tasks to a more specific conversion method.
    [string[]] Convert($Metadata)
    {
        [string[]] $_lines = @()

        switch ($Metadata.XmlNamespaceUri)
        {
            ([VorbisCommentConverter]::NamespaceUri).Audio
            {
                switch ($Metadata.XmlElementName)
                {
                    "albumTrackBinding"
                    {
                        $_lines += (
                            $this.ConvertUmsAbeAlbumTrackBinding($Metadata))
                    }

                    default
                    {
                        throw [VCCBadRootElementNameException]::New(
                            ("Unsupported XML namespace: " -f $Metadata.XmlElementName)
                        )
                    }
                }
            }

            default
            {
                throw [VCCBadRootNamespaceException]::New(
                    ("Unsupported XML namespace: " -f $Metadata.XmlNamespaceUri)
                )
            }
        }

        return $_lines
    }

    # Converts an album track binding to Vorbis Comment.
    [string[]] ConvertUmsAbeAlbumTrackBinding($Metadata)
    {
        [string[]] $_lines = @()

        $_album  = $Metadata.Album
        $_medium = $Metadata.Medium
        $_track  = $Metadata.Track

        $_lines += $this.RenderMediumNumber($_medium, $_album)
        $_lines += $this.RenderTrackNumber($_track, $_medium, $_album)
        $_lines += $this.RenderTrackTitle($_track)
        $_lines += $this.RenderAlbumArtist($_album, $_track)
        $_lines += $this.RenderAlbumTitle($_album, $_track)
        $_lines += $this.RenderAlbumLabels($_album)
        $_lines += $this.RenderPerformanceConductor($_track)
        $_lines += $this.RenderPerformancePerformer($_track)
        $_lines += $this.RenderWorkComposer($_track)
        $_lines += $this.RenderMusicalForm($_track)

        return $_lines
    }

    ###########################################################################
    #   Renderers
    #--------------------------------------------------------------------------
    #
    #   Renderers build sets of Vorbis Comment sharing the same data domain.
    #
    ###########################################################################

    # Render the album artist to Vorbis Comments. If the DynamicAlbum feature
    # is enabled, the album artist is read from the 'artist' element of the
    # album element. If this feature is disabled, the album artist is built
    # from the composers of the performed work.
    [string[]] RenderAlbumArtist($AlbumMetadata, $TrackMetadata)
    {
        [string[]] $_lines = @()

        # Extract album artist
        $_albumArtist = $AlbumMetadata.Artist.ToString()

        # DynamicAlbum mode: use music composers as album artists,
        # and register the real album artist as ORIGINAL*.
        if ($this.Features.DynamicAlbums)
        {
            # Original album artist
            $_res = $this.CreateVorbisComment(
                "OriginalAlbumArtist", $_albumArtist)
            if ($_res) { $_lines += $_res }

            # Extract composers
            $_composers = $TrackMetadata.Performance.Work.Composers

            [string[]] $_composerNames = @()
            foreach ($_composer in $_composers)
            {
                if ($this.DynamicAlbumRendering.AlbumArtistUseSortVariants)
                    { $_composerNames += $_composer.Name.SortName }
                else
                    { $_composerNames += $_composer.Name.FullName }
            }

            # Build album artist string
            $_virtualAlbumArtistFullName = (
                $_composerNames -join(
                    $this.DynamicAlbumRendering.AlbumArtistDelimiter))

            # Build Vorbis Comment
            $_res = $this.CreateVorbisComment(
                "AlbumArtist", ($_virtualAlbumArtistFullName))
            if ($_res) { $_lines += $_res }
        }

        # Standard mode: use the 'artist' element.
        else
        {
            $_res = $this.CreateVorbisComment(
                "AlbumArtist", $_albumArtist)
            if ($_res) { $_lines += $_res }
        }

        return $_lines
    }

    # Render the list of labels associated to an audio album to Vorbis Comment.
    [string[]] RenderAlbumLabels($AlbumMetadata)
    {
        [string[]] $_lines = @()

        foreach ($_label in $AlbumMetadata.Labels)
        {
            $_res = $this.CreateVorbisComment(
                "LabelFullLabel", $_label.ToString())
            if ($_res) { $_lines += $_res }
        }

        return $_lines
    }

    # Render the title of an audio album to Vorbis Comment. The return value of
    # this method depends on the status of the DynamicAlbums feature. If that
    # feature is disabled, the method returns Vorbis Comments describing the
    # real title of the album. If the feature enabled, the method returns the
    # real title of the album in ORIGINALALBUM VCs, and the performance title
    # as as the actual album title.
    [string[]] RenderAlbumTitle($AlbumMetadata, $TrackMetadata)
    {
        [string[]] $_lines = @()

        # Gather real album data
        $_realFullTitle = $AlbumMetadata.Title.FullTitle
        $_realSortTitle = $AlbumMetadata.Title.SortTitle
        $_realSubTitle  = $AlbumMetadata.Title.Subtitle

        # Dynamic mode: output both real album title and virtual title
        if($this.Features.DynamicAlbums)
        {
            $_res = $this.CreateVorbisComment(
                "OriginalAlbumFullTitle", $_realFullTitle)
            if ($_res) { $_lines += $_res }

            $_res = $this.CreateVorbisComment(
                "OriginalAlbumSortTitle", $_realSortTitle)
            if ($_res) { $_lines += $_res }

            $_res = $this.CreateVorbisComment(
                "OriginalAlbumSubtitle", $_realSubTitle)
            if ($_res) { $_lines += $_res }

            $_performanceAsString = $TrackMetadata.Performance.ToString()
            $_res = $this.CreateVorbisComment(
                "AlbumFullTitle", $_performanceAsString)
            if ($_res) { $_lines += $_res }
        }

        # Standard mode: use real album title.
        else
        {
            $_res = $this.CreateVorbisComment(
                "AlbumFullTitle", $_realFullTitle)
            if ($_res) { $_lines += $_res }

            $_res = $this.CreateVorbisComment(
                "AlbumSortTitle", $_realSortTitle)
            if ($_res) { $_lines += $_res }

            $_res = $this.CreateVorbisComment(
                "AlbumSubtitle", $_realSubTitle)
            if ($_res) { $_lines += $_res }
        }

        return $_lines
    }

    # Renders the medium number info of an album track to Vorbis Comments.
    # The return value of this method depends on the status of the
    # DynamicAlbums feature. If this feature is disabled, the method returns
    # the number of the medium owning the track on its parent album.
    # If the feature is enabled, real media numbers will be rendered as
    # a set of ORIGINAL* Vorbis Comments. At the difference of track numbers,
    # no virtual medium number will be created: media numbers will be disabled
    # as tracks are all consolidated into performance groups.
    [string[]] RenderMediumNumber($MediumMetadata, $AlbumMetadata)
    {
        [string[]] $_lines = @()

        # Get real track numbers
        $_realMediumNumber = $MediumMetadata.Number.ToString()
        $_realMediumTotal = $AlbumMetadata.Media.Count.ToString()
        $_realCombined = $($_realMediumNumber + "/" + $_realMediumTotal)

        # Dynamic mode: render real medium numbers to ORIGINAL* VCs
        if($this.Features.DynamicAlbums)
        {
            $_res = $this.CreateVorbisComment(
                "OriginalMediumNumberCombined", $_realCombined)
            if ($_res) { $_lines += $_res }

            $_res = $this.CreateVorbisComment(
                "OriginalMediumNumberSimple", $_realMediumNumber)
            if ($_res) { $_lines += $_res }

            $_res = $this.CreateVorbisComment(
                "OriginalMediumTotal", $_realMediumTotal)
            if ($_res) { $_lines += $_res }
        }

        # Standard mode: use real medium numbers
        else
        {
            $_res = $this.CreateVorbisComment(
                "MediumNumberCombined", $_realCombined)
            if ($_res) { $_lines += $_res }

            $_res = $this.CreateVorbisComment(
                "MediumNumberSimple", $_realMediumNumber)
            if ($_res) { $_lines += $_res }

            $_res = $this.CreateVorbisComment(
                "MediumTotal", $_realMediumTotal)
            if ($_res) { $_lines += $_res }
        }

        return $_lines
    }

    # Renders musical forms to Vorbis Comment.
    [string[]] RenderMusicalForm($TrackMetadata)
    {
        [string[]] $_lines = @()
        [string[]] $_forms = @()

        # Musical form associated to the parent work.
        $_forms += $TrackMetadata.Performance.Work.Form

        # Musical forms associated to each movement included in the track
        foreach ($_movement in $TrackMetadata.Movements)
        {
            foreach ($_form in $_movement.Forms)
            {
                $_forms += $_form.ToString()
            }
        }

        # Create Vorbis Comments
        foreach ($_form in $_forms)
        {
            $_res = $this.CreateVorbisComment(
                "MusicalForm", $_form)
            if ($_res) { $_lines += $_res }

            # If forms should be registered as genres, let's do it.
            if($this.Features.MusicalFormAsGenre)
            {
                $_fullForm = $(
                    $this.Rendering.MusicalFormAsGenrePrefix + $_form)
                
                $_res = $this.CreateVorbisComment(
                    "Genre", $_fullForm)
                if ($_res) { $_lines += $_res }
            }
        }

        return $_lines
    } 

    # Renders the conductors of the music performance to Vorbis Comment.
    [string[]] RenderPerformanceConductor($TrackMetadata)
    {
        [string[]] $_lines = @()

        $_conductors = $TrackMetadata.Performance.Conductors

        foreach ($_conductor in $_conductors)
        {
            $_fullName  = $_conductor.Name.FullName
            $_shortName = $_conductor.Name.ShortName
            $_sortName  = $_conductor.Name.SortName

            $_res = $this.CreateVorbisComment(
                "ConductorFullName", $_fullName)
            if ($_res) { $_lines += $_res }

            $_res = $this.CreateVorbisComment(
                "ConductorShortName", $_shortName)
            if ($_res) { $_lines += $_res }

            $_res = $this.CreateVorbisComment(
                "ConductorSortName", $_sortName)
            if ($_res) { $_lines += $_res }

            # If conductors should be registered as artists, let's do it.
            if($this.Features.ConductorAsArtist)
            {
                $_res = $this.CreateVorbisComment(
                    "ArtistFullName", $_fullName)
                if ($_res) { $_lines += $_res }

                $_res = $this.CreateVorbisComment(
                    "ArtistShortName", $_shortName)
                if ($_res) { $_lines += $_res }
    
                $_res = $this.CreateVorbisComment(
                    "ArtistSortName", $_sortName)
                if ($_res) { $_lines += $_res }
            }
        }

        return $_lines
    }

    # Renders the performers of a music performance to Vorbis Comment.
    [string[]] RenderPerformancePerformer($TrackMetadata)
    {
        [string[]] $_lines = @()

        $_performers = $TrackMetadata.Performance.Performers

        foreach ($_performer in $_performers)
        {
            # Gather instrument suffix
            [string] $_instrumentSuffix = $(
                [VorbisCommentConverter]::NonBreakingSpace + `
                $_performer.PlayedInstrumentSuffix)

            # If the performer is an ensemble
            if ($_performer.Ensemble)
            {
                # Gather data
                [string] $_full  = $_performer.Ensemble.Label.FullLabel
                [string] $_short = $_performer.Ensemble.Label.ShortLabel
                [string] $_sort  = $_performer.Ensemble.Label.SortLabel

                # Assign optional instrument suffix
                if($this.Features.EnsembleInstrumentSuffix)
                    { [string] $_suffix = $_instrumentSuffix }
                else
                    { [string] $_suffix = "" }

                # Create Vorbis Comment
                $_res = $this.CreateVorbisComment(
                    "EnsembleFullLabel", $($_full + $_suffix))
                if ($_res) { $_lines += $_res }
    
                $_res = $this.CreateVorbisComment(
                    "EnsembleShortLabel", $($_short + $_suffix))
                if ($_res) { $_lines += $_res }
    
                $_res = $this.CreateVorbisComment(
                    "EnsembleSortLabel", $($_sort + $_suffix))
                if ($_res) { $_lines += $_res }

                # If ensembles should be registered as artists, let's do it.
                if($this.Features.EnsembleAsArtist)
                {
                    # Assign optional instrument suffix
                    if($this.Features.EnsembleAsArtistInstrumentSuffix)
                        { [string] $_suffix = $_instrumentSuffix }
                    else
                        { [string] $_suffix = "" }
                    
                    $_res = $this.CreateVorbisComment(
                        "ArtistFullName", $($_full + $_suffix))
                    if ($_res) { $_lines += $_res }

                    $_res = $this.CreateVorbisComment(
                        "ArtistShortName", $($_short + $_suffix))
                    if ($_res) { $_lines += $_res }
        
                    $_res = $this.CreateVorbisComment(
                        "ArtistSortName", $($_sort + $_suffix))
                    if ($_res) { $_lines += $_res }
                }
            }

            # If the performer is an instrumentalist
            elseif ($_performer.Instrumentalist)
            {
                # Gather data
                [string] $_full  = $_performer.Instrumentalist.Name.FullName
                [string] $_short = $_performer.Instrumentalist.Name.ShortName
                [string] $_sort  = $_performer.Instrumentalist.Name.SortName

                # Assign optional instrument suffix
                if($this.Features.InstrumentalistInstrumentSuffix)
                    { [string] $_suffix = $_instrumentSuffix }
                else
                    { [string] $_suffix = "" }

                # Create Vorbis Comment
                $_res = $this.CreateVorbisComment(
                    "InstrumentalistFullName", $($_full + $_suffix))
                if ($_res) { $_lines += $_res }
    
                $_res = $this.CreateVorbisComment(
                    "InstrumentalistShortName", $($_short + $_suffix))
                if ($_res) { $_lines += $_res }
    
                $_res = $this.CreateVorbisComment(
                    "InstrumentalistSortName", $($_sort + $_suffix))
                if ($_res) { $_lines += $_res }

                # If instrumentalists should be registered as performers,
                # let's do it.
                if($this.Features.InstrumentalistAsPerformer)
                {
                    # Assign optional instrument suffix
                    if($this.Features.InstrumentalistAsPerformerInstrumentSuffix)
                        { [string] $_suffix = $_instrumentSuffix }
                    else
                        { [string] $_suffix = "" }
                    
                    $_res = $this.CreateVorbisComment(
                        "PerformerFullName", $($_full + $_suffix))
                    if ($_res) { $_lines += $_res }

                    $_res = $this.CreateVorbisComment(
                        "PerformerShortName", $($_short + $_suffix))
                    if ($_res) { $_lines += $_res }
        
                    $_res = $this.CreateVorbisComment(
                        "PerformerSortName", $($_sort + $_suffix))
                    if ($_res) { $_lines += $_res }
                }

                # If instrumentalists should be registered as artists,
                # let's do it.
                if($this.Features.InstrumentalistAsArtist)
                {
                    # Assign optional instrument suffix
                    if($this.Features.InstrumentalistAsArtistInstrumentSuffix)
                        { [string] $_suffix = $_instrumentSuffix }
                    else
                        { [string] $_suffix = "" }
                    
                    $_res = $this.CreateVorbisComment(
                        "ArtistFullName", $($_full + $_suffix))
                    if ($_res) { $_lines += $_res }

                    $_res = $this.CreateVorbisComment(
                        "ArtistShortName", $($_short + $_suffix))
                    if ($_res) { $_lines += $_res }
        
                    $_res = $this.CreateVorbisComment(
                        "ArtistSortName", $($_sort + $_suffix))
                    if ($_res) { $_lines += $_res }
                }
            }
        }

        return $_lines
    }

    # Render the track number info of an album track to Vorbis Comment.
    # The return value of this method depends on the status of the
    # DynamicAlbums feature. If this feature is disabled, the method returns
    # the real track number of the track on its parent album. If the feature
    # is enabled, it returns Vorbis Comments describing the order of appearance
    # of the track in the music performance. The real track number is returned
    # as a set of ORIGINALTRACKNUM VCs.
    [string[]] RenderTrackNumber(
        $TrackMetadata, $MediumMetadata, $AlbumMetadata)
    {
        [string[]] $_lines = @()

        # Get real track numbers
        $_realTrackNumber = $TrackMetadata.Number.ToString()
        $_realTrackTotal = $MediumMetadata.Tracks.Count.ToString()
        $_realCombined = $($_realTrackNumber + "/" + $_realTrackTotal)

        # Dynamic mode: use both real and virtual track numbers
        if($this.Features.DynamicAlbums)
        {
            $_res = $this.CreateVorbisComment(
                "OriginalTrackNumberCombined", $_realCombined)
            if ($_res) { $_lines += $_res }

            $_res = $this.CreateVorbisComment(
                "OriginalTrackNumberSimple", $_realTrackNumber)
            if ($_res) { $_lines += $_res }

            $_res = $this.CreateVorbisComment(
                "OriginalTrackTotal", $_realTrackTotal)
            if ($_res) { $_lines += $_res }

            # Get the list of all tracks linked to the same performance
            # We explicitely sort media and tracks to get an ordered array
            # of album tracks.
            [Object[]] $_tracks = @()

            foreach ($_medium in (
                $AlbumMetadata.Media | Sort-Object -Property Number))
            {
                foreach ($_track in (
                    $_medium.Tracks | Sort-Object -Property Number))
                {
                    if ($_track.Performance -eq $TrackMetadata.Performance)
                    {
                        $_tracks += $_track
                    }
                }
            }

            # Locate current track in the array and use the index as a track
            # number. Total tracks is equal to the size of the array.
            $_trackNumber = ($_tracks.IndexOf($TrackMetadata) + 1).ToString()
            $_trackTotal  = ($_tracks.Count).ToString()
            $_combined    = $($_trackNumber + "/" + $_trackTotal)

            # Output Vorbis Comments
            $_res = $this.CreateVorbisComment(
                "TrackNumberCombined", $_combined)
            if ($_res) { $_lines += $_res }

            $_res = $this.CreateVorbisComment(
                "TrackNumberSimple", $_trackNumber)
            if ($_res) { $_lines += $_res }

            $_res = $this.CreateVorbisComment(
                "TrackTotal", $_trackTotal)
            if ($_res) { $_lines += $_res }
        }

        # Standard mode: use real track number.
        else
        {
            $_res = $this.CreateVorbisComment(
                "TrackNumberCombined", $_realCombined)
            if ($_res) { $_lines += $_res }

            $_res = $this.CreateVorbisComment(
                "TrackNumberSimple", $_realTrackNumber)
            if ($_res) { $_lines += $_res }

            $_res = $this.CreateVorbisComment(
                "TrackTotal", $_realTrackTotal)
            if ($_res) { $_lines += $_res }
        }

        return $_lines
    }

    # Render the title of an album track to Vorbis Comment. The return value of
    # this method depends on the status of the DynamicAlbums feature. If that
    # feature is disabled, the method returns Vorbis Comments describing the
    # real title of the track. If the feature enabled, the method returns the
    # real title of the track in ORIGINALTITLE VCs, and the movement title
    # as a the actual track title.
    [string[]] RenderTrackTitle($TrackMetadata)
    {
        [string[]] $_lines = @()

        # Gather real album data
        $_realFullTitle = $TrackMetadata.Title.FullTitle
        $_realSortTitle = $TrackMetadata.Title.SortTitle
        $_realSubTitle  = $TrackMetadata.Title.Subtitle

        # Dynamic mode: output both real and virtual track titles
        if($this.Features.DynamicAlbums)
        {
            $_res = $this.CreateVorbisComment(
                "OriginalTrackFullTitle", $_realFullTitle)
            if ($_res) { $_lines += $_res }

            $_res = $this.CreateVorbisComment(
                "OriginalTrackSortTitle", $_realSortTitle)
            if ($_res) { $_lines += $_res }

            $_res = $this.CreateVorbisComment(
                "OriginalTrackSubtitle", $_realSubTitle)
            if ($_res) { $_lines += $_res }

            $_trackString = $TrackMetadata.ToString()
            $_res = $this.CreateVorbisComment(
                "TrackFullTitle", $_trackString)
            if ($_res) { $_lines += $_res }
        }

        # Standard mode: use real track title.
        else
        {
            $_res = $this.CreateVorbisComment(
                "TrackFullTitle", $_realFullTitle)
            if ($_res) { $_lines += $_res }

            $_res = $this.CreateVorbisComment(
                "TrackSortTitle", $_realSortTitle)
            if ($_res) { $_lines += $_res }

            $_res = $this.CreateVorbisComment(
                "TrackSubtitle", $_realSubTitle)
            if ($_res) { $_lines += $_res }
        }

        return $_lines
    }

    # Renders the composers of the music work to Vorbis Comment.
    [string[]] RenderWorkComposer($TrackMetadata)
    {
        [string[]] $_lines = @()

        $_composers = $TrackMetadata.Performance.Work.Composers

        foreach ($_composer in $_composers)
        {
            $_fullName  = $_composer.Name.FullName
            $_shortName = $_composer.Name.ShortName
            $_sortName  = $_composer.Name.SortName

            $_res = $this.CreateVorbisComment(
                "ComposerFullName", $_fullName)
            if ($_res) { $_lines += $_res }

            $_res = $this.CreateVorbisComment(
                "ComposerShortName", $_shortName)
            if ($_res) { $_lines += $_res }

            $_res = $this.CreateVorbisComment(
                "ComposerSortName", $_sortName)
            if ($_res) { $_lines += $_res }

            # If composers should be registered as artists, let's do it.
            if($this.Features.ComposerAsArtist)
            {
                $_res = $this.CreateVorbisComment(
                    "ArtistFullName", $_fullName)
                if ($_res) { $_lines += $_res }

                $_res = $this.CreateVorbisComment(
                    "ArtistShortName", $_shortName)
                if ($_res) { $_lines += $_res }
    
                $_res = $this.CreateVorbisComment(
                    "ArtistSortName", $_sortName)
                if ($_res) { $_lines += $_res }
            }
        }

        return $_lines
    } 
}