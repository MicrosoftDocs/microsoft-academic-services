#Requires -Version 7

<#
  This script helps users link the sample private library data with MAG entities and enrich the library paper data by adding linked MAG entity information such as fields of study, structured author/affiliation, DOI, citations, and abstracts.
#>


#region Script Configuration

# The input library paper data file for entity linking
$privateLibraryPapersFilePath = 'samplePrivateLibraryData.json'
# The output linked library paper data file
$linkedPrivateLibraryPapersFilePath = 'samplePrivateLibraryData.linked.json'
# The MAKES API instance endpoint to leverage for entity linking
$makesEndpoint = '' # e.g 'http://mymakeshost.westus.cloudapp.azure.com'
# The MAKES Interpret endpoint to leverage for entity linking
$interpretEntpoint = $makesEndpoint + "/interpret"
# The minimum interpretation logprob/score required for entity linking
$minLogProbForLinking = -50
# The default logprob/score for library papers that can't be linked with MAG entities
$defaultLogProbForUnlinkedEntities = -20

#endregion Script Configuration

#region Utility Functions

# <snippet_merge_entities> 
# Adds various MAG paper entity information to library paper entity
function Merge-MagEntity {
    param($privateLibraryPaper, $magEntity)
    
    # add mag Id 
    $privateLibraryPaper | Add-Member -MemberType NoteProperty -Name 'Id' -Value  $magEntity.Id

    # add logprob/rank
    $privateLibraryPaper | Add-Member -MemberType NoteProperty -Name 'logprob' -Value  $magEntity.logprob

    # add DOI
    if ($null -ne $magEntity.DOI)
    {
        $privateLibraryPaper | Add-Member -MemberType NoteProperty -Name 'DOI' -Value  $magEntity.DOI
    }

    # add year
    if ($null -ne $magEntity.Y)
    {
        $privateLibraryPaper | Add-Member -MemberType NoteProperty -Name 'Year' -Value  $magEntity.Y
    }
    
    # add venue full name
    if ($null -ne $magEntity.VFN)
    {
        $privateLibraryPaper | Add-Member -MemberType NoteProperty -Name 'VenueFullName' -Value  $magEntity.VFN
    }

    # add citation count
    $privateLibraryPaper | Add-Member -MemberType NoteProperty -Name 'CitationCount' -Value  $magEntity.CC

    # add estimated citation count 
    $privateLibraryPaper | Add-Member -MemberType NoteProperty -Name 'EstimatedCitationCount' -Value  $magEntity.ECC

    # add fields of study 
    $fieldsOfStudy = @()
    foreach($fos in $magEntity.F)
    {
        $fieldsOfStudy += 
        @{ 
            OriginalName = $fos.DFN;
            Name = $fos.FN;
        }
    }
    $privateLibraryPaper | Add-Member -MemberType NoteProperty -Name 'FieldsOfStudy' -Value  $fieldsOfStudy

    # add structured author affiliations
    $authorAffiliations = @()
    foreach ($authorAffiliation in $magEntity.AA)
    {
        $temp = @{
            OriginalAuthorName = $authorAffiliation.DAuN;
            AuthorName = $authorAffiliation.AuN;
        }

        if ($null -ne $authorAffiliation.DAfN)
        {
            $temp.OriginalAffiliationName = $authorAffiliation.DAfN;
        }
        if ($null -ne $authorAffiliation.AfN)
        {
            $temp.AffiliationName = $authorAffiliation.AfN;
        }
        if ($null -ne $authorAffiliation.S)
        {
            $temp.Sequence = $authorAffiliation.S;
        }
        $authorAffiliations += $temp;
    }
    $privateLibraryPaper | Add-Member -MemberType NoteProperty -Name 'AuthorAffiliations' -Value  $authorAffiliations

    # add abstract by reconstructing it from inverted abstract
    if ($null -ne $magEntity.IA)
    {
        $abstractWords = [string[]]::new($magEntity.IA.IndexLength)
        foreach ($pair in $magEntity.IA.InvertedIndex.GetEnumerator())
        {
            $abstractWord = $pair.Name
            foreach ($index in $pair.Value)
            {
                $abstractWords[$index] = $abstractWord
            }
        }
        $abstract = [string]::Join(" ", $abstractWords)
        $privateLibraryPaper | Add-Member -MemberType NoteProperty -Name 'OriginalAbstract' -Value  $abstract
    }
}
# </snippet_merge_entities> 

# Converts a string to normalized form for search
function ConvertTo-NormalizedStr {
    param($str)
    # replace all non-alphanumeric characters with a space
    $str = [Regex]::Replace($str, "[^\d\w]", " ")
    # reduce all instances of 1+ spaces to a single space
    $str = [Regex]::Replace($str, "\s+", " ")
    # convert to lower case
    $str = $str.ToLower()
    return $str
}

# Converts a string to a distinct words array
function ConvertTo-DistinctWordsArray {
    param($str)
    # get words array from string
    $words = $str.Split(' ', [System.StringSplitOptions]::RemoveEmptyEntries)
    # get unique words
    $words = $words | select-object -unique 
    return $words
}

