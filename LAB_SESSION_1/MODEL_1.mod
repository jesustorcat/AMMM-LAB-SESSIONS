// MODEL 1

// VARIABLES
int nTasks = ...;
int nCPUs = ...;

// NUM OF ELEMENTS
range T=1..nTasks;
range C=1..nCPUs;

// VECTOR
float rt[t in T]=...;
float rc[c in C]= ...;

dvar float+ x_tc[t in T, c in C];
// dvar float+ x_tc[T, C]; 

dvar float+ z;


// PRE-PROCESSING
execute {
	var totalLoad=0;
	var cpuAvailable=0;
	for (var t=1;t<=nTasks;t++)
		totalLoad += rt[t];
	for (var c=1;c<=nCPUs;c++)
		cpuAvailable += rc[c];
	writeln("Total load: "+ totalLoad);
	writeln("Total CPU: "+ cpuAvailable);
	if (totalLoad > cpuAvailable) {
	  writeln("ERROR!");
	  stop();
	} else {
	  writeln("Computers have enough capacity!");
	}
};

// OBJECTIVE
minimize z;

subject to {
	
	// CONSTRAINT 1
	forall(t in T)
	  constratint_1: sum(c in C) x_tc[t,c] == 1;
	  
	// CONSTRAINT 2
	forall(c in C)
	  constratint_2: sum(t in T) rt[t]*x_tc[t,c] <= rc[c];
	  
	// CONSTRAINT 3
	forall(c in C)
	  constratint_3: z >= (1/rc[c])*sum(t in T) rt[t]*x_tc[t,c]; 
}

// POST-PROCESSING
execute {
	for (var c=1;c<=nCPUs;c++) {
		var load=0;
	for (var t=1;t<=nTasks;t++)
		load+=(rt[t]* x_tc[t][c]);
	load = (1/rc[c])*load;
	writeln("CPU " + c + " loaded at " + 100*load + "%");
	}
};
