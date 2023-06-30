function swapped = swappy(func)
%   takes a function and swaps the right half with the left half

l = length(func);

mid = l/2;

right_vals = func(mid + 1:l);
left_vals = func(1:mid);
swapped = zeros(size(func));
swapped(1:mid) = right_vals;
swapped(mid+1:l) = left_vals;

end