cntwhole=1;

for cnt1 =0:2^(-4):8-2^(-4)
    a=cnt1;

    for cnt2=0:2^(-3):4-2^(-3)
        b= cnt2;
        c = float_Plus(a,b);
        c_real = a + b;
        if c_real > 8-2^-1
            c_real =8-2^-1; 
        end

        err = abs(c_real-c); 
        a_group(cntwhole)=a; 
        b_group(cntwhole)= b;
        c_group(cntwhole)= c;
        c_real_group(cntwhole)= c_real;
        err_group(cntwhole)= err;
        cntwhole = cntwhole + 1;
    end 
end

figure;plot(err_group);grid on;





function c = float_Plus(a,b)
%% 函数功能
    % a:3位整数，4位小数； b: 2位整数，3位小数； 
    % c:3位整数，1位小数，无符号，要求四舍五入，位宽是4位

%% 函数逻辑
a2 = floor(a* 2^4 );%a定点化，位宽3+4=7位:将四位小数全部变成整数
b2 = floor(b* 2^3 ) * 2;%b定点化，位宽2+3+1=6位，但是加法需要将小数点对齐，因此要*2，又扩了一个bit，位宽是6

if(a2 > 2^7 - 1)%%没有溢出保护
    a2 = a2 - 2^7;
end
if(b2 > 2^5 - 1)
    b2 = b2 - 2^5;
end

c2 = a2 + b2;%3位整数，4位小数
if(c2 > 2^8 - 1)%%无符号加法的话，max{7,6}+1 = 8
    c2 = c2 - 2^8;
end

%进行四舍五入
%要求的3位整数，四舍五入：先向右移动3-1位；+1；||再向右移动1位
c3 = floor(c2 / (2 ^ 2) )+1;%有3+2 = 5位整数，4 -2 = 2位小数

if(c3 > 2^7 - 1)
    c3 = c3 - 2^7;
end

c4 = floor(c3 / 2);%有5+1=6位整数，2-1=1位小数


%c溢出保护
if(c4 > 2^4 - 1)
    c = 2^4 - 1;
else
    c = c4;%有6位整数，1位小数
end

%% RTL的逻辑到此就结束了

c = floor(c / 2);%有7位整数0位小数

end