# primed-bcftools

This repository contains WDLs for using bcftools on AnVIL for the PRIMED consortium.

## extract_vcf_ids

This workflow uses [bcftools query] to extract variant identifiers with the form of CHR:POS:REF:ALT from a set of VCFs.

Inputs:

input | description
--- | ---
vcf_file  | Array of vcf files to extract ids from
pass_only | Boolean indicator of whether only pass variants should be included, using FILTER=PASS.

Outputs:

output | description
--- | ---
variant_file | File containing the extracted variant ids, one per line
