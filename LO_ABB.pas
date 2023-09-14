Unit LO_ABB;

Interface

uses
	SysUtils, Math, LO_Indice; //Se utiliza la LO_Indice para guardar elementos temporalmente en un indice (para reconstruir el arbol cuando se balancea)


Type

	Tipo_Posicion = Longint ;
	Tipo_Clave    = Longint ;
	Tipo_Cadena   = String [255] ;
	Tipo_Cantidad = Longint;
	Tipo_Porcentaje = 1..100;	

	Tipo_Registro_Control = Record
			                      Raiz, Borrados : Tipo_Posicion;
			                      Ultimo: Tipo_Cantidad;
			                      Nombre, ruta: Tipo_Cadena ;
			                      porcentajeTolerancia: Tipo_Porcentaje;
                            porcentajeNiveles: Tipo_Porcentaje;
			                    End;

	Tipo_Archivo_Control = File of Tipo_Registro_Control ;

	Tipo_Registro_Indice   = Record
			                       Clave: Tipo_Clave ;
                             Posicion: Tipo_Posicion ;
                             Padre, HijoIzq, HijoDer : Tipo_Posicion ;
			                     End;
                           
	Tipo_Archivo_Indice = File of Tipo_Registro_Indice ;

	Tipo_Registro_Nivel = record
				                  CantidadElementos: Tipo_Cantidad;
			                  end;
	Tipo_Archivo_Nivel = file of Tipo_Registro_Nivel;

	Tipo_Arbol  = Record
                  C: Tipo_Archivo_Control;
                  I: Tipo_Archivo_Indice;
                  N: Tipo_Archivo_Nivel;
                End;

  function Arbol_Crear (var Arbol: Tipo_Arbol; sRuta, sNombre: Tipo_Cadena; porcentajeTolerancia, porcentajeNiveles: Tipo_Porcentaje): boolean; //Crea los archivos de Control Indice y Niveles referidos al ABB
  function Arbol_Creado (var Arbol: Tipo_Arbol; sRuta, sNombre: Tipo_Cadena): boolean;                                                          //Devuelve true si los archivos del ABB existen y false si no existen
  procedure Arbol_Abrir (var Arbol: Tipo_Arbol);                                                                                                //Abre los archivos
  procedure Arbol_Cerrar(var Arbol: Tipo_Arbol);                                                                                                //Cierra los archivos
  function Arbol_Buscar (var Arbol: Tipo_Arbol; Clave:Tipo_Clave; var pos:Tipo_Posicion; Var Nivel: Tipo_Cantidad): Boolean;                    //Busca de manera binaria un nodo, si no lo encuentra devuelve la posicion del que deberia ser el padre, y el nivel a donde deberia pertenecer el nodo
  procedure Arbol_Insertar(var Arbol: Tipo_Arbol; pos:Tipo_Posicion; RegistroIndice: Tipo_Registro_Indice; Nivel: Tipo_Cantidad);               //Inserta una hoja al arbol
  procedure Arbol_Eliminar (var Arbol: Tipo_Arbol; pos: Tipo_Posicion; nivel: Tipo_Cantidad);                                                   //Elimina un nodo de un arbol
  function Arbol_Raiz (var Arbol: Tipo_Arbol): Tipo_Posicion;                                                                                   //Devuelve la posicion de la raiz del arbol
  function Arbol_HijoIzquierdo ( Var Arbol: Tipo_Arbol; pos:Tipo_Posicion): Tipo_Posicion;                                                      //Devuelve la posicion del hijo izquierdo de un nodo
  function Arbol_HijoDerecho ( Var Arbol: Tipo_Arbol; pos:Tipo_Posicion): tipo_posicion;                                                        //Devuelve la posicion del hijo derecho de un nodo
  function Arbol_Padre ( Var Arbol: Tipo_Arbol; pos:Tipo_Posicion): tipo_posicion;                                                              //Devuelve la posicion del padre de un nodo
  function Arbol_Vacio ( var Arbol: Tipo_Arbol): Boolean ;                                                                                      //Devuelve true si el arbol se encuentra vacio y flase si no
  procedure Arbol_Capturar  ( Var Arbol: Tipo_Arbol; pos:Tipo_Posicion; var RegistroIndice:Tipo_Registro_Indice );                              //Captura un nodo de la posicion pasada por parametro en el RegistroIndice
  procedure Arbol_Modificar  ( Var Arbol: Tipo_Arbol; pos:Tipo_Posicion; RegistroIndice:Tipo_Registro_Indice );                                 //Modifica el nodo que se encuentra en la posicion pos
  function Arbol_PosNula (var Arbol: Tipo_Arbol): longint;                                                                                      //Devuelve la posicion nula de la libreria operacional
  function Arbol_ClaveNula (var Arbol: Tipo_Arbol): Tipo_Clave;                                                                                 //Devuelve la clave nula de la libreria operacional
  procedure Arbol_Destruir  (var Arbol: Tipo_Arbol);                                                                                            //Elimina los archivos referidos al ABB
  function Arbol_Equilibrado (var Arbol: Tipo_Arbol) : boolean;                                                                                 //Devuelve true si el arbol se encuentra equilibrado y false si no
  procedure MigrarElementos (var Arbol: Tipo_Arbol; var Indice: LO_Indice.Tipo_Indice);                                                         //Mueve todos los elementos de un arbol a un archivo ordenado.
  procedure LlenarArbol(var Arbol: Tipo_Arbol; Indice: LO_Indice.Tipo_Indice; ini, fin: Tipo_Posicion);                                         //Algoritmo recursivo que crea un nuevo arbol a partir de una estructura de indice ordenada. (Se invoca en RebalancearArbol)
  procedure Arbol_Rebalanceo (var Arbol: Tipo_Arbol; sRuta, sNombre: Tipo_Cadena);                                                              //Serie de algoritmos para rebalancear arbol
  procedure ActualizarNiveles(var Arbol: Tipo_Arbol; posNodo: Tipo_Posicion; Nivel: Tipo_Cantidad);                                             //Utiliza recursividad para actualizar todos los niveles infieriores al nodo pasado por parametro (se utiliza esta funcion al eliminar realizando un puente).
  function Arbol_UltimoNivel(var Arbol: Tipo_Arbol): Tipo_Cantidad;
  procedure Arbol_CapturarNivel(var Arbol: Tipo_Arbol; pos: Tipo_Posicion; var RegistroNivel: Tipo_Registro_Nivel);
  function Arbol_PorcentajeTolerancia (var Arbol: Tipo_Arbol): Tipo_Porcentaje;
  function Arbol_PorcentajeNiveles(var Arbol: Tipo_Arbol): Tipo_Porcentaje;
  function Arbol_CantidadElementos (var Arbol: Tipo_Arbol): integer;
  procedure Arbol_CambiarPorcentajeTolerancia(var Arbol: Tipo_Arbol; porcentajeTolerancia: Tipo_Porcentaje);
  procedure Arbol_cambiarPorcentajeNiveles(var Arbol: Tipo_Arbol; porcentajeNivel: Tipo_Porcentaje);

