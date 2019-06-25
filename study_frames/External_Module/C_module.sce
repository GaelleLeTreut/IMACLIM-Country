Projection.C = Proj_of("C");

if size(Projection.C,"c")<>nb_Households
    error("The C consumption objective is for all Households. It is not possible to force a unique total consumption C if the model is running with differents HH classes. Inform projection for each class or don''t force C.");
end 

// parameter forcing
//parameters.delta_C_parameter(C_BU) = ((Projection.C(C_BU) ./ ((BY.C(C_BU)==0) + (BY.C(C_BU)<>0) .* BY.C(C_BU))) .^ (1/parameters.time_since_BY) - (Projection.C(C_BU)<>0))';
parameters.delta_C_parameter(C_BU) = ((Projection.C(C_BU) ./ ((BY.C(C_BU)==0) + (BY.C(C_BU)<>0).*BY.C(C_BU))) .^ (1/parameters.time_since_BY) - (ones(Projection.C(C_BU))))';
