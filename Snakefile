#!/usr/bin/env snakemake
import os


include: "hello.smk"

rule all:
    input:
        "output/hello.txt"