implementation

//-----------------------------------------------------------------------------------------

procedure ActualizarNiveles(var Arbol: Tipo_Arbol; posNodo: Tipo_Posicion; Nivel: Tipo_Cantidad);
var
  RegistroIndice: Tipo_Registro_Indice;
  RegistroNivel: Tipo_Registro_Nivel;
begin
  if (posNodo <> _posicion_Nula) then
  begin
    Seek(Arbol.I, posNodo);
    Read(Arbol.I, RegistroIndice);


    Seek(Arbol.N, Nivel);
    Read(Arbol.N, RegistroNivel);
    RegistroNivel.CantidadElementos:= RegistroNivel.CantidadElementos + 1 ;
    Seek(Arbol.N, Nivel);
    Write(Arbol.N, RegistroNivel);


    Seek(Arbol.N, Nivel+1);
    Read(Arbol.N, RegistroNivel);
    RegistroNivel.CantidadElementos:= RegistroNivel.CantidadElementos - 1 ;
    Seek(Arbol.N, Nivel+1);
    Write(Arbol.N, RegistroNivel);

    ActualizarNiveles(Arbol, RegistroIndice.HijoIzq, Nivel+1);
    ActualizarNiveles(Arbol, RegistroIndice.HijoDer, Nivel+1);

  end
end;//end ActualizarNiveles;

//-----------------------------------------------------------------------------------------

function Arbol_Creado (var Arbol: Tipo_Arbol; sRuta, sNombre: Tipo_Cadena): boolean;
var
  sArchivoIndice, sArchivoControl, sArchivoNiveles: string;
  bHayError: boolean;
begin
    sArchivoIndice:= sRuta+'\'+sNombre+'.ntx';
    sArchivoControl:= sRuta+'\'+sNombre+'.con';
    sArchivoNiveles:= sRuta+'\'+sNombre+'.niv';

    Assign(Arbol.I, sArchivoIndice);     //Asignamos archivo de Indice
    Assign(Arbol.C, sArchivoControl);     //Asignamos archivo de Control
    Assign(Arbol.N, sArchivoNiveles); //Asignamos archivo de niveles

    {$I-}

    Reset(Arbol.I);
    Reset(Arbol.N);
    Reset(Arbol.C);

    bHayError:= IoResult <> 0;


    Arbol_Creado:= not bHayError;

    {$I+}

end; //End Arbol_Creado

//-----------------------------------------------------------------------------------------

function  Arbol_Crear  ( var Arbol: Tipo_Arbol; sRuta, sNombre: Tipo_Cadena; porcentajeTolerancia, porcentajeNiveles: Tipo_Porcentaje): boolean ;
var
  sArchivoIndice, sArchivoControl , sArchivoNiveles: Tipo_Cadena;
  bHayError: boolean;

  RegistroControl: Tipo_Registro_Control;
begin

    sArchivoIndice:= sRuta+'\'+sNombre+'.ntx';
    sArchivoControl:= sRuta+'\'+sNombre+'.con';
    sArchivoNiveles:= sRuta+'\'+sNombre+'.niv';

    Assign(Arbol.I, sArchivoIndice);     //Asignamos archivo de Indice
    Assign(Arbol.C, sArchivoControl);     //Asignamos archivo de Control
    Assign(Arbol.N, sArchivoNiveles); //Asignamos archivo de niveles

    {$I-}

    Reset(Arbol.I);

    bHayError:= (IoResult <> 0);

    if bHayError then Rewrite(Arbol.I);

    close (Arbol.I);


    //NIVELES
    Reset(Arbol.N);

    bHayError:= (IoResult <> 0);

    if bHayError then Rewrite(Arbol.N);


    //Ahora lo mismo para control e iniciarlo

    Reset(Arbol.C);

    bHayError:= IoResult <> 0;

    if bHayError then
      begin

        Rewrite(Arbol.C);
        RegistroControl.Ruta    := sRuta;
        RegistroControl.Nombre  := sNombre;
        RegistroControl.Ultimo:= _posicion_nula;
        RegistroControl.Raiz:= _Posicion_Nula;
        RegistroControl.Borrados:= _Posicion_Nula;
	      RegistroControl.porcentajeTolerancia:= porcentajeTolerancia;
        RegistroControl.porcentajeNiveles:= porcentajeNiveles;

        Seek(Arbol.C, 0);
        write(Arbol.C,RegistroControl);

      end;


    Arbol_Crear:= bHayError;

    {$I+}
