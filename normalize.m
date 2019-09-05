function norm_vector=normalize(vector)
% function norm_data=normalize(data)

if min(size(vector))>1
    error('function needs a vector')
end

norm_vector=vector./max(vector);