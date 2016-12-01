#!/bin/bash

#rake import:movies 
#rake import:ratings
#rake import:imdb_search
#rake import:imdb_fields

rake import:movies >> import_movies_log.txt &
rake import:ratings >> import_ratings_log.txt &
rake import:imdb_search && rake import:imdb_fields