end; //End ArbolCrear

//-----------------------------------------------------------------------------------------

procedure Arbol_Abrir (var Arbol: Tipo_Arbol);
begin
	Reset(Arbol.I);
  Reset(Arbol.C);
	Reset(Arbol.N);
end; //End ArbolAbrir

//-----------------------------------------------------------------------------------------

procedure Arbol_Cerrar (var Arbol: Tipo_Arbol);
begin
	Close(Arbol.C);
	Close(Arbol.I);
	Close(Arbol.N);
end; //End ArbolCerrar

//-----------------------------------------------------------------------------------------

function Arbol_Buscar  ( var Arbol: Tipo_Arbol; Clave:Tipo_Clave; Var pos:Tipo_Posicion; Var Nivel: Tipo_Cantidad): Boolean;
{Si encuentra elemento devuelve TRUE y pos= posicion de elemento, nivel es el nivel del elemento.
IMPORTANTE SI NO lo encuentra devuelve FALSE y pos es la posicion del PADRE o sea donde deberia engancharse el elemento, y nivel es el nivel donde DEBERIA pertenecer el nuevo elemento}
Var
  RegistroControl: Tipo_Registro_Control;
  RegistroIndice: Tipo_Registro_Indice;
  PosPadre: Tipo_Posicion;
  bEncontrado : Boolean ;
Begin

	seek (Arbol.C, 0);
	Read (Arbol.C, RegistroControl);

	posPadre := _posicion_nula;
	pos := RegistroControl.Raiz;
	bEncontrado:= False;
	Nivel:=0;

	while (bEncontrado = false) and (pos <> _posicion_nula) do
	begin
		Seek ( Arbol.I, pos);
		Read ( Arbol.I, RegistroIndice );

		if (RegistroIndice.Clave = clave) then bEncontrado := True
		else
		  begin
		    Nivel:= Succ(Nivel);
		    posPadre:= pos;
		    if ( clave <= RegistroIndice.Clave) Then  pos:= RegistroIndice.HijoIzq
		    Else  pos:= RegistroIndice.HijoDer;
		  end;	
	end;

	if (bEncontrado = false) then  
	begin
	  pos := PosPadre ;
	end;

	Arbol_Buscar:= bEncontrado;

End; //End ArbolBuscar

//-----------------------------------------------------------------------------------------

procedure Arbol_Insertar ( var Arbol: Tipo_Arbol; pos:Tipo_Posicion; RegistroIndice: Tipo_Registro_Indice; Nivel: Tipo_Cantidad);
var
	Rpadre: Tipo_Registro_Indice;
	RegistroControl: Tipo_Registro_Control;
	posGrabar: Tipo_Posicion;

	RegistroNivel: Tipo_Registro_Nivel;

Begin 
   Seek (Arbol.C,  0);
   Read (Arbol.C, RegistroControl);
   
   posGrabar:= FileSize ( Arbol.I );

   if (RegistroControl.Raiz =  _posicion_nula)   or  (pos = _posicion_nula) then
	 //insertar en Arbol vacio
	  begin
		RegistroIndice.padre:= _posicion_nula;
		RegistroIndice.HijoIzq:= _posicion_nula;
		RegistroIndice.HijoDer:= _posicion_nula;

		RegistroControl.Raiz := posGrabar;

		RegistroControl.Ultimo:= 0;

		RegistroNivel.CantidadElementos:=1;
	  end
    else
	  //Insertar una hoja
	  begin
		  RegistroIndice.padre:= pos ;
		  RegistroIndice.HijoIzq:= _posicion_nula;
	  	RegistroIndice.HijoDer:= _posicion_nula;

		  Seek (Arbol.I, pos );
		  Read ( Arbol.I, Rpadre );
      
		  if (RegistroIndice.Clave < Rpadre.Clave) then Rpadre.HijoIzq:= posGrabar
		  else   Rpadre.HijoDer:= posGrabar;
		
		  Seek (Arbol.I, pos);
		  Write (Arbol.I, Rpadre);

		  if (  Nivel < FileSize(Arbol.N)  ) then
		  begin
			  Seek(Arbol.N, Nivel);
			  Read(Arbol.N, RegistroNivel);
			  RegistroNivel.CantidadElementos:= Succ(RegistroNIvel.CantidadElementos);
		  end else
			begin
				RegistroNivel.CantidadElementos:=1;
				RegistroControl.Ultimo:= nivel;
			end
		
	  end;

   //SE graba todo.
   Seek  (Arbol.C, 0);
   Write (Arbol.C, RegistroControl);

   Seek  (Arbol.I, posGrabar);
   Write (Arbol.I, RegistroIndice);

   Seek( Arbol.N, nivel);
   Write(Arbol.N, RegistroNivel);	
	

