function out = divide(numerator,denominator,replacement)
    out = numerator ./ (denominator + %eps);
    out(denominator==0) = replacement;
endfunction

