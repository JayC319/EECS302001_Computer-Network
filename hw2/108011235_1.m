crc = [1 0 0 0 0 0 1 0 0 1 1 0 0 0 0 0 1 0 0 0 1 1 1 0 1 1 0 1 1 0 1 1 1];

remainder = myCRC(packet, crc);
codepacket = [packet,remainder];

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