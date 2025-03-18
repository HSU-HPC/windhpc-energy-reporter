# WindHPC-energy-reporter
The script **energy-reporter.py** reads recorded power data from an InfluxDB, integrates the data and reports the consumed energy per node.

## Basic usage

**energy-reporter.py** is controled via the command line:

`energy-reporter.py time_start time_end node_0 node_1 node-2 ...`

time_start and time_end must be in timestamp format, i.e. seconds since 1970-01-01 00:00:00 UTC.

The list of nodes must contain one or more of the nodes for which data is returned from the database.

At HLRS, the following nodes are available:

- n012001
- n012201
- n012401
- n012601
- n012801


## Usage in job script
```
t_start=$(date +%s)

your code

t_end=$(date +%s)
python3 ./energy-reporter.py $t_start $t_end n012001 n012201 n012401 n012601
```


## Adaption
In order to use the script on other systems, the url and the token in the creation of the `client` object must be adapted. 