# Adds title and abstract search attributes for a library paper by transforming its original title and abstract
function Edit-AddSearchAttribues
{
    param($libraryPaper)

    # add normalized title attribute for title search
    $normalizedTitle = ConvertTo-NormalizedStr $libraryPaper.OriginalTitle
    # add normlized title words for partial title search
    $titleWords = ConvertTo-DistinctWordsArray $normalizedTitle
    $titleComposite = @{
        Name = $normalizedTitle;
        OriginalName = $libraryPaper.OriginalTitle;
        Words = $titleWords;
    };
    $libraryPaper | Add-Member -MemberType NoteProperty -Name 'Title' -Value  $titleComposite


    # add normalized abstract words for partial abstract search
    if ($null -ne $libraryPaper.OriginalAbstract)
    {
        $normalizedAbstract = ConvertTo-NormalizedStr $libraryPaper.OriginalAbstract
        $abstractWords = ConvertTo-DistinctWordsArray $normalizedAbstract
        $abstractComposite = @{
            Name = $normalizedAbstract;
            OriginalName = $libraryPaper.OriginalAbstract;
            Words = $abstractWords;
        }        
        $libraryPaper | Add-Member -MemberType NoteProperty -Name 'Abstract' -Value  $abstractComposite
    }

    # add normalized doi for attribute search
    if ($null -ne $libraryPaper.DOI)
    {
        $normalizedDOI = ConvertTo-NormalizedStr $libraryPaper.DOI
        $libraryPaper.DOI = @{
            OriginalName = $libraryPaper.DOI;
            Name = $normalizedDOI;
        };
    }

    # add normalized full text url for attribute search
    if ($null -ne $libraryPaper.FullTextUrl)
    {
        $normalizedFullTextUrl = ConvertTo-NormalizedStr $libraryPaper.FullTextUrl
        $libraryPaper.FullTextUrl = @{
            OriginalName = $libraryPaper.FullTextUrl;
            Name = $normalizedFullTextUrl;
        };
    }
}

#endregion Utility Functions

#region Script Main/Script Entry Point

# read library paper json data
$privateLibraryPapers = (Get-Content $privateLibraryPapersFilePath | Out-String | ConvertFrom-Json)

Write-Host "Linked | ConfidenceScore | OriginalTitle | MagTitle"

# loop through each presentation to link with MAG entities
foreach ($privateLibraryPaper in $privateLibraryPapers)
{
    # <snippet_interpret_request> 
    # link entity by using MAKES Interpret API
    $interpretRequestBody = @{
        #  attempt to link library paper with papers in MAG via title
        query = "title: " + $privateLibraryPaper.OriginalTitle;
        complete = 0;
        normalize = 1;
        attributes = "Id,DN,F.DFN,F.FN,AA.DAuN,AA.AuN,AA.DAfN,AA.AfN,AA.S,IA,DOI,Y,VFN,CC,ECC";
        count = 1;
        entityCount = 1;
        timeout = 2000;
    }
    # </snippet_interpret_request> 
  
    # submit interpret request and parse response as json
    $interpretResponse = Invoke-WebRequest $interpretEntpoint -Body $interpretRequestBody -Method 'POST'
    $interpretResponseContentJson = $interpretResponse.Content | ConvertFrom-Json -AsHashTable

    # <snippet_interpret_log_probability_as_confidence_score>
    # the interpretation log probability includes the entity log probability. 
    # to get the fitness/confidence score of the interpretation, we must exclude the log probability of the entity
    $linkedEntity = $interpretResponseContentJson.interpretations[0].rules[0].output.entities[0]
    $entityLinkScore = $interpretResponseContentJson.interpretations[0].logprob - $linkedEntity.logprob

    # only link library paper with MAG entity that has a high confidence score/logprob
    if ( $null -ne $entityLinkScore -and $entityLinkScore -gt $minLogProbForLinking)
    {
        Merge-MagEntity $privateLibraryPaper $linkedEntity
        Write-Host "True" "|" $entityLinkScore "|" $privateLibraryPaper.OriginalTitle "|" $linkedEntity.DN
    } 
    else 
    {
        # add default logprob/score for entities that can't be linked with MAG entities
        $privateLibraryPaper | Add-Member -MemberType NoteProperty -Name 'logprob' -Value $defaultLogProbForUnlinkedEntities
        Write-Host "False" "|" $entityLinkScore "|" $privateLibraryPaper.OriginalTitle "|" $interpretResponseContentJson.interpretations[0].rules[0].output.entities[0].DN
    }
    # </snippet_interpret_log_probability_as_confidence_score>

    # add search attributes by transforming existing entity attributes
    Edit-AddSearchAttribues $privateLibraryPaper
}

#output each entity json with a new line seperator for building index
foreach ($privateLibraryPaper in $privateLibraryPapers)
{
    $privateLibraryPaper | ConvertTo-Json -depth 30 -Compress | Out-File $linkedPrivateLibraryPapersFilePath -Append
}

#endregion Script Main/Script Entry Point