/////////////////////// PRINT OUTPUTS INTO SCILAB CONSOLE


print(out," ");
print(out,"==========================================")
print(out,"============ UNITARY PRICE ====================")
print(out,"==========================================")

print(out," * Initial table - Unitary prices");
print(out,Prices.ini);
print(out," * Run table - Unitary prices");
print(out,Prices.run);
print(out," * Evolution table - Unitary prices");
print(out,Prices.evo);


print(out," ");
print(out,"==========================================")
print(out,"============ TECHNICAL COEFFICIENT ====================")
print(out,"==========================================")

print(out," * Initial table - Technical Coefficient");
print(out,TechCOef.ini);
print(out," * Run table - Technical Coefficient");
print(out,TechCOef.run);
print(out," * Evolution table - Technical Coefficient");
print(out,TechCOef.evo);



print(out," ");
print(out,"==========================================")
print(out,"============ CO2 EMISSIONS ====================")
print(out,"==========================================")

print(out," * Initial table - CO2 Emissions");
print(out,CO2Emis.ini);
print(out," * Run table - CO2 Emissions");
print(out,CO2Emis.run);
print(out," * Evolution table - CO2 Emissions");
print(out,CO2Emis.evo);


print(out," ");
print(out,"==========================================")
print(out,"============ IO TABLE VALUE ====================")
print(out,"==========================================")

print(out," * Initial table");
print(out,io.ini);
print(out," * Run table");
print(out,io.run);
print(out," * Evolution table");
print(out,io.evo);


print(out," ");
print(out,"==========================================")
print(out,"============ IO TABLE QUANTITIES ====================")
print(out,"==========================================")

print(out," * Initial table - QUANTITIES");
print(out,ioQ.ini);
print(out," * Run table - QUANTITIES");
print(out,ioQ.run);
print(out," * Evolution table - QUANTITIES");
print(out,ioQ.evo);


print(out," ");
print(out,"==========================================")
print(out,"============ ECONOMIC ACCOUNT TABLE================")
print(out,"==========================================")

print(out," * Initial table - Economic Account table");
print(out,ecoT.ini);
print(out," * Run table - Economic Account table");
print(out,ecoT.run);
print(out," * Evolution table - Economic Account table");
print(out,ecoT.evo);


print(out,"===== MAIN MACRO OUTPUT ==============================");
print(out,OutputTable.MacroT);

