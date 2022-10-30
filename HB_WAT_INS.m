clear;
imgx=imread('slice.png');
x=im2double(imgx);
[P,R] = hess(x)
x1=im2double(imread('testh3.png'));
[RU1]=Afint(x1, K);  %Affine transform

[watx,waty]=size(R1);
RR1(watx+1:2*watx,1:waty)=RU1;

[watx,waty]=size(RR1);
strength=0.1;

% for wav=1.1:.2:1.5
wav=6.8;
                 
    wavlet_typ=strcat('rbio',num2str(wav))
    [ca1,ch1,cv1,cd1]=lwt2(R,wavlet_typ);

    [imx,imy]=size(ca1);
    
    k=1;
    l=1;
    alpha=0;
    for m=1:1:imx
        for n=1:1:imy
            ca1(m,n)=ca1(m,n)+strength*RR1(k,l);
            
            l=l+1;
            if l>waty 
                k=k+1;
                l=1;
                if k>watx
                    alpha=alpha+1;
                    k=1;
                end
            end
        end
    end
    R_wat=ilwt2(ca1,ch1,cv1,cd1,wavlet_typ);

    wat_nm=strcat('phw',wavlet_typ,'.png');
%     wat_nm2=strcat('phw',wavlet_typ,'.jpg');
    
    imwrite(x3,wat_nm);
%     imwrite(x3,wat_nm2,'jpg','Quality',100);
    imwrite(x3,'IM7wat.png');

    [imx,imy]=size(R);
    x3=im2double(imread(wat_nm));
%     x4=im2double(imread(wat_nm2));

    % calculation of normalized correlation with watermarked
    Anum=0;
    Adeno=0;
    Bnum=0;
    Bdeno=0;
    for k=1:1:3
    for i=1:1:imx
        for j=1:1:imy
            Anum=Anum + x(i,j,k)*x3(i,j,k);
            Adeno=Adeno + x(i,j,k)*x(i,j,k);
            Bnum=Bnum + (1-x(i,j,k))*(1-x3(i,j,k));
            Bdeno=Bdeno + (1-x(i,j,k))*(1-x(i,j,k));
        end
    end
    end
    NC= (Anum*Bnum)/(Adeno*Bdeno);
    % end of Normalized Correlation with watermarked bmp

    %calculation of Image quality Index based on HVS with watermarked bmp
    Xbar=0;
    Ybar=0;
    for k=1:1:3
    for i=1:1:imx
        for j=1:1:imy
            Xbar=Xbar+x(i,j,k);
            Ybar=Ybar+x3(i,j,k);
        end
    end
    end
    Xbar=Xbar/(imx*imy*3);
    Ybar=Ybar/(imx*imy*3);
    sigX=0;
    sigY=0;
    sigXY=0;
    for k=1:1:3
    for i=1:1:imx
        for j=1:1:imy
            a1=x(i,j,k)-Xbar;
            a2=x3(i,j,k)-Ybar;
            sigX=sigX + a1*a1;
            sigY=sigY + a2*a2;
            sigXY=sigXY + a1*a2;
        end
    end
    end
    sigX= sigX/(imx*imy*3-1);
    sigY= sigY/(imx*imy*3-1);
    sigXY= sigXY/(imx*imy*3-1);
    Q= (4*sigXY*Xbar*Ybar)/((sigX+sigY)*(Xbar*Xbar+Ybar*Ybar));
    %end of calculation of Image quality Index based on HVS with watermarked bmp
    
    [pksnr,snr]=psnr(x3,x);
    %%[ppsnr,pmse]=psnr_mse_maxerr(x,x3);
     wav=1;
    metric(wav,1)=NC;  %normalized correlation
    metric(wav,2)=Q;  %image quality index
    metric(wav,3)=pksnr; %psnr of image
    metric(wav,4)=snr;   %snr of image
   %%metric(wav,5)=ppsnr;  %psnr of image
   %%metric(wav,6)=pmse;   %mse of image
    metric(wav,7)=alpha; % no. of watermarks
        
%     % calculation of normalized correlation with watermarked jpg
%     Anum=0;
%     Adeno=0;
%     Bnum=0;
%     Bdeno=0;
%     for k=1:1:3
%     for i=1:1:imx
%         for j=1:1:imy
%             Anum=Anum + x(i,j,k)*x4(i,j,k);
%             Adeno=Adeno + x(i,j,k)*x(i,j,k);
%             Bnum=Bnum + (1-x(i,j,k))*(1-x4(i,j,k));
%             Bdeno=Bdeno + (1-x(i,j,k))*(1-x(i,j,k));
%         end
%     end
%     end
%     NC= (Anum*Bnum)/(Adeno*Bdeno);
%     % end of Normalized Correlation with watermarked jpg
% 
%     %calculation of Image quality Index based on HVS with watermarked jpg
%     Xbar=0;
%     Ybar=0;
%     for k=1:1:3
%     for i=1:1:imx
%         for j=1:1:imy
%             Xbar=Xbar+x(i,j,k);
%             Ybar=Ybar+x4(i,j,k);
%         end
%     end
%     end
%     Xbar=Xbar/(imx*imy*3);
%     Ybar=Ybar/(imx*imy*3);
%     sigX=0;
%     sigY=0;
%     sigXY=0;
%     for k=1:1:3
%     for i=1:1:imx
%         for j=1:1:imy
%             a1=x(i,j,k)-Xbar;
%             a2=x4(i,j,k)-Ybar;
%             sigX=sigX + a1*a1;
%             sigY=sigY + a2*a2;
%             sigXY=sigXY + a1*a2;
%         end
%     end
%     end
%     sigX= sigX/(imx*imy*3-1);
%     sigY= sigY/(imx*imy*3-1);
%     sigXY= sigXY/(imx*imy*3-1);
%     Q= (4*sigXY*Xbar*Ybar)/((sigX+sigY)*(Xbar*Xbar+Ybar*Ybar));
%     %end of calculation of Image quality Index based on HVS with
%     %watermarked jpg
%     
%     [pksnr,snr]=psnr(x4,x);
%     [ppsnr,pmse]=psnr_mse_maxerr(x,x4);
%     
%     metric(wav,8)=NC;  %normalized correlation jpg
%     metric(wav,9)=Q;  %image quality index jpg
%     metric(wav,10)=pksnr; %psnr of image jpg
%     metric(wav,11)=snr;   %snr of image jpg
%     metric(wav,12)=ppsnr;  %psnr of image jpg
%     metric(wav,13)=pmse;   %mse of image jpg
%     metric(wav,14)=strength;
    clear NC;
    clear Q;
    clear z;
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
    clear x3;
    
% end