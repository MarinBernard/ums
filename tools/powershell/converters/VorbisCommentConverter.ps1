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
        DynamicAlbums       =   $false;
        ComposerAsArtist    =   $false;
    }

    # Default Vorbis Comment labels.
    # May be altered by configuration values passed to the constructor.
    [hashtable] $VorbisLabels = @{
        AlbumArtistFullName             =   "ALBUMARTIST"
        AlbumArtistShortName            =   "ALBUMARTISTSHORT"
        AlbumArtistSortName             =   "ALBUMARTISTSORT"
        AlbumFullTitle                  =   "ALBUM";
        AlbumSortTitle                  =   "ALBUMSORT";
        AlbumSubtitle                   =   "";
        ArtistFullName                  =   "ARTIST";
        ArtistShortName                 =   "ARTISTSHORT";
        ArtistSortName                  =   "ARTISTSORT";
        ComposerFullName                =   "COMPOSER";
        ComposerShortName               =   "COMPOSERSHORT";
        ComposerSortName                =   "COMPOSERSORT";
        LabelFullLabel                  =   "LABEL";
        MediumNumberCombined            =   "MEDIUMNUM";
        MediumNumberSimple              =   "MEDIUM";
        MediumTotal                     =   "MEDIUMTOTAL";
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

        $_lines += $this.RenderAlbumArtist($_album, $_track)
        $_lines += $this.RenderAlbumTitle($_album, $_track)
        $_lines += $this.RenderAlbumLabels($_album)
        $_lines += $this.RenderMediumNumber($_medium, $_album)
        $_lines += $this.RenderTrackNumber($_track, $_medium, $_album)
        $_lines += $this.RenderTrackTitle($_track)
        $_lines += $this.RenderWorkComposer($_track)

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
        $_albumArtist = $this.ExtractAlbumArtist($AlbumMetadata)
        $_albumArtistAsString = $this.ExtractAsString($_albumArtist)

        # DynamicAlbum mode: use music composers as album artists
        if ($this.Features.DynamicAlbums)
        {
            $_performance = $this.ExtractTrackPerformance($TrackMetadata)
            $_work = $this.ExtractPerformanceWork($_performance)
            $_composers = $this.ExtractWorkComposers($_work)

            [string[]] $_segments = @()

            foreach ($_composer in $_composers)
            {
                $_segments += $this.ExtractPersonSortName($_composer)
            }
            
            $_res = $this.CreateVorbisComment(
                "AlbumArtistFullName", ($_segments -join(" & ")))
            if ($_res) { $_lines += $_res }
        }

        # Standard mode: use the 'artist' element.
        else
        {
            $_res = $this.CreateVorbisComment(
                "AlbumArtistFullName", $_albumArtistAsString)
            if ($_res) { $_lines += $_res }
        }

        return $_lines
    }

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
                $this.ExtractAsString(
                    $this.ExtractTrackPerformance($TrackMetadata)))
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
        $_realMediumNumber = (
            $this.ExtractMediumNumber($MediumMetadata)).ToString()
        $_realMediumTotal = (
            $this.ExtractAlbumTotalMedia($AlbumMetadata)).ToString()
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

            $_trackString = $this.ExtractAsString($TrackMetadata)
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

        $_performance = $this.ExtractTrackPerformance($TrackMetadata)
        $_work = $this.ExtractPerformanceWork($_performance)
        $_composers = $this.ExtractWorkComposers($_work)

        foreach ($_composer in $_composers)
        {
            $_fullName  = $this.ExtractPersonFullName($_composer)
            $_sortName  = $this.ExtractPersonSortName($_composer)
            $_shortName = $this.ExtractPersonShortName($_composer)

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

    ###########################################################################
    #   Data extractors
    #--------------------------------------------------------------------------
    #
    #   Data extractors extract various types of data from UMS metadata.
    #   They provide these data to renderers, which wrap them into
    #   Vorbis Comments.
    #
    ###########################################################################

    # Extracts and returns the main artist of an album.
    [string] ExtractAlbumArtist($AlbumMetadata)
    {
        return $AlbumMetadata.Artist
    }

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

    # Returns the total number of media in an album.
    [int] ExtractAlbumMediumCount($AlbumMetadata)
    {
        return $AlbumMetadata.Media.Count
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

    # Extracts and returns the total number of media in an album.
    [int] ExtractAlbumTotalMedia($AlbumMetadata)
    {
        return $AlbumMetadata.Media.Count
    }

    # Extracts and returns the string representation of an object.
    [string] ExtractAsString($Object)
    {
        return $Object.ToString()
    }

    # Extracts and returns the real number of an album medium.
    [int] ExtractMediumNumber($MediumMetadata)
    {
        return $MediumMetadata.Number
    }

    # Extracts and returns the total number of tracks in a medium.
    [int] ExtractMediumTotalTracks($MediumMetadata)
    {
        return $MediumMetadata.Tracks.Count
    }

    # Extracts and returns the performed work from a performance.
    [object] ExtractPerformanceWork($PerformanceMetadata)
    {
        return $PerformanceMetadata.Work
    }

    # Returns the full name of a person.
    [string] ExtractPersonFullName($Person)
    {
        return $Person.Name.FullName
    }

    # Returns the short name of a person.
    [string] ExtractPersonShortName($Person)
    {
        return $Person.Name.ShortName
    } 

    # Returns the sort name of a person.
    [string] ExtractPersonSortName($Person)
    {
        return $Person.Name.SortName
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

    # Returns the performance included in an album track.
    [object] ExtractTrackPerformance($TrackMetadata)
    {
        return $TrackMetadata.Performance
    }

    # Extracts and returns the real sort title of an album track.
    [string] ExtractTrackSortTitle($TrackMetadata)
    {
        return $TrackMetadata.Title.SortTitle
    }  

    # Extracts and returns the real subtitle of an album track.
    [string] ExtractTrackSubtitle($TrackMetadata)
    {
        return $TrackMetadata.Title.Subtitle
    }

    # Extracts and returns a list of composers from a music work.
    [object[]] ExtractWorkComposers($WorkMetadata)
    {
        return $WorkMetadata.Composers
    }
}