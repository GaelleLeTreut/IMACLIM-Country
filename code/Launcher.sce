clear

Scenario = 'AMS_run2';

skip_calibration = %T;

Commentary = ''; // Pour l excel recapitulatif

launched_from_main = %T;

exec ("default.sce");
exec ("ImaclimS.sce");