End; //End ArbolInsertar

//-----------------------------------------------------------------------------------------

procedure Arbol_Eliminar (var Arbol: Tipo_Arbol; pos: Tipo_Posicion; nivel: Tipo_Cantidad);

var
	RegistroControl: Tipo_Registro_Control;
	Rpadre, RegistroPadre, Raux, RegistroIndice, RegPadre, RegIzq, RegDer, RegistroSustituto, RegistroPadreSustituto, RegistroHijoIzq, RegistroHijoDer: Tipo_Registro_Indice;
	posPadre, posHijoIzq, posHijoDer, posCandidato, posSustitutoIzq, posSustitutoDer, posSustituto, posPadreSus : Tipo_Posicion;
  nivelARestar: integer;
  contadorPasosIzq, contadorPasosDer: integer;

  RegistroNivel: Tipo_Registro_Nivel;

begin
	Seek ( Arbol.C, 0);
	Read ( Arbol.C, RegistroControl);

	Seek ( Arbol.I, pos );
	Read ( Arbol.I, RegistroIndice );

  //CASO 1 - elimino y queda arbol vacio
  //El nivel a restar es el que indica la variable nivel
	if (RegistroControl.raiz = pos) and (RegistroIndice.hijoIzq = _posicion_nula) and (RegistroIndice.HijoDer = _posicion_nula) then
  begin
    RegistroControl.Raiz := _posicion_nula;
    nivelARestar:= nivel;
  end
  else
  //CASO 2: elimino hoja
  //El nivel a restar es el que indica la variable nivel
  if (RegistroIndice.HijoIzq = _posicion_nula) and (RegistroIndice.HijoDer = _posicion_nula) then
  begin
    posPadre := RegistroIndice.padre;
    Seek ( Arbol.I, posPadre );
    Read  (Arbol.I, Rpadre );

    if (Rpadre.HijoIzq = pos) then Rpadre.HijoIzq := _posicion_nula
    else Rpadre.HijoDer := _posicion_nula;

    Seek ( Arbol.I, posPadre );
    Write (Arbol.I, Rpadre );

    nivelARestar:= nivel;

  end
  else
  //CASO 3:  es un padre con solo un nodo hijo. SE RESUELVE POR PUENTE.
  //Se deben actualizar los niveles inferiores al nivel pasado por parametro. Al resolver por puente el nivel pasado por parametro quedará con la misma cantidad de elementos, pero hay que recorrer los inferiores.
  if ((RegistroIndice.Hijoizq = _posicion_nula) and (RegistroIndice.HijoDer <> _posicion_nula)) or ((RegistroIndice.HijoDer = _posicion_nula) and(RegistroIndice.Hijoizq <> _posicion_nula)) then
  begin
    posPadre  := RegistroIndice.Padre;
    posHijoIzq:= RegistroIndice.HijoIzq;
    posHijoDer:= RegistroIndice.HijoDer;


    //Lo marcamos con un -1 para mas tarde identificar que se realizó un puente (Al final de este procedimiento realizamos la actualizacion de niveles)
    nivelARestar:= -1;

    //Eliminamos un elemento del nivel (luego lo repondremos con el algoritmo recursivo)
    Seek(Arbol.N, Nivel);
    Read(Arbol.N, RegistroNivel);
    RegistroNivel.CantidadElementos:= RegistroNivel.CantidadElementos-1;
    Seek(Arbol.N, Nivel);
    Write(Arbol.N, RegistroNivel);

    if (posHijoIzq = _posicion_nula) then posCandidato := posHijoDer else posCandidato := posHijoIzq;

    //Resuelvo el padre

    if (RegistroIndice.Padre = _posicion_nula) then RegistroControl.Raiz:= posCandidato
    else
    begin
      Seek ( Arbol.I, posPadre) ;
      Read ( Arbol.I, RegPadre );

      if (RegPadre.HijoIzq = pos) then RegPadre.HijoIzq := posCandidato else RegPadre.HijoDer := posCandidato;

      Seek ( Arbol.I, posPadre );
      Write ( Arbol.I, regPadre );
    end;

    // Resuelvo el hijo (Sustituto)
    if (posHijoIzq <> _posicion_nula) then
    // Es el HIJO IZQUIERDO
    begin
      Seek ( Arbol.I, posHijoIzq);
      Read ( Arbol.I, RegIzq );
      RegIzq.padre:= posPadre;
      Seek ( Arbol.I, posHijoIzq);
      Write ( Arbol.I, RegIzq );
    end
    else
    // Es el HIJO DERECHO
    begin
      Seek ( Arbol.I, posHijoDer);
      Read ( Arbol.I, RegDer );
      RegDer.padre:= posPadre;
      Seek ( Arbol.I, posHijoDer);
      Write ( Arbol.I, RegDer  );
    end

  end

  else
  //CASO 4: general, elimino "al medio" usando sustitucion
  //El nivel a restar será alguno de los niveles siguientes al nivel pasado por parametro (BARRER RESTANDO LOS NIVELES SIGUIENTES)
  begin
    // Paso 1: buscar SUSTITUTO por izquierda (mayor de los menores)------------------------------
    //buscar por izq y luego el mas a la derecha......

    contadorPasosIzq:= 0;
    contadorPasosDer:= 0;


    posSustitutoIzq:= RegistroIndice.HijoIzq;
    Seek(Arbol.I, posSustitutoIzq);
    Read(Arbol.I, RegistroSustituto);
    ContadorPasosIzq:= Succ(ContadorPasosIzq);
			     
    while (RegistroSustituto.HijoDer <> _posicion_nula) do
    begin
      posSustitutoIzq:= RegistroSustituto.HijoDer;
      Seek(Arbol.I, posSustitutoIzq);
      Read(Arbol.I, RegistroSustituto);
      contadorPasosIzq:= Succ(contadorPasosIzq);
    end;

    // Paso 2: buscar SUSTITUTO por derecha (menor de los mayores)-------------------------------
    //buscar por derecha y luego el mas a la izquierda.....

    posSustitutoDer := RegistroIndice.HijoDer;
    Seek(Arbol.I, posSustitutoDer);
    Read(Arbol.I, RegistroSustituto);

    ContadorPasosDer:= Succ(ContadorPasosDer);
			     
    while (RegistroSustituto.HijoIzq <> _posicion_nula) do
    begin
      posSustitutoDer:= RegistroSustituto.HijoIzq;
      Seek(Arbol.I, posSustitutoDer);
      Read(Arbol.I, RegistroSustituto);
      contadorPasosDer:= Succ(contadorPasosDer);
    end;

    //Comparo que susituto es "mejor" (cual esta mas lejos del nodo a eliminar)
    if (contadorPasosIzq > contadorPasosDer) then
    begin
      posSustituto:= posSustitutoIzq;
      NivelARestar:= nivel + contadorPasosIzq ;
    end
    else
    begin
      posSustituto:= posSustitutoDer;
      NivelARestar:= nivel + contadorPasosDer;
    end;
			    
    // Paso 3: hago la sustitucion entre pos y posSustituto
    // ..... algoritmo de cambio de enlaces ....

    Seek(Arbol.I, posSustituto);
    Read(Arbol.I, RegistroSustituto);
    
    posPadreSus:= RegistroSustituto.Padre;
    Seek(Arbol.I, posPadreSus);
    Read(Arbol.I, RegistroPadreSustituto);

    if (RegistroPadreSustituto.HijoIzq = posSustituto) then RegistroPadreSustituto.HijoIzq:= _posicion_nula else RegistroPadreSustituto.HijoDer:= _posicion_nula;

    Seek(Arbol.I, posPadreSus);
    Write(Arbol.I, RegistroPadreSustituto);

    posPadre:= RegistroIndice.Padre;
    RegistroSustituto.Padre:= posPadre;

    RegistroSustituto.HijoIzq:= RegistroIndice.HijoIzq;
    RegistroSustituto.HijoDer:= RegistroIndice.HijoDer;

    //Puede ser que pos sea la raiz
    if (RegistroSustituto.Padre = _posicion_nula) then
    begin
          RegistroControl.Raiz := posSustituto;
          Seek(Arbol.C, 0);
          Write(Arbol.C, RegistroControl);


          Seek(Arbol.I, posSustituto);
          Write(Arbol.I, RegistroSustituto);
    end
    else
    begin
      Seek(Arbol.I, posPadre);
      Read(Arbol.I, RegistroPadre);
			 	
      if (RegistroPadre.HijoIzq = pos) then RegistroPadre.HijoIzq:= posSustituto else RegistroPadre.HijoDer:= posSustituto;
			    
      Seek(Arbol.I, posPadre);
      Write(Arbol.I, RegistroPadre);

      Seek(Arbol.I, posSustituto);
      Write(Arbol.I, RegistroSustituto);
			
      posHijoIzq:= RegistroSustituto.HijoIzq;
      posHijoDer:= RegistroSustituto.HijoDer;

      Seek(Arbol.I, posHijoIzq);
      Read(Arbol.I, RegistroHijoIzq);
      RegistroHijoIzq.Padre:= posSustituto;
      Seek(Arbol.I, posHijoIzq);
      Write(Arbol.I, RegistroHijoIzq);
  
      Seek(Arbol.I, posHijoDer);
      Read(Arbol.I, RegistroHijoDer);
      RegistroHijoDer.Padre:= posSustituto;
      Seek(Arbol.I, posHijoDer);
      Write(Arbol.I, RegistroHijoDer);
    end;

  end;//end caso4

	//-------------------------------------------------------
	//Engancho al nodo en la secuencia de eliminados

	if RegistroControl.Borrados <> _posicion_nula then
	begin
		Seek (Arbol.I, RegistroControl.Borrados);
		Read (Arbol.I, Raux );
		Raux.HijoIzq := pos ;
		Seek (Arbol.I, RegistroControl.Borrados);
		Write (Arbol.I, Raux );		
	end
  else
  begin
    RegistroControl.Borrados:= pos;
    Seek(Arbol.C, 0);
    Write(Arbol.C, RegistroControl);
  end;

	// Grabo RegistroIndice
  RegistroIndice.Padre := _posicion_nula;
	RegistroIndice.HijoIzq:= _posicion_nula;
	RegistroIndice.HijoDer:= RegistroControl.Borrados;
	
	Seek ( Arbol.I, pos );
	Write ( Arbol.I, RegistroIndice );	

	//Grabo Nivel

  if (nivelARestar = -1) then  //Se realizó un puente, hay que actualizar niveles inferiores
  begin
    ActualizarNiveles(Arbol, posCandidato, Nivel);
    Nivel:= RegistroControl.Ultimo;
    Seek(Arbol.N, Nivel);
    Read(Arbol.N, RegistroNivel);
    
    if (RegistroNivel.CantidadElementos=0) then
    begin
      RegistroControl.Ultimo:= RegistroControl.Ultimo - 1 ;
      Seek(Arbol.C, 0);
      Write(Arbol.C, RegistroControl);
    end

  end
  else
  begin
    Seek(Arbol.N, nivelARestar);
	  Read(Arbol.N, RegistroNivel);

	  RegistroNivel.CantidadElementos:= RegistroNivel.CantidadElementos-1;

	  Seek( Arbol.N, nivelARestar);
	  Write(Arbol.N, RegistroNivel);

	  if (RegistroNivel.CantidadElementos = 0) then
	  RegistroControl.Ultimo:= RegistroControl.Ultimo - 1;

	  Seek(Arbol.C, 0);
	  Write(Arbol.C, RegistroControl);

  end



