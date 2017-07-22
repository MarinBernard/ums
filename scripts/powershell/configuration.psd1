@{
    UMS = @{

        MetadataStorage = @{
            FolderName      =   "ums"
            HiddenFolders   =   $true
        }

        MetadataFiles = @{
            Extension       =   ".xml"
            MainFileName    =   "metadata"
            StaticFileName  =   "metadata.static"
        }

        Schemas = @{
            Common  =   @{
                URI     =   "http://schemas.olivarim.com/ums/1.0/common"
                Path    =   "C:\Users\marin\Desktop\Universal Metadata System\1.0\schemas\common.rng"
            }
            
            Music  =   @{
                URI     =   "http://schemas.olivarim.com/ums/1.0/music"
                Path    =   "C:\Users\marin\Desktop\Universal Metadata System\1.0\schemas\music.rng"
            }            
        }

        Stylesheets = @{
            Expander    =   "C:\Users\marin\Desktop\Universal Metadata System\1.0\stylesheets\music\expander\expander.xsl"
            Music2VC    =   "C:\Users\marin\Desktop\Universal Metadata System\1.0\stylesheets\music\music2vc\music2vc.xsl"
        }
    }

    Tools = @{
        Java    =   "C:\Program Files\Java\jre1.8.0_131\bin\java.exe"
        Jing    =   "C:\Program Files\XMLBlueprint 13\JavaLib\jing-trang-20151127\bin\jing.jar"
        SaxonPE =   "C:\Program Files\XMLBlueprint 13\JavaLib\SaxonPE9-7-0-18J\saxon9pe.jar"
    }
}