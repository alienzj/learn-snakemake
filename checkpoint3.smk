ASMER = ["asmer_1"]
BINNER = ["binner_1", "binner_2", "binner_3"]
SAMPLES = ["s1", "s2"]


rule prepare_input_s1:
    output:
        expand("prepare_input/{asmer}.{binner}/s1/done",
               asmer=ASMER,
               binner=BINNER)
    run:
        shell('''mkdir -p prepare_input/asmer_1.binner_1/s1''')
        shell('''mkdir -p prepare_input/asmer_1.binner_2/s1''')
        shell('''mkdir -p prepare_input/asmer_1.binner_3/s1''')

        for i in output:
            shell(f'''touch {i}''')

        shell('''touch prepare_input/asmer_1.binner_1/s1/s1.1.fa''')
        shell('''touch prepare_input/asmer_1.binner_2/s1/{{s1.1.fa,s1.2.fa}}''')
        shell('''touch prepare_input/asmer_1.binner_3/s1/{{s1.1.fa,s1.2.fa,s1.3.fa,s1.4.fa}}''')


rule prepare_input_s2:
    output:
        expand("prepare_input/{asmer}.{binner}/s2/done",
               asmer=ASMER,
               binner=BINNER)
    run:
        shell('''mkdir -p prepare_input/asmer_1.binner_1/s2''')
        shell('''mkdir -p prepare_input/asmer_1.binner_2/s2''')
        shell('''mkdir -p prepare_input/asmer_1.binner_3/s2''')

        for i in output:
            shell(f'''touch {i}''')

        shell('''touch prepare_input/asmer_1.binner_1/s2/{{s2.1.fa,s2.2.fa,s2.3.fa}}''')
        shell('''touch prepare_input/asmer_1.binner_2/s2/{{s2.1.fa,s2.2.fa,s2.3.fa,s2.4.fa}}''')
        shell('''touch prepare_input/asmer_1.binner_3/s2/{{s2.1.fa,s2.2.fa,s2.3.fa,s2.4.fa}}''')


checkpoint prepare_output:
    input:
        expand("prepare_input/{{asmer}}.{{binner}}/{sample}/done",
               sample=SAMPLES)
    output:
        directory("prepare_output/{asmer}.{binner}.out")
    run:
        from glob import glob

        fa_list = []
        for i in input:
            fa_list += glob(os.path.dirname(i) + "/*.fa")

        for j in range(0, len(fa_list), 2):
            shell(f'''mkdir -p {output}/bins_{j}''')


rule scan_output:
    input:
        "prepare_output/{asmer}.{binner}.out/bins_{batchid}"
    output:
        "scan_output/{asmer}.{binner}.out/{batchid}.txt"
    params:
        batchid = "{batchid}"
    shell:
        '''
        echo {params.batchid} >> {output}
        '''


def aggregate_scan_output(wildcards):
    checkpoint_output = checkpoints.prepare_output.get(**wildcards).output[0]

    return expand("scan_output/{asmer}.{binner}.out/{batchid}.txt",
                  asmer=wildcards.asmer,
                  binner=wildcards.binner,
                  batchid=sorted(list(set([i.split("/")[0] \
                                           for i in glob_wildcards(os.path.join(
                                                   checkpoint_output,
                                                   "bins_{batchid}")).batchid]))))


rule scan_report:
    input:
        aggregate_scan_output
    output:
        "scan_merge/{asmer}.{binner}.out/all.txt"
    shell:
        '''
        cat {input} > {output}
        '''


rule all:
    input:
        expand("scan_merge/{asmer}.{binner}.out/all.txt",
               asmer=ASMER,
               binner=BINNER)