End; //End ArbolEliminar

//-----------------------------------------------------------------------------------------

function Arbol_Raiz (var Arbol: Tipo_Arbol): Tipo_Posicion;
Var
	RegistroControl: Tipo_Registro_Control;

begin
	Seek ( Arbol.C, 0);
	Read ( Arbol.C, RegistroControl);
	Arbol_Raiz:= RegistroControl.Raiz ;

end; //End ArbolRaiz

//-----------------------------------------------------------------------------------------

function Arbol_HijoIzquierdo ( Var Arbol: Tipo_Arbol; pos:Tipo_Posicion): Tipo_Posicion;
Var
	RegistroIndice: Tipo_Registro_Indice;
begin
	Seek ( Arbol.I, pos );
	Read ( Arbol.I, RegistroIndice);
	Arbol_HijoIzquierdo := RegistroIndice.HijoIzq ;
End;	//End ArbolHijoIzq

//-----------------------------------------------------------------------------------------

function Arbol_HijoDerecho ( Var Arbol: Tipo_Arbol; pos:Tipo_Posicion): tipo_posicion;
Var
	RegistroIndice: Tipo_Registro_Indice;
begin
	seek ( Arbol.I, pos );
	Read ( Arbol.I, RegistroIndice);
	Arbol_HijoDerecho:= RegistroIndice.HijoDer ;
