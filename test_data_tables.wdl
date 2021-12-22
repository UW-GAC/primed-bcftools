version 1.0

workflow test_data_tables {
    input {
        Array[String] sample_list
        Array[String] pop_list
    }

    call results {
        input: sample_list = sample_list,
               pop_list = pop_list
    }

    output {
        File output_file = results.output_file
    }

     meta {
          author: "Stephanie Gogarten"
          email: "sdmorris@uw.edu"
     }
}

task results {
    input {
        Array[String] sample_list
        Array[String] pop_list
    }

    command {
        echo ${sep=' ' sample_list} > output.txt
        echo ${sep=' ' pop_list} >> output.txt
    }

    output {
        File output_file = "output.txt"
    }

    runtime {
        docker: "us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:3.14.0"
    }
}
