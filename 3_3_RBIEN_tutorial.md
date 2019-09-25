---
title: "RBIEN Tutorial"
author: "Brian Maitner"
---


[<i class="fa fa-file-code-o fa-3x" aria-hidden="true"></i> The R Script associated with this page is available here](3_3_RBIEN_tutorial.R).  Download this file and open it (or copy-paste into a new script) with RStudio so you can follow along.  


# Setup
<!-- You can download`BRI -->

```r
#install_github("bmaitner/RBIEN/BIEN")
library(BIEN)
library(ape) #Package for working with phylogenies in R
library(maps) #Useful for making quick maps of occurrences
library(sp) # A package for spatial data
```

# Overview 
It is often easiest to start with our vignette. Particularly useful are the "Function Names" and "Function Directory" sections.


```r
vignette("BRI")
```

The function names follow a consistent naming strategy, and mostly consist of 3 parts:

1. The prefix "BIEN_" 
2. The type of data being accessed, e.g. "occurrence_"
3. How you'll be querying the data.  For example, the suffix "state" refers to functions that return data for a specified state.

As a complete example, the function `BIEN_occurrence_species` returns occurrence records for a given species (or set of species).

# Function Families
Currently we have 10 function families in RBIEN.  These are sets of functions that access a given type of data.

1. occurrence records (BIEN_occurrence_...)
2. range maps (BIEN_ranges_...)
3. plot data (BIEN_plot_...)
4. trait data (BIEN_trait_...)
5. taxonomic information (BIEN_taxonomy_...)
6. phylogenies (BIEN_phylogeny_...)
7. stem data (BIEN_stem_...)
8. species lists (BIEN_list_...)
9. metadata (BIEN_metadata_...)
10. custom queries (BIEN_sql)


We'll walk through each of the function families and take a look at some the options available within each.

# Occurrence records

These functions begin with the prefix "BIEN_occurrence_" and allow you to query occurrences by either taxonomy or geography.  Functions include:

1. `BIEN_occurrence_country` Returns all occurrence records within a given country

2. `BIEN_occurrence_state` Returns all occurrences records within a given state/province

3.  `BIEN_occurrence_county` Returns all occurrences records within a given state/province

3. `BIEN_occurrence_family` Returns all occurrence records for a specified family

4. `BIEN_occurrence_genus` Returns all occurrence records for a specified genus

5. `BIEN_occurrence_species` Returns all occurrence records for a specified species

6. `BIEN_occurrence_state` Returns all occurrences records within a given state/province


Each of these functions has a number of different arguments that modify your query, either refining your search criteria or returning more data for each record.  These arguments include:

1. `cultivated`  If TRUE, records known to be cultivated will be returned.

2. `only.new.world` If TRUE, records returned are limited to those in North and South America, where greater data cleaing and validation has been done.

* Note that the arguments cultivated and only.new.world may change the number of records returned.

3. `all.taxonomy` If TRUE, the query will return additional taxonomic data, including the uncorrected taxonomic information for those records.

4. `native.status` If TRUE, additional information will be returned regarding whether a species is native in a given region.

5. `observation.type`  If TRUE, the query will return whether each record is from either a plot or a specimen.  This may be useful if a user believes one type of information may be more accurate.

6. `political.boundaries` If TRUE, the query will return information on which country, state, etc. that an occurrence is found within.

7. `print.query` If TRUE, the function will print the SQL query that it used.  This is mostly useful for users looking to create their own custom queries (which should be done with caution).


## Example 1: Occurrence records for a species

Okay, enough reading.  Let's get some data.

Let's say we're interested in the species *Xanthium strumarium* and we'd like some occurrence data.  
<!-- We'll use the function `BIEN_occurrence_species` to grab the occurrence data. -->


```r
Xanthium_strumarium <- BIEN_occurrence_species(species = "Xanthium strumarium")
```

<!-- Take a moment and view the dataframe and take a look at the structure -->


```r
#View(Xanthium_strumarium)
head(Xanthium_strumarium)
str(Xanthium_strumarium)
```

The default data that is returned consists of the latitude, longitude and date collected, along with a set of attribution data.  If we want more information on these occurrences, we just need to change the arguments:


```r
Xanthium_strumarium_full <- BIEN_occurrence_species(species = "Xanthium strumarium",cultivated = T,only.new.world = F,all.taxonomy = T,native.status = T,observation.type = T,political.boundaries = T)