End; //end ArbolHijoDer

//-----------------------------------------------------------------------------------------

function Arbol_Padre ( Var Arbol: Tipo_Arbol; pos:Tipo_Posicion): tipo_posicion;
Var
	RegistroIndice: Tipo_Registro_Indice;
begin
	seek ( Arbol.I, pos );
	Read ( Arbol.I, RegistroIndice);
	Arbol_Padre:= RegistroIndice.Padre;
End;

//-----------------------------------------------------------------------------------------

function Arbol_Vacio ( var Arbol: Tipo_Arbol): Boolean ;
Var
	RegistroControl: Tipo_Registro_Control;
	bResultado: boolean;
begin
	seek ( Arbol.C, 0);
	Read ( arbol.C, RegistroControl);
  
	if RegistroControl.Raiz <> _posicion_nula then bResultado:= false
	else
	bResultado:= true;

	Arbol_Vacio:= bResultado;

end;

//-----------------------------------------------------------------------------------------

procedure Arbol_Capturar  ( Var Arbol: Tipo_Arbol; pos:Tipo_Posicion; var RegistroIndice:Tipo_Registro_Indice );
begin
	seek ( Arbol.I, pos );
	Read ( Arbol.I, RegistroIndice);
end;

//-----------------------------------------------------------------------------------------

procedure Arbol_Modificar  ( Var Arbol: Tipo_Arbol; pos:Tipo_Posicion; RegistroIndice:Tipo_Registro_Indice );
Var
	Raux: Tipo_Registro_Indice;
begin
	seek ( Arbol.I, pos );
	Read ( Arbol.I, Raux);

	seek ( Arbol.I, pos );
	Write ( Arbol.I, RegistroIndice);
end; 

//-----------------------------------------------------------------------------------------

function Arbol_PosNula (var Arbol: Tipo_Arbol): longint;
begin
	Arbol_PosNula:= _posicion_nula;
end;//End ArbolPosNUla

//-----------------------------------------------------------------------------------------

Function Arbol_ClaveNula (var Arbol: Tipo_Arbol): Tipo_Clave;
begin
	Arbol_ClaveNula:= _Clave_nula;
end;//End ArbolClaveNUla

//-----------------------------------------------------------------------------------------

Procedure Arbol_Destruir  (var Arbol: Tipo_Arbol);
  begin

    Close(Arbol.C);
    Close(Arbol.I);
    Close(Arbol.N);

    Erase(Arbol.C);
    Erase(Arbol.I);
    Erase(Arbol.N);

  end; //Arbol_Destruir
//-----------------------------------------------------------------------------------------


function Arbol_Equilibrado (var Arbol: Tipo_Arbol) : boolean;
var
	RegistroControl: Tipo_Registro_Control;
	nivelesDeTolerancia, nivelesAControlar, nivelesIncompletos : Tipo_Cantidad;
  pos: Tipo_posicion;
  RegistroNivel: Tipo_Registro_Nivel;
