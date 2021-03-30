rule all:
    input:
        "empty_output/hello.txt"


save_world = True

rule hello:
    output:
        hello = "empty_output/hello.txt",
        world = "empty_output/world.txt" if save_world else ""
    run:
        shell(
            '''
            echo "hello" > {output.hello}
            ''')
        if save_world:
            shell(
                '''
                echo "world" > {output.world}
                ''')
