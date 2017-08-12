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

    ###########################################################################
    # Hidden properties
    ###########################################################################

    ###########################################################################
    # Visible properties
    ###########################################################################

    [hashtable] $Features = @{
        DynamicAlbums   =   $false;
    }

    # Default Vorbis Comment labels.
    # May be altered by configuration values passed to the constructor.
    [hashtable] $VorbisLabels = @{
        AlbumFullTitle              =   "ALBUM";
        AlbumSortTitle              =   "ALBUMSORT";
        AlbumSubtitle               =   "";
        ArtistFullName              =   "ARTIST";
        LabelFullLabel              =   "LABEL";
        OriginalAlbumFullTitle      =   "ORIGINALALBUM";
        OriginalTrackNumberCombined =   "ORIGINALTRACKNUM";
        OriginalTrackNumberSimple   =   "ORIGINALTRACK";
        OriginalAlbumSortTitle      =   "ORIGINALALBUMSORT";
        OriginalAlbumSubtitle       =   "ORIGINALALBUMSUBTITLE";
        OriginalTrackFullTitle      =   "ORIGINALTITLE";
        OriginalTrackSortTitle      =   "ORIGINALTITLESORT";
        OriginalTrackSubtitle       =   "ORIGINALSUBTITLE";
        OriginalTrackTotal          =   "ORIGINALTRACKTOTAL";
        TrackFullTitle              =   "TITLE";
        TrackNumberCombined         =   "TRACKNUM";
        TrackNumberSimple           =   "TRACK";
        TrackSortTitle              =   "TITLESORT";
        TrackSubtitle               =   "SUBTITLE";
        TrackTotal                  =   "TRACKTOTAL";
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

        $_lines += $this.RenderAlbumTitle($_album, $_track)
        $_lines += $this.RenderAlbumLabels($_album)
        $_lines += $this.RenderTrackNumber($_track, $_medium, $_album)
        $_lines += $this.RenderTrackTitle($_track)

        return $_lines
    }

    ###########################################################################
    #   Renderers
    #--------------------------------------------------------------------------
    #
    #   Renderers build sets of Vorbis Comment sharing the same data domain.
    #
    ###########################################################################

    # Render the list of labels associated to an audio album to Vorbis Comment.
    [string[]] RenderAlbumLabels($AlbumMetadata)
    {
        [string[]] $_lines = @()

        foreach ($_label in ($this.ExtractAlbumLabels($AlbumMetadata)))
        {
            $_res = $this.CreateVorbisComment("LabelFullLabel", $_label)
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
        $_realFullTitle = $this.ExtractAlbumFullTitle($AlbumMetadata)
        $_realSortTitle = $this.ExtractAlbumSortTitle($AlbumMetadata)
        $_realSubTitle  = $this.ExtractAlbumSubTitle($AlbumMetadata)

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

            $_performanceString = (
                $this.ExtractTrackPerformanceString($TrackMetadata))
            $_res = $this.CreateVorbisComment(
                "AlbumFullTitle", $_performanceString)
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
        $_realTrackNumber = (
            $this.ExtractTrackNumber($TrackMetadata)).ToString()
        $_realTrackTotal = (
            $this.ExtractMediumTotalTracks($MediumMetadata)).ToString()
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

            # Get virtual track number; virtual total tracks
            # Use the performance uid to compare and count each track in the album.
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
        $_realFullTitle = $this.ExtractTrackFullTitle($TrackMetadata)
        $_realSortTitle = $this.ExtractTrackSortTitle($TrackMetadata)
        $_realSubTitle  = $this.ExtractTrackSubTitle($TrackMetadata)

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

            $_trackString = $this.ExtractTrackString($TrackMetadata)
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

    ###########################################################################
    #   Data extractors
    #--------------------------------------------------------------------------
    #
    #   Data extractors extract various types of data from UMS metadata.
    #   They provide these data to renderers, which wrap them into
    #   Vorbis Comments.
    #
    ###########################################################################

    # Extracts and returns a list of album labels from album metadata.
    [string[]] ExtractAlbumLabels($AlbumMetadata)
    {
        [string[]] $_labels = @()

        foreach ($_label in $AlbumMetadata.Labels)
        {
            $_labels += $_label.ToString()
        }

        return $_labels
    }

    # Extracts and returns the full title of an album from its metadata.
    [string] ExtractAlbumFullTitle($AlbumMetadata)
    {
        return $AlbumMetadata.Title.FullTitle
    }

    # Extracts and returns the full title of an album from its metadata.
    [string] ExtractAlbumSortTitle($AlbumMetadata)
    {
        return $AlbumMetadata.Title.SortTitle
    }

    # Extracts and returns the subtitle of an album from its metadata.
    [string] ExtractAlbumSubtitle($AlbumMetadata)
    {
        return $AlbumMetadata.Title.Subtitle
    }

    # Extracts and returns the total number of tracks in a medium.
    [int] ExtractMediumTotalTracks($MediumMetadata)
    {
        return $MediumMetadata.Tracks.Count
    }

    # Extracts and returns the string representation of a music performance.
    [string] ExtractTrackPerformanceString($TrackMetadata)
    {
        return $TrackMetadata.Performance.ToString()
    }

    # Extracts and returns the real full title of an album track.
    [string] ExtractTrackFullTitle($TrackMetadata)
    {
        return $TrackMetadata.Title.FullTitle
    }

    # Extracts and returns the real track number of an album track.
    [int] ExtractTrackNumber($TrackMetadata)
    {
        return $TrackMetadata.Number
    }

    # Extracts and returns the real sort title of an album track.
    [string] ExtractTrackSortTitle($TrackMetadata)
    {
        return $TrackMetadata.Title.SortTitle
    }  

    # Extracts and returns the string representation of an album track.
    [string] ExtractTrackString($TrackMetadata)
    {
        return $TrackMetadata.ToString()
    }

    # Extracts and returns the real subtitle of an album track.
    [string] ExtractTrackSubtitle($TrackMetadata)
    {
        return $TrackMetadata.Title.Subtitle
    } 

    # Returns the total number of media in an album.
    [int] ExtractAlbumMediumCount($AlbumMetadata)
    {
        return $AlbumMetadata.Media.Count
    }
}