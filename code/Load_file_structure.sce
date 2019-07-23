
//stacksize(1e8); // max stacksize in new scilab versions
lines(0);       // No asking (continue to display) (scilab option)

// MODEL FILE STRUCTURE

sep = filesep(); // "/" or "\" depending on OS

cd("..");
PARENT    = pwd()  + sep;
CODE      = PARENT + "code" + sep;

LIB       = PARENT + "library" + sep;

OUTPUT    = PARENT + "outputs" + sep;

DATA      = PARENT + "data"         + sep; 
STUDY     = PARENT + "study_frames" + sep;
PARAMS    = PARENT + "params" + sep;
ROBOT     = PARENT + "robot" + sep;

TEST_FULLCODE = CODE + 'Test_AllConfig' + sep;
SAVED_DATA = TEST_FULLCODE + 'Saved_Data' + sep;

cd(CODE);
