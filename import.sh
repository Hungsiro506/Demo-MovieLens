#!/bin/bash

rake import:movies
rake import:ratings
rake import:imdb_search
rake import:imdb_fields

