Adecimal = 12.5;
Bdecimal = 43.5;
 fprintf('%.5f + %.5f =\n', Adecimal ,Bdecimal); 
Abinary = d2b(Adecimal);
Bbinary = d2b(Bdecimal); 
fprintf('%s + %s =\n', Abinary ,Bbinary); 
[sA,eA,mA] = splitbin(Abinary);
[sB,eB,mB] = splitbin(Bbinary);
dif=0;
flag=0; 
r=0;
if bin2dec(eA)>bin2dec(eB)
    dif= bin2dec(eA)-bin2dec(eB);
    [eB,r]=add(eB, dec2bin(dif));
    mB=shift(mB,dif);
    Bbinary= char(strcat(sB,strcat(eB,mB)));
elseif bin2dec(eB)>bin2dec(eA) 
    dif= bin2dec(eB)-bin2dec(eA);
    [eA,r]=add(eA, dec2bin(dif));
    mA=shift(mA,dif);
    Abinary= char(strcat(sA,strcat(eA,mA)));
end 
 fprintf('%s + %s =\n', Abinary ,Bbinary); 
 [mant,r] =add(mA,mB);
 [eA,r] =add(eA,r);
 if dif ==1
 mant = char(extractBetween(strcat('0',mant),1,23));
 end
 b2d(strcat(sA,strcat(eA,mant))); 
 
function bin =d2b(dec)
    bin = char(dec2bin(typecast(single(dec), 'uint32')));
    if length(bin)<32
        for i=1:32-length(bin)
            bin= strcat('0',bin);
        end
    end
    bin = char(bin);
end
function dec = b2d(bin)
[s,e,m] = splitbin(bin);
s = bin2dec(extractBetween(bin,1,1));%
e = bin2dec(extractBetween(bin,2,9));%
Dm=0;%
    for i= 1:23
        Dm = Dm+str2num(m(i))*2^(i*-1);
    end
 dec=(-1)^s *(1+Dm)*2^(e-127);
 fprintf('%s which equals %.10f in decimal\n', bin ,dec); 
end
function [s,e,m] = splitbin(bin)    
    s = char(extractBetween(bin,1,1));%
    e = char(extractBetween(bin,2,9));%
    m = char(extractBetween(bin,10,32)); %
end
function [exp,r] = add(e,offset)
result=0;
r=0;
if(length(e)>length(offset))
    l=length(e)-length(offset);
    for i=l:-1:1
    offset=strcat('0',offset);
    end
end
if(length(offset)>length(e))
    l=length(offset)-length(e);
    for i=l:-1:1
    e=strcat('0',e);
    end
end
exp = e;
l=length(e);
%fprintf('%s #\n%s #\n',e,offset);
for i=l:-1:1
    if(str2num(e(i))+ str2num(offset(i))+ r == 2)
        exp(i)='0';
        r= 1;
    elseif (str2num(e(i))+ str2num(offset(i))+ r == 3)
        exp(i)='1';
        r= 1; 
    elseif (str2num(e(i))+ str2num(offset(i))+ r == 1)
        exp(i)='1';
        r=0;
    else
        exp(i)='0';
        r=0;
    end
end  
r=dec2bin(r);
exp =char(exp);
%fprintf('%s R\n',exp);
end
function m = shift(mant, offset) 
    mant= strcat('1',mant);
    offset=offset-1;
    for i=1:offset
        mant= strcat('0',mant);
    end
     
    m= char(extractBetween(mant,1,23));
end