begin
	Seek(Arbol.C, 0 );
	Read(Arbol.C, RegistroControl);

  if (RegistroControl.Raiz= _posicion_nula) then Arbol_Equilibrado:= true
  else
  begin
    
    nivelesAControlar:= Trunc( (RegistroControl.porcentajeNiveles / 100) * RegistroControl.Ultimo );

	  nivelesDeTolerancia:= Trunc ( (RegistroControl.porcentajeTolerancia / 100 ) * nivelesAControlar ) ;

	  nivelesIncompletos := 0 ;
	
	  pos:= nivelesAControlar;

	  while ( pos >= 0 ) and (nivelesIncompletos <= nivelesDeTolerancia) do
	  begin
		  Seek(Arbol.N, pos);
		  Read(Arbol.N, RegistroNivel);

		  if ( RegistroNivel.CantidadElementos < Power(2, pos) ) then nivelesIncompletos := nivelesIncompletos + 1;

		  pos:=pos-1
	  end;

	  Arbol_Equilibrado := nivelesIncompletos <= nivelesDeTolerancia;
  end
	
end;//End ArbolEquilibrado

procedure MigrarElementos (var Arbol: Tipo_Arbol; var Indice: LO_Indice.Tipo_Indice);// Mueve todos los elementos de un arbol a un archivo ordenado.
var

  RegistroIndice: LO_Indice.Tipo_Registro_Indice;

  RegistroControl: Tipo_Registro_Control;
  RegistroIndiceA, RegistroHijoIzq, RegistroHijoDer: Tipo_Registro_Indice;
  RegistroNivel: Tipo_Registro_nivel;

  pos, posPadre, posHijoIzq, posHijoDer, posNodo: Tipo_Posicion;

  cantidadElem, i, visitados: integer;

begin

	Seek(Arbol.C,0);
	Read(Arbol.C, RegistroControl);


	//Primero debemos saber que cantidad de elementos hay en el arbol
	
	cantidadElem:=0;
	
	for i:= 0 to RegistroControl.Ultimo do
	begin
		Seek(Arbol.N, i);
		Read(Arbol.N, RegistroNivel);
		cantidadElem:=cantidadElem+RegistroNivel.CantidadElementos;
	end;
	
	//Recorrer Arbol e ir insertando en indice.  SE UTILIZA UN RECORRIDO PRE-ORDEN
	
	visitados:=0;	

	Seek(Arbol.I, RegistroControl.Raiz);
	Read(Arbol.I, RegistroIndiceA);

        posNodo:= RegistroControl.Raiz;
	
	while (visitados <> cantidadElem) do
	begin
		
		Seek(Arbol.I, posNodo);
		Read(Arbol.I, RegistroIndiceA);
		
		posPadre:= RegistroIndiceA.Padre;
		posHijoIzq:= RegistroIndiceA.HijoIzq;
		posHijoDer:= RegistroIndiceA.HijoDer;
		
		if (RegistroIndiceA.Clave <> _clave_nula) then //Si no esta visitado ya...
		begin
		  RegistroIndice.Clave:= RegistroIndiceA.Clave;
		  RegistroIndice.Puntero:= RegistroIndiceA.Posicion;
	
		  LO_Indice.Indice_Buscar(Indice, RegistroIndice.Clave, pos);
		  LO_Indice.Indice_Insertar(Indice, pos, RegistroIndice);
	
		  RegistroIndiceA.Clave:= _Clave_nula;
		  visitados:= visitados+1;

		  Seek(Arbol.I, posNodo);
		  Write(Arbol.I, RegistroIndiceA);

		  if (posHijoIzq <> _posicion_nula) then 
		  begin
		    Seek(Arbol.I, posHijoIzq);
		    Read(Arbol.I, RegistroHijoIzq);
		    if (RegistroHijoIzq.Clave = _clave_nula) then posNodo:=posPadre
		    else posNodo:= posHijoIzq;				
		  end
		  else 
		    if (posHijoDer <> _posicion_nula) then posNodo:=posHijoDer
		    else
		      if (posPadre <> _posicion_nula) then posNodo:=posPadre;


		end
		else //YA ESTA VISITADO, ENTONCES ir para la derecha. (porque hacemos recorrido PRE ORDEN)
		begin

		  if (posHijoDer <> _Posicion_nula) then 
		  begin
		    Seek(Arbol.I, posHijoDer);
		    Read(Arbol.I, RegistroHijoDer);

		    if (RegistroHijoDer.clave = _clave_nula) then posNodo:= posPadre
		    else posNodo:= posHijoDer;
		  end
		  else posNodo:= posPadre;	  
		end	
		
	end; //while visitados <> cantidadElem
	
end;

procedure LlenarArbol(var Arbol: Tipo_Arbol; Indice: LO_Indice.Tipo_Indice; ini, fin: Tipo_Posicion); //Crea un nuevo arbol a partir de una estructura de indice ordenada. Usa recursion
var
	RegistroArbol: Tipo_Registro_Indice;	
	RegistroIndice: LO_Indice.Tipo_Registro_Indice;		
	pos: Tipo_Posicion;
	Nivel: Tipo_Cantidad;
  medio:integer;	      

