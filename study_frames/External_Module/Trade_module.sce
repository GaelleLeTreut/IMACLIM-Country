// Compute projection of Y
Projection.Y = Proj_of("Y");

Projection.M = Proj_of("M");
Projection.X = Proj_of("X");

// parameter forcing
parameters.delta_X_parameter(Trade_BU) = ((Projection.X(Trade_BU) ./ ((BY.X(Trade_BU)==0) + (BY.X(Trade_BU)<>0) .* BY.X(Trade_BU))) .^ (1/parameters.time_since_BY) - ((Projection.X(Trade_BU)<>0) + (Projection.X(Trade_BU)==0)*0.9))';

rate_BY = BY.M ./ BY.Y;
rate_proj = Projection.M ./ ((Projection.Y==0) + (Projection.Y<>0) .* Projection.Y);

parameters.delta_M_parameter(Trade_BU) = ((rate_proj(Trade_BU) ./ ((rate_BY(Trade_BU)==0) + (rate_BY(Trade_BU)<>0) .* rate_BY(Trade_BU))) .^ (1/parameters.time_since_BY) - (ones(rate_proj(Trade_BU))))';

save_rate_BY = rate_BY;
save_rate_proj = rate_proj;

clear rate_BY rate_proj
