#!/usr/bin/env snakemake
import os


include: "hello.smk"

rule all:
    input:
        expand("output/{i}.txt", i=["0", "1", "2", "3"])
