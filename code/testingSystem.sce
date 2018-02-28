//////  Copyright or © or Copr. Ecole des Ponts ParisTech / CNRS 2018
//////  Main Contributor (2017) : Gaëlle Le Treut / letreut[at]centre-cired.fr
//////  Contributors : Emmanuel Combet, Ruben Bibas, Julien Lefèvre
//////  
//////  
//////  This software is a computer program whose purpose is to centralise all  
//////  the IMACLIM national versions, a general equilibrium model for energy transition analysis
//////
//////  This software is governed by the CeCILL license under French law and
//////  abiding by the rules of distribution of free software.  You can  use,
//////  modify and/ or redistribute the software under the terms of the CeCILL
//////  license as circulated by CEA, CNRS and INRIA at the following URL
//////  "http://www.cecill.info".
//////  
//////  As a counterpart to the access to the source code and  rights to copy,
//////  modify and redistribute granted by the license, users are provided only
//////  with a limited warranty  and the software's author,  the holder of the
//////  economic rights,  and the successive licensors  have only  limited
//////  liability.
//////  
//////  In this respect, the user's attention is drawn to the risks associated
//////  with loading,  using,  modifying and/or developing or reproducing the
//////  software by the user in light of its specific status of free software,
//////  that may mean  that it is complicated to manipulate,  and  that  also
//////  therefore means  that it is reserved for developers  and  experienced
//////  professionals having in-depth computer knowledge. Users are therefore
//////  encouraged to load and test the software's suitability as regards their
//////  requirements in conditions enabling the security of their systems and/or 
//////  data to be ensured and,  more generally, to use and operate it in the
//////  same conditions as regards security.
//////  
//////  The fact that you are presently reading this means that you have had
//////  knowledge of the CeCILL license and that you accept its terms.
//////////////////////////////////////////////////////////////////////////////////

if %f

    //function [Constraints_Deriv] = f_resolution ( X_Deriv_Var, Imaclim_VarCalib, variableListRuben, structNumRuben , Deriv_variablesRuben , listDeriv_Var, Deriv_calib, Deriv_parameters, Deriv_Var_temp)
    z1 = X2variablesRuben (variableListRuben, structNumRuben , Deriv_variablesRuben , rubenMat , listDeriv_Var, X_Deriv_Var);
    z2 = X2variables (Index_Imaclim_VarResol, listDeriv_Var, X_Deriv_Var);


    add_profiling("f_resolution");
    // add_profiling("X2variablesRuben");
    add_profiling("struct2Variables");
    tic();
    for i = 1:5000
        contrainte_result =  f_resolution (X_Deriv_Var, rubenMat, variableListRuben, structNumRuben , Deriv_variablesRuben , listDeriv_Var, Deriv_calib, Deriv_parameters, Deriv_Var_temp);
        contrainte_result_lin =  f_resolution (X_Deriv_Var*2, rubenMat, variableListRuben, structNumRuben , Deriv_variablesRuben , listDeriv_Var, Deriv_calib, Deriv_parameters, Deriv_Var_temp);
    end
    disp("elapsed time is "+toc()/60+" mins")
    showprofile(f_resolution)
    //showprofile(struct2Variables)

    return
end

if %t
    NReac = 50;
    testReac.mat_Deriv_Var          = zeros(length(X_Deriv_Var),NReac);
    testReac.mat_Constraint         = zeros(length(X_Deriv_Var),NReac,length(X_Deriv_Var));
    testReac.mat_ConstraintConstant = trues(length(X_Deriv_Var),length(X_Deriv_Var));

    for nReac1 = 1:length(X_Deriv_Var)
        testReac.mat_Deriv_Var(nReac1,:) = linspace(-1e11,1e11,NReac);
        for nReac2 = 1:NReac
            xReac = X_Deriv_Var;
            xReac(nReac1) = testReac.mat_Deriv_Var(nReac1,nReac2);
            testReac.mat_Constraint(nReac1,nReac2,:) = f_resolution (xReac, rubenMat, variableListRuben, structNumRuben , Deriv_variablesRuben , listDeriv_Var, Deriv_calib, Deriv_parameters, Deriv_Var_temp);
            testReac.mat_ConstraintConstant(nReac1,:) = testReac.mat_ConstraintConstant(nReac1,:) & squeeze( testReac.mat_Constraint(nReac1,nReac2,:) == testReac.mat_Constraint(nReac1,1,:))';
        end
    end

    driver("PNG");
    for nReac1 = 1:length(X_Deriv_Var)
        tempRuben = squeeze(testReac.mat_Constraint(nReac1,:,:));

        // if ~isreal(tempRuben)
        //     warning("~isreal(tempRuben)");
        //     if or(imag(tempRuben)<>0)
        //         warning("nb imaginaires")
        //         disp(find(imag(tempRuben)~=0))
        //         disp(bounds.name(find(imag(tempRuben)~=0))')
        //     end
        // end

        if or(imag(tempRuben)<>0)
            tempRuben(imag(tempRuben)<>0)=%nan;
        end

        for zruben = find(~testReac.mat_ConstraintConstant(nReac1,:))
            xinit(SAVEDIR+"equations-"+bounds.name(nReac1)+":"+nReac1+"-"+zruben+".png");
            plot(testReac.mat_Deriv_Var(nReac1,:)',squeeze(tempRuben(:,zruben)),"*-");
            // legend(string(find(~testReac.mat_ConstraintConstant(nReac1,:))));
            title(bounds.name(nReac1)+":"+nReac1+" - "+zruben);
            xend();
            clf
        end
    end
    return
end

