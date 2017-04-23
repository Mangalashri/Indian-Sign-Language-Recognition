function display = invertedindex(inputkeywords)
    %% 
    %Index table construction
    global sentences;
    j=1;
    sks={};
    IT=cell2table(cell(10,2));
    IT.Properties.VariableNames={'Keyword' 'Sn'};
    for i=1:height(sentences)
        temp=strsplit(sentences.Kl(i),',');
        [a b]=size(temp);
        for l=1:b
            K=temp(l);
            ref=find(strcmp(sks,K));
            if (ref>0)
               rows = strcmp(IT.Keyword,K);
               newSn=IT.Sn(rows);
               newSn=[newSn,sentences.Sn(i)];
               r=double(rows);
               ans=find(r,1);
               [r1 c1]=size(newSn)
               arr='' 
               for q=1:c1
                   if(q==c1)
                      arr=strcat(arr,string(newSn(q)));
                   else 
                   arr=strcat(arr,string(newSn(q)),',')
                   end 
               end 
               IT.Sn(ans)=cellstr(arr);
            else 
                IT.Keyword(j)=cellstr(K);
                IT.Sn(j)=cellstr(sentences.Sn(i));
                sks(j)=cellstr(K);
                j=j+1;
            end 
        end  
     end 
    %%
    %Sentence Interpretation using Index Table - some fields are hardcoded as of now
    %inputkeywords={'Correct'}
    %inputkeywords={'How','Old','You'}
    %inputkeywords={'You','Fly'}
    %inputkeywords={'What','Time','Now'};
    %inputkeywords={'Time','8'};
    %inputkeywords={'pray','varanasi'};
    %inputkeywords={'1','Bottle'};
    i1=0;
    [x y]=size(inputkeywords)
    display='';
    notable=0;
    for m=1:y %Go to speech if there is any number in the input - No table
        k1=inputkeywords(m);
        [num,status] = str2num(char(cellstr(k1)));
        display=strcat(display,{' '},string(k1));
        if status==1
            notable=1;
        end
    end 
    if notable==1
        texttospeech(cellstr(display));
        return;
    end
    for m=1:y
        k1=regexprep(inputkeywords(m),'(\<[a-z])','${upper($1)}');
        rows1=strcmp(IT.Keyword,k1);
        indexarray=double(rows1);
        ans1=find(indexarray,1);
        if(isempty(ans1)==1) %Go to speech if there is no sentence for any input word - No table
            display=''
            for m=1:y
                k1=inputkeywords(m);
                %k1=regexprep(inputkeywords(m),'(\<[a-z])','${upper($1)}');
                display=strcat(display,{' '},string(k1));
            end 
            texttospeech(display);
            return;
         else
             O(m,1)=IT.Sn(ans1);
             z(m)=string(cell2mat(O(m,1)))
         end 
     end
     if(y==1) %If there is only one word as input
        F=char(z(1,1));
        sentences=strsplit(F,',');
        F=char(sentences(1,1))
        result(1,1)='S';
        [f1 f2]=size(F);
        for i=1:f2-1
             result(1,i+1)=F(1,i);
        end
     else
         str1=char(z(1,1));
         str2=char(z(1,2));
         F=intersect(str1,str2);
         if(y>2)
            for m=3:y
                temp=F;
                F=intersect(temp,char(z(1,m)));
            end 
         end
         if(isempty(F)==1) %Go to speech if there is no common sentence - No table
            display=''
            for m=1:y
                k1=inputkeywords(m);
                %k1=regexprep(inputkeywords(m),'(\<[a-z])','${upper($1)}');
                display=strcat(display,{' '},string(k1));
            end 
            texttospeech(display);
          elseif(F(1,1)==',')
                result(1,1)='S';
                [f1 f2]=size(F);
                 for i=2:f2-1
                    result(1,i)=F(1,i);
                 end
                result=F(1,2)
                result(1,2)=result(1,1)
                result(1,1)='S';
         else
                result(1,1)='S';
                [f1 f2]=size(F);
                 for i=1:f2-1
                    result(1,i+1)=F(1,i);
                 end
            end 
        end
        ansindex=strcmp(sentences.Sn,string(result))
        ansindexarray=double(ansindex);
        answer=find(ansindexarray,1);
        display=cellstr(sentences.S(answer))
        texttospeech(display);
    end 