str(Xanthium_strumarium_full)
```

```
## 'data.frame':	6356 obs. of  33 variables:
##  $ scrubbed_species_binomial   : chr  "Xanthium strumarium" "Xanthium strumarium" "Xanthium strumarium" "Xanthium strumarium" ...
##  $ verbatim_family             : chr  "Asteraceae" "Asteraceae" "Asteraceae" "Asteraceae" ...
##  $ verbatim_scientific_name    : chr  "Xanthium strumarium L." "Xanthium chinense Mill." "Xanthium strumarium L." "Xanthium strumarium L." ...
##  $ family_matched              : chr  "Asteraceae" "Asteraceae" "Asteraceae" "Asteraceae" ...
##  $ name_matched                : chr  "Xanthium strumarium" "Xanthium chinense" "Xanthium strumarium" "Xanthium strumarium" ...
##  $ name_matched_author         : chr  "L." "Mill." "L." "L." ...
##  $ higher_plant_group          : chr  "flowering plants" "flowering plants" "flowering plants" "flowering plants" ...
##  $ taxonomic_status            : chr  "accepted" "accepted" "accepted" "accepted" ...
##  $ scrubbed_family             : chr  "Asteraceae" "Asteraceae" "Asteraceae" "Asteraceae" ...
##  $ scrubbed_author             : chr  "L." "L." "L." "L." ...
##  $ native_status               : chr  "UNK" "N" "UNK" "UNK" ...
##  $ native_status_reason        : chr  "Status unknown, no checklists for region of observation" "Native to region, as per checklist" "Status unknown, no checklists for region of observation" "Status unknown, no checklists for region of observation" ...
##  $ native_status_sources       : chr  "" "usda, vascan, tropicos" "" "" ...
##  $ isintroduced                : chr  NA "0" NA NA ...
##  $ native_status_country       : chr  "" "N" "" "" ...
##  $ native_status_state_province: chr  "" "" "" "" ...
##  $ native_status_county_parish : chr  "" "" "" "" ...
##  $ country                     : chr  "Argentina" "Canada" "Mexico" "Mexico" ...
##  $ state_province              : chr  "Cordoba" "Québec" "Sonora" "Sonora" ...
##  $ county                      : chr  NA NA "Guaymas Municipio" "General Plutarco Elías Calles Municipio" ...
##  $ locality                    : chr  "N of Abrojo" "St-Nicolas (Lévis).; habitat: Bord de chemin, haut de grève." "Roadside at south side of Guaymas airport; habitat: Disturbed habitat; desertscrub" "Pinacate Region, Rancho los Vidrios" ...
##  $ latitude                    : num  NA NA NA NA NA ...
##  $ longitude                   : num  NA NA NA NA NA ...
##  $ date_collected              : Date, format: NA "1963-09-05" ...
##  $ datasource                  : chr  "TRT" "QFA" "ARIZ" "ARIZ" ...
##  $ dataset                     : chr  "Royal Ontario Museum" "Université Laval" NA NA ...
##  $ dataowner                   : chr  "Royal Ontario Museum" "Université Laval" NA NA ...
##  $ custodial_institution_codes : chr  "Royal Ontario Museum" "Université Laval" NA NA ...
##  $ collection_code             : chr  "TRT" "QFA" NA NA ...
##  $ is_cultivated               : int  NA NA NA NA 0 NA NA 0 NA NA ...
##  $ is_cultivated_in_region     : chr  "0" "0" "0" "0" ...
##  $ is_new_world                : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ observation_type            : chr  "specimen" "specimen" "specimen" "specimen" ...
```

We now have considerably more information, but the query took longer to run.

Let's take a quick look at where those occurrences are.


```r
# Make a quick map to plot our points on

