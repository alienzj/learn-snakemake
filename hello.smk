rule hello:
    input: "hello.smk"
    output: "output/hello.txt"
    shell:
        '''
        for i in {{0..3}}
        do
            echo $i hello >> {output}
        done
        '''
