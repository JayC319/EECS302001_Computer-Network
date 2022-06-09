
%find the original transmitted message P(x)
crc = [1 0 0 0 0 0 1 0 0 1 1 0 0 0 0 0 1 0 0 0 1 1 1 0 1 1 0 1 1 0 1 1 1];
remainder = myCRC(packet, crc);
codepacket2 = [packet, remainder];

%The pratical way is to add C(x) to P(x)
tempError = [zeros(1, 11999), crc];
MaximumAllowed = 10;
currentError = tempError;

% since the least significant bit of the C(x) is 1
% thus we can propage back to the most significant bit
% and xor the C(x) if the rightermost bit is 1
% xoring the function in this way makes the new P(x) 
% still divisable by C(x)
for i = 2:12000
    j = 12032 - i + 1;
    tempError(j-32:j) = xor(tempError(j-32:j), crc * tempError(j));
    tempCount = 0;
    
    for k = 1:32
        if tempError(j-k) == 1
            tempCount = tempCount + 1;
        end
    end
    
    if tempCount < MaximumAllowed
        currentError = tempError;
        MaximumAllowed = tempCount;
    end
    
end


% the following part counts for the different part of the function after 
% adding the error function
different = 0;
changed = xor(currentError, codepacket2);

for count = 1:12032
        if xor(changed(count), codepacket2(count))
            different = different + 1;
        end
end

error = currentError;

% to check whether there is remainder with the error funciton added
remainder = myCRC(changed,crc);


% myCRC function declaration
function remainder = myCRC(b,a)
    len_b = length(b);
    len_a = length(a);
    b = [b, zeros(1, len_a-1)];

    if len_a > len_b
    remainder = b;
    else
        q = zeros(1, len_b);
        for i = 1:len_b
             q(i) = b(i);
             b(i:i+len_a-1) = xor(b(i:i + len_a-1) , a * b(i));
        end
        remainder = b(len_b+1:len_b + len_a-1);
    end
end




