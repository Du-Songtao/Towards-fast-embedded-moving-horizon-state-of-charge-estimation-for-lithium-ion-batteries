function y = ob_eq(xnow,u,a_OCV,a_Rs)
    soc=xnow(1);
    v=xnow(2);
    beta1=xnow(3);

    soc_poly = [soc^5;soc^4;soc^3;soc^2;soc;1];

    ocv = a_OCV * soc_poly;
    R0 = beta1 + a_Rs * soc_poly;

    y = ocv - v - u * R0;
end