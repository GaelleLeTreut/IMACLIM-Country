// ************************************************** *
// Structure to record the not working configurations *
// ************************************************** *

function err = new_error(country,dash)
    // *err* : structure to record the error of code runing with
    //          *country* and the dashboard *dash*
    
    err = struct();
    
    // Record the country
    err.country_name = country.name;
    err.country_ISO = country.iso;
    
    // Record the dashboard
    err.dashboard = dash;
    
endfunction
