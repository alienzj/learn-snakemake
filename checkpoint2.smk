# reference: https://github.com/snakemake/snakemake/issues/132

rule all:
    input:
        "d.txt"

'''
checkpoint a:  # <-- change to rule to not have the error anymore
    output:
        'a.txt'
    shell:
        "touch {output}"
'''

rule a:  # <-- change to rule to not have the error anymore
    output:
        'a.txt'
    shell:
        "touch {output}"

rule b:
    input:
        "a.txt"
    output:
        pipe('b.txt')
    shell:
        "touch {output}"

rule c:
    input:
        "b.txt"
    output:
        'c.txt'
    shell:
        "touch {output}"

rule d:
    input:
        a="a.txt",
        c="c.txt"
    output:
        'd.txt'
    shell:
        "touch {output}"