map('world',fill=T , col= "grey", bg="light blue") 

#Plot the points from the full query in red

points(cbind(Xanthium_strumarium_full$longitude,Xanthium_strumarium_full$latitude),col="red",pch=20,cex=1) 

# Plot the points from the default query in blue

points(cbind(Xanthium_strumarium$longitude,Xanthium_strumarium$latitude),col="blue",pch=20,cex=1) 
```

![](3_3_RBIEN_tutorial_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

From the map, we can see that the points from the default query (in blue) all fall within the New World.  The points from the full query (red + blue) additionally include occurrences from the Old World.  The points in the Old World have not gone through the same data validation procedures by BIEN as those in the New World, but may still be useful.

## Example 2: Occurrence records for a country

Since we may be interested in a particular geographic area, rather than a particular set of species, there are also options to easily extract data by political region as well.

<!-- We'll choose a relatively small region, the Bahamas, for our demonstration. -->


```r
Bahamas <- BIEN_occurrence_country(country =  "Bahamas")

#Let's see how many species we have
length(unique(Bahamas$scrubbed_species_binomial))
```

```
## [1] 999
```

```r
#Nearly 1000 species, not bad.

#Now, let's take a look at where those occurrences are:
map(regions = "Bahamas" ,fill=T , col= "grey", bg="light blue")

points(cbind(Bahamas$longitude,Bahamas$latitude),col="blue",pch=20,cex=1)
```

![](3_3_RBIEN_tutorial_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

```r
#Looks like some islands are considerably better sampled than others.
```


# Range maps

These functions begin with the prefix "BIEN_ranges_" and return (unsurprisingly) species ranges.  Most of these functions work by saving the downloaded ranges to a specified directory in shapefile format, rather than by loading them into the R environment.

Functions include:

1. `BIEN_ranges_species`  Downloads range maps for given species and save them to a specified directory.

2. `BIEN_ranges_genus`  Saves range maps for all species within a genus to a specified directory.

3. `BIEN_ranges_load_species`  This function returns the ranges for a set of species as a SpatialPolygonsDataFrame object.

The range functions have different arguments than we have seen so far, including:

1. `directory` This is where the function will be saving the shapefiles you download

2.  `matched`  If TRUE, the function will return a dataframe listing which species ranges were downloaded and which weren't.

3.  `match_names_only` If TRUE, the function will check whether a map is available for each species without actually downloading it

4. `include.gid` If TRUE, the function will append a unique gid number to each range map's filename.  This argument is designed to allow forward compatibility when BIEN contains multiple range maps for each species.

## Example 3: Range maps and occurrence points

To load a range map we can use the function `BIEN_ranges_load_species`.  
<!-- Let's try this for *Xanthium strumarium*. -->


```r
Xanthium_strumarium_range <- BIEN_ranges_load_species(species = "Xanthium strumarium")
# note that you might get an error here if you have an old version of the PROJ library
```

The range map is now in our global environment as a Spatial polygons dataframe. 
<!-- Let's plot the map and see what it looks like. -->


```r
#First, let's add a base map so that our range has some context:

map('world',fill=T , col= "grey", bg="light blue",xlim = c(-180,-20),ylim = c(-60,80))