begin		 
          
	if (ini <= fin) then
	begin
		medio:= (ini+fin) div 2;
		Seek( Indice.I, medio);
		Read( Indice.I, RegistroIndice);
		
		RegistroArbol.Clave:= RegistroIndice.Clave;
    RegistroArbol.Posicion:= RegistroIndice.Puntero;

		Arbol_Buscar(Arbol, RegistroArbol.Clave , pos, Nivel);
		Arbol_Insertar(Arbol, pos, RegistroArbol, nivel);
	
		LlenarArbol(Arbol, Indice, ini, medio-1);
		LlenarArbol(Arbol, Indice, medio+1, fin);

	end;		
	
end;


procedure Arbol_Rebalanceo (var Arbol: Tipo_Arbol; sRuta, sNombre: Tipo_Cadena); //Pasa todos los elementos del arbol a un indice y crea un nuevo arbol a partir de estos elementos pero insertandolos ordenadamente (a partir de busqueda binaria)
var Indice: LO_Indice.Tipo_Indice;
    RegistroControl: Tipo_Registro_Control;
    tolerancia, nivelesAControlar: Tipo_Porcentaje;
begin
   Seek(Arbol.C, 0);
   Read(Arbol.C, RegistroControl);
   tolerancia:= RegistroControl.porcentajeTolerancia;
   nivelesAControlar:= RegistroControl.porcentajeNiveles;
	// Primer paso. Mover elementos de arbol a indice:

	LO_Indice.Indice_Crear( Indice, sRuta, 'IndiceTemporal');
	LO_Indice.Indice_Abrir(Indice);

	MigrarElementos(Arbol, Indice);

	// Segundo paso. Eliminar arbol original (Archivos de indice (arbol), control y niveles).
	Arbol_Destruir(Arbol);

	//Tercer paso. Crear un arbol nuevo.
	Arbol_Crear(Arbol, sRuta, sNombre, tolerancia, nivelesAControlar);
	Arbol_Abrir(Arbol);

	//Cuarto paso. Llenar el arbol a partir de logica de busqueda binaria en el indice.

	LlenarArbol(Arbol, Indice, 0, (Filesize(Indice.I)-1));

	//Quinto paso. Eliminar Indice temporal.

	LO_Indice.Indice_Destruir(Indice);


end; // end ArbolRebalanceo

//-----------------------------------------------------------------------------

function Arbol_UltimoNivel(var Arbol: Tipo_Arbol): Tipo_Cantidad;
var
  RegistroControl: Tipo_Registro_Control;
begin
  Seek(Arbol.C, 0);
  Read(Arbol.C, RegistroControl);

  Arbol_UltimoNivel:= RegistroControl.Ultimo;
end;

//------------------------------------------------------------------------------

procedure Arbol_CapturarNivel(var Arbol: Tipo_Arbol; pos: Tipo_Posicion; var RegistroNivel: Tipo_Registro_Nivel);
begin
  Seek(Arbol.N, pos);
  Read(Arbol.N, RegistroNivel);
end;

//------------------------------------------------------------------------------

function Arbol_PorcentajeTolerancia (var Arbol: Tipo_Arbol): Tipo_Porcentaje;
var
  RegistroControl: Tipo_Registro_Control;
begin
  Seek(Arbol.C, 0);
  Read(Arbol.C, RegistroControl);

  Arbol_PorcentajeTolerancia:= RegistroControl.porcentajeTolerancia;
end;

//------------------------------------------------------------------------------

function Arbol_PorcentajeNiveles(var Arbol: Tipo_Arbol): Tipo_Porcentaje;
var
  RegistroControl: Tipo_Registro_Control;
begin
  Seek(Arbol.C, 0);
  Read(Arbol.C, RegistroControl);

  Arbol_PorcentajeNiveles:= RegistroControl.porcentajeNiveles;
end;

//------------------------------------------------------------------------------

function Arbol_CantidadElementos (var Arbol: Tipo_Arbol): integer;
var
  nResultado, i: integer;
  RegistroControl: Tipo_Registro_Control;
  RegistroNivel: Tipo_Registro_Nivel;
begin
  Seek(Arbol.C, 0);
  Read(Arbol.C, RegistroControl);
  nResultado:=0;
  
  if RegistroControl.Ultimo <> _posicion_nula then
  begin

    for i:= 0 to RegistroControl.Ultimo do
    begin
      Seek(Arbol.N, i);
      Read(Arbol.N, RegistroNivel);

      nResultado:= nResultado + RegistroNivel.CantidadElementos;
    end;
  end;

  Arbol_CantidadElementos:= nResultado;
end;

//------------------------------------------------------------------------------

procedure Arbol_cambiarPorcentajeNiveles(var Arbol: Tipo_Arbol; porcentajeNivel: Tipo_Porcentaje);
var
  RegistroControl: Tipo_Registro_Control;
begin
  Seek(Arbol.C, 0);
  Read(Arbol.C, RegistroControl);

  RegistroControl.porcentajeNiveles:= porcentajeNivel;

  Seek(Arbol.C, 0);
  Write(Arbol.C, RegistroControl);
end;

//------------------------------------------------------------------------------

procedure Arbol_cambiarPorcentajeTolerancia(var Arbol: Tipo_Arbol; porcentajeTolerancia: Tipo_Porcentaje);
var
  RegistroControl: Tipo_Registro_Control;
begin
  Seek(Arbol.C, 0);
  Read(Arbol.C, RegistroControl);

  RegistroControl.porcentajeTolerancia:= porcentajeTolerancia;

  Seek(Arbol.C, 0);
  Write(Arbol.C, RegistroControl);
end;

end.


























	





























