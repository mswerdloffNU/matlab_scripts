function [tones] = generateTones(n)
a = n/30;
b = n/10;

vector = zeros(a,b);

for ii = 1:b
    randNumber = 1;
    randPosition = randperm(a);  %% Generates values 0 through 9
    vector(randPosition(1),ii) = randNumber;
    tones = vector(:);
    
    for nn = 1:n
        while tones(nn) == 1 && tones(nn+1) == 1
            randNumber = 1;
            randPosition = randperm(a);  %% Generates values 0 through 9
            vector(randPosition(1),ii) = randNumber;
        end
    end
end
tones = vector(:);
end