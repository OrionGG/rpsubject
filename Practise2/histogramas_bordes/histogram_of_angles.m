function hist_of_angles = histogram_of_angles (grad_angles, grad_magnitude, NUM_BINS, MIN_VALUE, MAX_VALUE)

BIN_SIZE  = (MAX_VALUE - MIN_VALUE) / (NUM_BINS);

bin_index                = floor((grad_angles - MIN_VALUE)./BIN_SIZE) + 1;
bin_index(bin_index < 1) = 1;
bin_index(bin_index > NUM_BINS) = NUM_BINS;
  
hist_of_angles  = zeros(1, NUM_BINS);    
for b=1:NUM_BINS
  hist_of_angles(b) = sum(grad_magnitude(bin_index == b));
end
