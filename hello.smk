rule hello:
    input: "hello.smk"
    output:
        expand("output/{i}.txt", i=["0", "1", "2", "3"])
    shell:
        """
        for i in {{0..3}}
        do
            echo $i hello > {output["$i"]}
        done
        """