#Now, we can add the range map:
plot(Xanthium_strumarium_range,col="green",add=T)
```

![](3_3_RBIEN_tutorial_files/figure-html/unnamed-chunk-10-1.png)<!-- -->

Now, let's add those occurrence points from earlier to this map:


```r
map('world',fill=T , col= "grey", bg="light blue",xlim = c(-180,-20),ylim = c(-60,80))
plot(Xanthium_strumarium_range,col="green",add=T)
points(cbind(Xanthium_strumarium$longitude,Xanthium_strumarium$latitude),col="blue",pch=20,cex=1)
```

![](3_3_RBIEN_tutorial_files/figure-html/unnamed-chunk-11-1.png)<!-- -->

# Plot data

These functions begin with the prefix "BIEN_plot_" and return ecological plot data.  Functions include:

1. `BIEN_plot_list_sampling_protocol` Returns the different plot sampling protocols found in the BIEN database.

2. `BIEN_plot_list_datasource` Returns the different datasources that are available in the BIEN database.

* These first two functions are useful for identifying plots with comparable sampling methods.

3. `BIEN_plot_sampling_protocol` Downloads data for a specified sampling protocol

4. `BIEN_plot_datasource` Downloads data for a specific datasource

* These next two function are then useful for downloading datasets with consistent methodology.

5. `BIEN_plot_country`

6. `BIEN_plot_state`

7. `BIEN_plot_dataset` Downloads data for a given dataset (which is nested within a datasource)

8. `BIEN_plot_name` Downloads data for a specific plot name (these are nested within a given dataset)

Again we have some of the same arguments available for these queries that we saw for the occurrence functions.  We also have the new argument *all.metadata*, which causes the functions to return more metadata for each plot.


## Example 4: Plot data by plot name

Let's take a look at the data for an individual plot.

```r
LUQUILLO <- BIEN_plot_name(plot.name = "LUQUILLO")
#View(LUQUILLO)
head(LUQUILLO)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["plot_name"],"name":[1],"type":["chr"],"align":["left"]},{"label":["subplot"],"name":[2],"type":["chr"],"align":["left"]},{"label":["elevation_m"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["plot_area_ha"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["sampling_protocol"],"name":[5],"type":["chr"],"align":["left"]},{"label":["recorded_by"],"name":[6],"type":["chr"],"align":["left"]},{"label":["scrubbed_species_binomial"],"name":[7],"type":["chr"],"align":["left"]},{"label":["individual_count"],"name":[8],"type":["int"],"align":["right"]},{"label":["latitude"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["longitude"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["date_collected"],"name":[11],"type":["function () ",".Internal(date())"],"align":["right"]},{"label":["datasource"],"name":[12],"type":["chr"],"align":["left"]},{"label":["dataset"],"name":[13],"type":["chr"],"align":["left"]},{"label":["dataowner"],"name":[14],"type":["chr"],"align":["left"]},{"label":["custodial_institution_codes"],"name":[15],"type":["chr"],"align":["left"]},{"label":["collection_code"],"name":[16],"type":["chr"],"align":["left"]}],"data":[{"1":"LUQUILLO","2":"1","3":"300","4":"0.1","5":"0.1 ha  transect, stems >= 2.5 cm dbh","6":"Alwyn H. Gentry","7":"Cyathea aquilina","8":"1","9":"NA","10":"NA","11":"<NA>","12":"SALVIAS","13":"Gentry Transect Dataset","14":"James S. MIller","15":"NA","16":"NA"},{"1":"LUQUILLO","2":"1","3":"300","4":"0.1","5":"0.1 ha  transect, stems >= 2.5 cm dbh","6":"Alwyn H. Gentry","7":"Dacryodes excelsa","8":"1","9":"18.1833","10":"-65.8333","11":"<NA>","12":"SALVIAS","13":"Gentry Transect Dataset","14":"James S. MIller","15":"NA","16":"NA"},{"1":"LUQUILLO","2":"1","3":"300","4":"0.1","5":"0.1 ha  transect, stems >= 2.5 cm dbh","6":"Alwyn H. Gentry","7":"Guarea guidonia","8":"1","9":"18.1833","10":"-65.8333","11":"<NA>","12":"SALVIAS","13":"Gentry Transect Dataset","14":"James S. MIller","15":"NA","16":"NA"},{"1":"LUQUILLO","2":"1","3":"300","4":"0.1","5":"0.1 ha  transect, stems >= 2.5 cm dbh","6":"Alwyn H. Gentry","7":"Paullinia pinnata","8":"1","9":"18.1833","10":"-65.8333","11":"<NA>","12":"SALVIAS","13":"Gentry Transect Dataset","14":"James S. MIller","15":"NA","16":"NA"},{"1":"LUQUILLO","2":"1","3":"300","4":"0.1","5":"0.1 ha  transect, stems >= 2.5 cm dbh","6":"NA","7":"Prestoea acuminata","8":"4","9":"18.1833","10":"-65.8333","11":"<NA>","12":"SALVIAS","13":"Gentry Transect Dataset","14":"James S. MIller","15":"NA","16":"NA"},{"1":"LUQUILLO","2":"1","3":"300","4":"0.1","5":"0.1 ha  transect, stems >= 2.5 cm dbh","6":"Alwyn H. Gentry","7":"Schefflera morototoni","8":"1","9":"18.1833","10":"-65.8333","11":"<NA>","12":"SALVIAS","13":"Gentry Transect Dataset","14":"James S. MIller","15":"NA","16":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

We can see that this is a 0.1 hectare transect where stems >= 2.5 cm diameter at breast height were included.  If we'd like more detail, we can use additional arguments:

```r
LUQUILLO_full <- BIEN_plot_name(plot.name = "LUQUILLO",cultivated = T,all.taxonomy = T,native.status = T,political.boundaries = T,all.metadata = T)
```


```r
#View(LUQUILLO_full)
head(LUQUILLO_full)
```

The dataframe LUQUILLO_full contains more useful information, including metadata on which taxa were included, which growth forms were included and information on whether species are known to be native or introduced.

# Trait data

These functions begin with the prefix "BIEN_trait_" and access the BIEN trait database.   Note that the spelling of the trait names must be precise, so we recommend using the function `BIEN_trait_list` first.

Functions include:

1. `BIEN_trait_list`  Start with this.  It returns a dataframe of the traits available.

2. `BIEN_trait_family`  Returns a dataframe of all trait data for a given family (or families).

3. `BIEN_trait_genus`

4. `BIEN_trait_species`

5. `BIEN_trait_trait` Downloads all records of a specified trait (or traits).

6. `BIEN_trait_mean` Estimates species mean trait values using genus or family level means where species-level data is absent.

7. `BIEN_trait_traitbyfamily` Downloads data for a given family (or families) and trait(s).

8. `BIEN_trait_traitbygenus`

9. `BIEN_trait_traitbyspecies`


## Example 5: Accessing trait data

If you're interested in accessing all traits for a taxon, say the genus *Salix*, just go ahead and use the corresponding function:


```r
Salix_traits<-BIEN_trait_genus(genus = "Salix")
```

If instead we're interested in a particular trait, the first step is to check if that trait is present and verify the spelling using the function `BIEN_trait_list`.


```r
BIEN_trait_list()
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["trait_name"],"name":[1],"type":["chr"],"align":["left"]}],"data":[{"1":"Area-based photosynthesis (Aarea)"},{"1":"Flowering date"},{"1":"Flowering month"},{"1":"Height"},{"1":"Leaf area"},{"1":"Leaf Cmass"},{"1":"Leaf dry mass"},{"1":"Leaf dry matter content (LDMC)"},{"1":"Leaf lifespan (LLS)"},{"1":"Leaf Narea"},{"1":"Leaf Nmass"},{"1":"Leaf Pmass"},{"1":"Mass-based photosynthesis (Amass)"},{"1":"seed mass"},{"1":"Specific leaf area (SLA)"},{"1":"Stomatal conductance (Gs)"},{"1":"wood density"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

If we're interested in Specific Leaf Area, we see that this is called "Specific leaf area (SLA)" in the database.  Now that we know the proper spelling, we can use the function `BIEN_trait_trait` to download all observations of that trait.


```r
SLA <- BIEN_trait_trait(trait = "Specific leaf area (SLA)")
```

Note that the units have been standardized and that there is a full set of attribution data for each trait.

#Taxonomy Data

While there are existing packages that query taxonomic data (e.g. those included in the taxize package), the RBIEN taxonomy functions access the taxonomic information that underlies the BIEN database, ensuring consistency.

1. `BIEN_taxonomy_family` Downloads all taxonomic information for a given family.

2. `BIEN_taxonomy_genus`

3. `BIEN_taxonomy_species`

## Example 6: Taxonomic data 

Let's say we're interested in the genus *Asclepias*, and we'd like to get an idea of how many species there are in this genus and what higher taxa it falls within.


```r
Asclepias_taxonomy<-BIEN_taxonomy_genus(genus = "Asclepias")

#View(Asclepias_taxonomy)
Asclepias_taxonomy[1:10,]
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["higher_plant_group"],"name":[1],"type":["chr"],"align":["left"]},{"label":["class"],"name":[2],"type":["chr"],"align":["left"]},{"label":["superorder"],"name":[3],"type":["chr"],"align":["left"]},{"label":["order"],"name":[4],"type":["chr"],"align":["left"]},{"label":["scrubbed_family"],"name":[5],"type":["chr"],"align":["left"]},{"label":["scrubbed_genus"],"name":[6],"type":["chr"],"align":["left"]},{"label":["scrubbed_species_binomial"],"name":[7],"type":["chr"],"align":["left"]},{"label":["scrubbed_author"],"name":[8],"type":["chr"],"align":["left"]},{"label":["scrubbed_taxonomic_status"],"name":[9],"type":["chr"],"align":["left"]}],"data":[{"1":"flowering plants","2":"Equisetopsida","3":"Asteranae","4":"Gentianales","5":"Apocynaceae","6":"Asclepias","7":"Asclepias aceratoides","8":"M.A.Curtis","9":"no opinion"},{"1":"flowering plants","2":"Equisetopsida","3":"Asteranae","4":"Gentianales","5":"Apocynaceae","6":"Asclepias","7":"Asclepias adscendens","8":"(Schltr.) Schltr.","9":"accepted"},{"1":"flowering plants","2":"Equisetopsida","3":"Asteranae","4":"Gentianales","5":"Apocynaceae","6":"Asclepias","7":"Asclepias aequicornu","8":"E. Fourn.","9":"accepted"},{"1":"flowering plants","2":"Equisetopsida","3":"Asteranae","4":"Gentianales","5":"Apocynaceae","6":"Asclepias","7":"Asclepias affinis","8":"(Schltr.) Schltr.","9":"accepted"},{"1":"flowering plants","2":"Equisetopsida","3":"Asteranae","4":"Gentianales","5":"Apocynaceae","6":"Asclepias","7":"Asclepias alba","8":"Cav.","9":"no opinion"},{"1":"flowering plants","2":"Equisetopsida","3":"Asteranae","4":"Gentianales","5":"Apocynaceae","6":"Asclepias","7":"Asclepias albens","8":"(E.Mey.) Schltr.","9":"accepted"},{"1":"flowering plants","2":"Equisetopsida","3":"Asteranae","4":"Gentianales","5":"Apocynaceae","6":"Asclepias","7":"Asclepias albicans","8":"S.Watson","9":"accepted"},{"1":"flowering plants","2":"Equisetopsida","3":"Asteranae","4":"Gentianales","5":"Apocynaceae","6":"Asclepias","7":"Asclepias alpestris","8":"(K.Schum.) Goyder","9":"accepted"},{"1":"flowering plants","2":"Equisetopsida","3":"Asteranae","4":"Gentianales","5":"Apocynaceae","6":"Asclepias","7":"Asclepias amabilis","8":"N.E.Br.","9":"accepted"},{"1":"flowering plants","2":"Equisetopsida","3":"Asteranae","4":"Gentianales","5":"Apocynaceae","6":"Asclepias","7":"Asclepias ameliae","8":"S.Moore","9":"accepted"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```r
#We see that the genus Asclepias falls within the family Apocynaceae and the order Gentianales.

#You'll also notice that a given species may appear more than once (due to multiple circumscriptions, some of which may be illegitimate).

#If we'd just like to know all the speciess that aren't illegitimate:
Asclepias_species<-unique(Asclepias_taxonomy$scrubbed_species_binomial[Asclepias_taxonomy$scrubbed_taxonomic_status %in% c("accepted",  "no opinion")])
```

# Phylogenies
The BIEN database currently contains 101 phylogenies for new world plants.  This includes 100 replicated phylogenies that include nearly all New World plant species ("complete phylogenies") and 1 phylogeny containing only those New World plant species for which molecular data was available ("conservative phylogeny"). Currently, there are 2 functions available:

1. `BIEN_phylogeny_complete`  This function will return a specified number of the replicated "complete" phylogenies.  Note that each phylogeny is several Mb in size, so downloading many may take a while on slow connections.

2. `BIEN_phylogeny_conservative` This function returns the conservative phylogeny.

Arguments: The function `BIEN_phylogeny_complete` has a few arguments that are worth explaining:

* `n_phylogenies` This is the number of replicated phylogenies that you want to download (between 1 and 100)

* `seed` This function sets the seed for the random number generator before randomly drawing the phylogenies to be downloaded.  This is useful for replicating analyses.

* `replicates` This function allows you to specify WHICH of the 100 phylogenies to download, rather than having them selected randomly.


## Example 7: Phylogenies 

Let's download the conservative phylogeny.


```r
phylo <- BIEN_phylogeny_conservative()

#Let's make sure it looks alright

plot.phylo(x = phylo, show.tip.label =  FALSE)
```

![](3_3_RBIEN_tutorial_files/figure-html/unnamed-chunk-19-1.png)<!-- -->

```r
#If we just want to see which species are included

phylo_species <- phylo$tip.label
```


# Stem Data

The BIEN datbase contains stem data associated with many of the plots.  This is typically either diameter at breast height or diameter at ground height.  At present, there is only one stem function (although expect more in the future):

1. `BIEN_stem_species` This function downloads all of the stem data for a given species (or set of species)

Arguments:

The arguments for this function are the same that we have seen in the occurrence and plot functions.

<!-- ## Example 8: Stem data  -->

# Species lists

These functions begin with the prefix "BIEN_list_" and allow you to quickly get a list of all the species in a geographic unit.  Functions include:

1. `BIEN_list_country` Returns all species found within a country.

2. `BIEN_list_state` Returns all species found within a given state/province

3.  `BIEN_list_county` Returns all species found within a given state/province

Some of the same arguments we saw in the occurrence functions appear here as well, including `cultivate`, `only.new.world`, and `print.query`.


## Example 9: Species list for a country

Let's return to our previous example.  What if we just need a list of the species in the Bahamas, rather than the specific details of each occurrence record?  We can instead use the function `BIEN_list_country` to download a list of species, which should be much faster than using `BIEN_occurrence_country` to get a species list.


```r
Bahamas_species_list<-BIEN_list_country(country = "Bahamas")

#Notice that this time, we have 998 species, whereas previously we saw that there were 999 unique species.  What happened?  The list functions ignore NA values for species names, but R does not.  R counted NA values as a unique species name, giving one extra unique value.
```

For multiple countries at once, supply a vector of countries.


```r
country_vector<-c("Haiti","Dominican Republic")
Haiti_DR <- BIEN_list_country(country = country_vector)
```

# Metadata
The BIEN metadata functions are still in development.  Currently, there are 2 functions:

1. `BIEN_metadata_database_version` Returns the current version number of the BIEN database and the release date.

2. `BIEN_metadata_match_data` Rudimentary function to check for changed records between old and current queries.

## Example 10: Metadata 

To check what the current version of the BIEN database is (which we recommend reporting when using BIEN data):


```r
BIEN_metadata_database_version()
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["db_version"],"name":[1],"type":["chr"],"align":["left"]},{"label":["db_release_date"],"name":[2],"type":["function () ",".Internal(date())"],"align":["right"]}],"data":[{"1":"3.4.1","2":"2017-01-04"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


# Custom Queries
We recommend avoiding custom queries where possible.  If you have an idea for a new function/functionality, contacting the package maintainer or submitting a note on the Github site for the package may be a better idea.  However, if you need to write your own SQL query, we recommend that you familiarize yourself with both postgresql and the BIEN database structure first.  Most of our functions have the argument "print.query" which will display the SQL query that the function utilized.  These queries can provide a starting point for custum queries (by adding or omitting parts of them).  These queries can then be executed using the function `BIEN_sql`.

1. `BIEN_sql` This function returns the results of a postgresql query.  This function is typically used as an internal function, but can be used for writing custom queries.

Arguments:

The argument `query` is the only one likely to be of use to users.  The other arguments are included for primarily for developmental purposes.

## Example 11: Writing your own query 
Let's return to our example from above where we downloaded the occurrence records for *Xanthium strumarium*.  Let's take a look at the query that underlies that:


```r
Xanthium_strumarium <- BIEN_occurrence_species(species = "Xanthium strumarium",print.query = T)
```

```
## [1] "SELECT scrubbed_species_binomial, latitude, longitude,date_collected,datasource,dataset,dataowner,custodial_institution_codes,collection_code FROM view_full_occurrence_individual WHERE scrubbed_species_binomial in ( 'Xanthium strumarium' ) AND (is_cultivated = 0 OR is_cultivated IS NULL) AND is_new_world = 1 AND higher_plant_group IS NOT NULL AND (is_geovalid = 1 OR is_geovalid IS NULL) ORDER BY scrubbed_species_binomial;"
```

We see that our query looks like this:

"SELECT scrubbed_species_binomial, latitude, longitude,date_collected,datasource,dataset,dataowner,custodial_institution_codes,collection_code FROM view_full_occurrence_individual WHERE scrubbed_species_binomial in ( 'Xanthium strumarium' ) AND (is_cultivated = 0 OR is_cultivated IS NULL) AND is_new_world = 1 AND higher_plant_group IS NOT NULL AND (is_geovalid = 1 OR is_geovalid IS NULL) ORDER BY scrubbed_species_binomial;"

Now, if we want to modify this to be more restrictive and only include occurrences that could be geovalidated and are not cultivated, that simply involves a few changes:

"SELECT scrubbed_species_binomial, latitude, longitude,date_collected,datasource,dataset,dataowner,custodial_institution_codes,collection_code FROM view_full_occurrence_individual WHERE scrubbed_species_binomial in ( 'Xanthium strumarium' ) AND (is_cultivated = 0 ) AND is_new_world = 1 AND higher_plant_group IS NOT NULL AND (is_geovalid = 1 ) ORDER BY scrubbed_species_binomial;"

We can now submit this new bit of code using `BIEN_sql`


```r
Xanthium_strumarium_modified <- BIEN_sql(query = "SELECT scrubbed_species_binomial, latitude, longitude,date_collected,datasource,dataset,dataowner,custodial_institution_codes,collection_code FROM view_full_occurrence_individual WHERE scrubbed_species_binomial in ( 'Xanthium strumarium' ) AND (is_cultivated = 0 ) AND is_new_world = 1 AND higher_plant_group IS NOT NULL AND (is_geovalid = 1 ) ORDER BY scrubbed_species_binomial;")

#This query only returns a fraction of the records the default query does, but for some purposes we may only want the highest quality records.
```

<!-- # Combining Queries -->
<!-- ## Example 12: Putting it all together ** -->
