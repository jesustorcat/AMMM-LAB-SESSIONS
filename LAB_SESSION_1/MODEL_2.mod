main {
  // MODEL 1
  var src = new IloOplModelSource("MODEL_1.mod");
  var def = new IloOplModelDefinition(src);
  var cplex = new IloCplex();
  var model = new IloOplModel(def, cplex)
  var data = new IloOplDataSource("DATA.dat");
  
  // ADDING DATA
  model.addDataSource(data);
  model.generate();
  
  cplex.epgap=0.01;
  
  if (cplex.solve()) {
  	writeln("Max load "+cplex.getObjValue()+"%");
  	
  	for (var c=1; c<=model.nCPUs; c++) {
  	  var load=0;
  	  for (var t=1; t<=model.nTasks; t++) {
  	  	load += (model.rt[t] * model.x_tc[t][c]);  
  	  }
  	  load = (1/model.rc[c])*load;
  	} 
  }
  else {
  	writeln("Not solution found!");  
  }
  
  model.end();
  data.end();
  def.end();
  cplex.end();
  src.end();

};