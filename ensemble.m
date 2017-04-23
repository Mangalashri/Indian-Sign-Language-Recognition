function answer=ensemble(a,b,c)
    s1=double(a);
    s2=double(b);
    s3=double(c);
    if s1-s2==0 && s2-s3==0
        answer=s1;
    elseif s1-s2==0
        answer=s1;
    elseif s1-s3==0
        answer=s1;
    elseif s2-s3==0
        answer=s2;
    else
        answer=s1;
    end
end 
    