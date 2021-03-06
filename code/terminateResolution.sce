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

if Output_files
    save(SAVEDIR+"result_"+Name_time+".sav","result");
end

if count==countMax&vBest>sensib
    // error("fsolve did NOT converge");
    error("fsolve did NOT converge properly: vBest = " + string(vBest) + "\n");
else
    printf("equilibrium FOUND with vBest = " + string(vBest) + "\n");
end

printf("Time for solving=" + string(toc()) + "seconds \n");

// if Output_files
//     driver("PDF");
//     xinit(SAVEDIR+"resolution_"+Name_time+".pdf");
//     subplot(2,1,1);
//     plot(list2vec(result.count),[log10(%eps+list2vec(result.vbest)),log10(%eps+list2vec(result.vmax))],"-*","Linewidth",2);
//     ylabel("log10");
//     legend("vbest","vmax");
//     subplot(2,1,2);
//     plot(list2vec(result.count),list2vec(result.info),"-*","Linewidth",2);
//     legend("info");
//     xlabel("count");
//     xend();
// end

