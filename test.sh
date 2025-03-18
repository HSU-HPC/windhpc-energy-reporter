t_start=$(date +%s)

sleep 190

t_end=$(date +%s)

echo $t_start $t_end
python3 ./energy-reporter.py $t_start $t_end n012001 n012201 n012401 n012601
