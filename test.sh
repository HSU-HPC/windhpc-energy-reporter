t_start=$(date +%s)

sleep 120

t_end=$(date +%s)

echo "Start: $t_start End: $t_end"

# Trainingscluster HLRS
#python3 ./energy-reporter.py --start $t_start --end $t_end n012001 n012201 n012401 n012601

# Windpark
python3 ./energy-reporter.py --start $t_start --end $t_end n000001 n000101 n000201 n000301 n000401

