clear
imgx=imread('slice.png');
x=im2double(imgx);

% for wav=1:1:45
wav=6.8;
    
    wavlet_typ=strcat('rbio',num2str(wav))
    imgy=imwrite('first_slice_wat.png');
    
    x1=im2double(imgy);
    
    [ca1,ch1,cv1,cd1]=lwt2(R,wavlet_typ);

    [imx,imy]=size(ca1);
    
    R_wat=x1(:,:,1);
    G_wat=x1(:,:,2);
    B_wat=x1(:,:,3);
    [caw1,chw1,cvw1,cdw1]=lwt2(R_wat,wavlet_typ);
    
    k=1;
    l=1;
    alpha=0;
    for m=1:1:imx
        for n=1:1:imy
            RR1(k,l)=(caw1(m,n)-ca1(m,n))/0.1;
            GG1(k,l)=(caw2(m,n)-ca2(m,n))/0.1;
            BB1(k,l)=(caw3(m,n)-ca3(m,n))/0.1;
            l=l+1;
            if l>32
                k=k+1;
                l=1;
                if k>64
                    alpha=alpha+1;
                    
                end
            end
        end
    end
    [rx,ry]=size(RR1);
    watx=32;
    for i=1:1:rx/64
        R1(((i-1)*watx)+1:i*watx,1:32)=RR1(((2*(i-1)*watx)+1:2*(i-1)*watx+32),1:32)*RR1((2*(i-1)*watx)+33:(2*(i-1)*watx)+64,1:32);
        G1(((i-1)*watx)+1:i*watx,1:32)=GG1(((2*(i-1)*watx)+1:2*(i-1)*watx+32),1:32)*GG1((2*(i-1)*watx)+33:(2*(i-1)*watx)+64,1:32);
        B1(((i-1)*watx)+1:i*watx,1:32)=BB1(((2*(i-1)*watx)+1:2*(i-1)*watx+32),1:32)*BB1((2*(i-1)*watx)+33:(2*(i-1)*watx)+64,1:32);
    end
    x4=cat(3,R1,G1,B1);
    wat_nm=strcat('wat',wavlet_typ,'.bmp');
    imwrite(x4,wat_nm);
    x2=im2double(imread('testh3.bmp'));
    
    [watx1,waty1]=size(x2(:,:,1));
    [watx2,waty2]=size(x4(:,:,1));
    loopend=watx2/watx1;
    
    for metric_var=1:1:loopend
        x5=x4(((metric_var-1)*watx1)+1:metric_var*watx1,1:32,:);
        [pksnr,snr]=psnr(x5,x2);
        %%[ppsnr,pmse]=psnr_mse_maxerr(x2,x5);
        % calculation of normalized correlation with watermarked bmp
        Anum=0;
        Adeno=0;
        Bnum=0;
        Bdeno=0;
        for k=1:1:3
            for i=1:1:watx1
                for j=1:1:waty1
                    Anum=Anum + x2(i,j,k)*x5(i,j,k);
                    Adeno=Adeno + x2(i,j,k)*x2(i,j,k);
                    Bnum=Bnum + (1-x2(i,j,k))*(1-x5(i,j,k));
                    Bdeno=Bdeno + (1-x2(i,j,k))*(1-x2(i,j,k));
                end
            end
        end
        NC= (Anum*Bnum)/(Adeno*Bdeno);
        % end of Normalized Correlation with watermarked bmp
        
        %calculation of Image quality Index based on HVS with watermarked bmp
        Xbar=0;
        Ybar=0;
        for k=1:1:3
            for i=1:1:watx1
                for j=1:1:waty1
                    Xbar=Xbar+x2(i,j,k);
                    Ybar=Ybar+x5(i,j,k);
                end
            end
        end
        Xbar=Xbar/(watx1*waty1*3);
        Ybar=Ybar/(watx1*waty1*3);
        sigX=0;
        sigY=0;
        sigXY=0;
        for k=1:1:3
            for i=1:1:watx1
                for j=1:1:waty1
                    a1=x2(i,j,k)-Xbar;
                    a2=x5(i,j,k)-Ybar;
                    sigX=sigX + a1*a1;
                    sigY=sigY + a2*a2;
                    sigXY=sigXY + a1*a2;
                end
            end
        end
        sigX= sigX/(watx1*waty1*3-1);
        sigY= sigY/(watx1*waty1*3-1);
        sigXY= sigXY/(watx1*waty1*3-1);
        Q= (4*sigXY*Xbar*Ybar)/((sigX+sigY)*(Xbar*Xbar+Ybar*Ybar));
        %end of calculation of Image quality Index based on HVS with watermarked bmp
        wav=1;
        metric(wav,(metric_var-1)*6+1)=NC;  %normalized correlation jpg
        metric(wav,(metric_var-1)*6+2)=Q;  %image quality index jpg
        metric(wav,(metric_var-1)*6+3)=pksnr; %psnr of image jpg
        metric(wav,(metric_var-1)*6+4)=snr;   %snr of image jpg
        %%metric(wav,(metric_var-1)*6+5)=ppsnr;  %psnr of image jpg
        %%metric(wav,(metric_var-1)*6+6)=pmse;   %mse of image jpg
    end
    clear ca1;
    clear ca2;
    clear ca3;
    clear ch1;
    clear ch2;
    clear ch3;
    clear cv1;
    clear cv2;
    clear cv3;
    clear cd1;
    clear cd2;
    clear cd3;
    clear caw1;
    clear caw2;
    clear caw3;
    clear chw1;
    clear chw2;
    clear chw3;
    clear cvw1;
    clear cvw2;
    clear cvw3;
    clear cdw1;
    clear cdw2;
    clear cdw3;
    clear x5;
    clear x4;
    clear m;
    
%  end

