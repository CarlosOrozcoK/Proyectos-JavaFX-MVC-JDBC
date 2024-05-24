drop database if exists MercaDB;

create database if not exists MercaDB;

use MercaDB;

 set global time_zone = '-6:00';

create table Clientes(
	clienteId int not null auto_increment,
    nombre varchar(30) not null,
    apellido varchar(30) not null,
    nitt varchar(15) not null,
    telefono varchar(15) not null,
    direccion varchar(200) not null,
    primary key PK_clienteId (clienteId)
);

create table Cargos(
	cargoId int not null auto_increment,
    nombreCargo varchar(30) not null,
    descripcionCargo varchar(100) not null,
    primary key PK_cargoId (cargoId)
);

create table Compras(
	compraId int not null auto_increment,
    fechaCompra date not null,
    totalCompra decimal(10, 2),
    primary key PK_compraId (compraId)
);

create table Distribuidores(
	distribuidorId int not null auto_increment,
    nombreDistribuidor varchar(30) not null,
    telefonoDistribuidor varchar(15) not null,
    nitDistribuidor varchar(15) not null,
	direccionDistribuidor varchar(200) not null,
    web varchar(50),
    primary key PK_distribuidorId (distribuidorId)
);

create table CategoriaProductos(
	categoriaProductoId int not null auto_increment,
    nombreCategoria varchar(30) not null,
    descripcionCategoria varchar(100) not null,
    Primary key PK_categoriaProductoId (categoriaProductoId)
);

create table Empleados(
	empleadoId int not null auto_increment,
    nombreEmpleado varchar(30) not null,
    apellidoEmpleado varchar(30) not null,
    sueldo decimal(10,2) not null,
    horaEntrada time not null,
    horaSalida time not null,
    cargoId int not null,
    encargadoId int,
    primary key PK_empleadoId (empleadoId),
    constraint FK_encargadoId foreign key Emplados (encargadoId)
		references Empleados (empleadoId),
	constraint FK_Empleados_Cargos foreign key Cargos (cargoId)
		references Cargos (cargoId)
);

create table Facturas(
	facturaId int not null auto_increment,
    fecha date not null,
    hora time not null,
    clienteId int not null,
    empleadoId int not null,
    total decimal,
    primary key PK_facturaId (facturaId),
    constraint FK_Facturas_Clientes foreign key Clientes (clienteId)
	references Clientes (clienteId),
    constraint FK_Facturas_Empleados foreign key Empleados (empleadoId)
		references Empleados (empleadoId)
);

create table TicketSoporte(
	ticketSoporteId int not null auto_increment,
    descripcionTicket varchar (250),
    estatus varchar (30),
    clienteId int not null,
    facturaId int not null, 
	primary key PK_ticketSoporteId (ticketSoporteId),
    constraint FK_TicketSoporte_Clientes foreign key TicketSoporte (clienteId)
		references Clientes (clienteId),
	constraint FK_TicketSoporte_Facturas foreign key TicketSoporte (facturaId)
		references Facturas (facturaId)
);

create table Productos(
	productoId int not null auto_increment,
    nombreProducto varchar(50),
    descripcionProducto varchar(100) not null,
    cantidadStock int not null,
    precioVentaUnitario decimal(10, 2) not null,
    precioVentaMayor decimal(10, 2) not null,
    precioCompra decimal(10, 2) not null,
    imagenProducto blob,
    distribuidorId int not null,
    categoriaProductoId int not null,
    primary key PK_productoId (productoId),
    constraint FK_Productos_Distribuidores foreign key Distribuidores (distribuidorId)
	references Distribuidores (distribuidorId),
    constraint FK_Productos_CategoriaProductos foreign key CategoriaProductos (categoriaProductoId)
		references CategoriaProductos (categoriaProductoId)
);

create table Promociones(
	promocionId int not null auto_increment,
    precioPromocion decimal (10,2),
    descripcionPromocion varchar (200),
    fechaInicio date,
    fechaFinalizacion date,
    productoId int not null,
    primary key PK_promocionId (promocionId),
    constraint FK_Promociones_Productos foreign key Promociones (productoId)
		references Productos (productoId)
);



create table DetalleFactura(
	detalleFacturaId int not null auto_increment,
    facturaId int not null,
    productoId int not null,
    primary key PK_detalleFacturaId (detalleFacturaId),
    constraint FK_DetalleFactura_Facturas foreign key Facturas (facturaId)
		references Facturas(facturaId),
    constraint FK_DetalleFactura_Productos foreign key Productos (productoId)
		references Productos (productoId)
);

create table DetalleCompra(
	detalleCompraId int not null auto_increment,
    cantidadCompra int not null,
    productoId int not null,
    compraId int not null,
    Primary key PK_detalleCompraId (detalleCompraId),
    constraint FK_DetalleCompra_Productos foreign key (productoId)
		references Productos (productoId),
	constraint FK_DetalleCompra_Compras foreign key (compraId)
		references Compras (compraId)
);

insert into clientes(nombre, apellido, telefono, direccion, nitt) values
	('Carlos', 'Morales', '5819-3637', 'Guatemala', '78987452-0'),
    ('Fatima', 'Campos', '5222-2260', 'San Marcos', '1730273-0'),
    ('Jose', 'Morejon', '4145-1054', 'Guatemala','7898543-0');
    
insert into Cargos(nombreCargo, descripcionCargo) values
    ('Gerente de ventas', 'Se encarga de hacer inventario y comprar todo');

insert into Empleados(nombreEmpleado, apellidoEmpleado, sueldo, horaEntrada, horaSalida, cargoId, encargadoId) values
    ('Carlos', 'Orozco', '200.00', '15:00:00', '23:00:00', 1, 1);
    
insert into Facturas(fecha, hora, clienteId, empleadoId, total) values
    ('2024-03-23', '20:00:00', 1, 1, '17.00');
    
insert into TicketSoporte(descripcionTicket, estatus, clienteId, facturaId) values
    ('Error de prueba', 'Recien creado', 1, 1);
    
Delimiter $$
create procedure sp_agregarCliente(nom varchar(30), ape varchar(30), tel varchar(15), dir varchar(200), nt varchar(15))
Begin
	insert into Clientes(nombre, apellido, telefono, nitt, direccion) values
		(nom, ape, tel, dir, nt);
End $$
Delimiter ;

call sp_agregarcliente('Alejandro', 'Gutierrez', '5514-9006', 'Guatemala', '4578589-0');
Delimiter $$
Create procedure sp_ListarClientes()
Begin
	Select
		Clientes.clienteId,
		Clientes.nombre,
		Clientes.apellido,
		Clientes.telefono,
        Clientes.nitt,
		Clientes.direccion
			From Clientes;
End$$
Delimiter ;

call sp_listarClientes();

Delimiter $$
Create procedure sp_EliminarCliente(In cliId int)
Begin
	Delete from Clientes
		Where clienteId = cliId;
End$$
Delimiter ;
 
Call sp_EliminarCliente(4);

Delimiter $$
Create procedure sp_BuscarCliente(In cliId int)
Begin
	Select
		Clientes.clienteId,
		Clientes.nombre,
		clientes.apellido,
		clientes.telefono,
        Clientes.nitt,
		Clientes.direccion
			From Clientes
				Where clienteId = cliId;
End$$
Delimiter ;
 
Call sp_BuscarCliente(1);

Delimiter $$
Create procedure sp_EditarCliente(In cliId int, In nom varchar(30), In ape varchar(30) , In tel varchar(15), In nt varchar(15), In dir varchar(200))
Begin
	Update Clientes
		Set
			nombre = nom,
			apellido = ape,
			telefono = tel,
			nitt = nt,
			direccion = dir
				Where clienteId = cliId;
End$$
Delimiter ;
 
Call sp_EditarCliente(3, 'Carlos', 'Orozco', '39679413', '13548217-0', 'Guatemala');

Delimiter $$
create procedure sp_agregarCargo(In nom varchar(30), In des varchar(100))
Begin
	insert into Cargos(nombreCargo, descripcionCargo) values
		(nom, des);
End $$
Delimiter ;

Delimiter $$
Create procedure sp_ListarCargos()
Begin
	Select
		Cargos.cargoId,
		Cargos.nombreCargo,
		Cargos.descripcionCargo
			From Cargos;
End$$
Delimiter ;

Delimiter $$
Create procedure sp_EliminarCargo(In carId int)
Begin
	Delete from Cargos
		Where cargoId = carId;
End$$
Delimiter ;

Delimiter $$
Create procedure sp_BuscarCargo(In carId int)
Begin
	Select
		Cargos.cargoId,
		Cargos.nombreCargo,
		Cargos.descripcionCargo
			From Cargos
				Where cargoId = carId;
End$$
Delimiter ;

Delimiter $$
Create procedure sp_EditarCargo(In carId int, In nom varchar(30), In des varchar(100))
Begin
	Update Cargos
		Set
			nombreCargo = nom,
			descripcionCargo = des
				Where cargoId = carId;
End$$
Delimiter ;

Delimiter $$
create procedure sp_agregarCompra(fec date, tot decimal(10,2))
Begin
	insert into Compras(fechaCompra, totalCompra) values
		(fec, tot);
End $$
Delimiter ;

Delimiter $$
Create procedure sp_ListarCompras()
Begin
	Select
		Compras.compraId,
		Compras.fechaCompra,
		Compras.totalCompra
			From Compras;
End$$
Delimiter ;

Delimiter $$
Create procedure sp_EliminarCompra(In comId int)
Begin
	Delete from Compras
		Where compraId = comId;
End$$
Delimiter ;

Delimiter $$
Create procedure sp_BuscarCompra(In comId int)
Begin
	Select
		Compras.compraId,
		Compras.fechaCompra,
		Compras.totalCompra
			From Compras
				Where compraId = comId;
End$$
Delimiter ;

Delimiter $$
Create procedure sp_EditarCompra(In comId int, In fec date, In tot decimal(10,2))
	Begin
		Update Compras
			Set
				fechaCompra = fec,
                totalCompra = tot
					Where compraId = comId;
	End$$
Delimiter ;

Delimiter $$
create procedure sp_agregarDistribuidor(In nom varchar(30), In tel varchar(15), In nt varchar(15), In dir varchar(200), In wb varchar(50))
Begin
	insert into Distribuidores(nombreDistribuidor, telefonoDistribuidor, nitDistribuidor, direccionDistribuidor, web) values
		(nom, tel, nt, dir, wb);
End $$
Delimiter ;

Delimiter $$
Create procedure sp_ListarDistribuidores()
Begin
	Select
		Distribuidores.distribuidorId,
		Distribuidores.nombreDistribuidor,
		Distribuidores.telefonoDistribuidor,
        Distribuidores.nitDistribuidor,
        Distribuidores.direccionDistribuidor,
        Distribuidores.web
			From Distribuidores;
End$$
Delimiter ;

Delimiter $$
Create procedure sp_EliminarDistribuidor(In disId int)
Begin
	Delete from Distribuidores
		Where distribuidorId = disId;
End$$
Delimiter ;

Delimiter $$
Create procedure sp_BuscarDistribuidor(In disId int)
Begin
	Select
		Distribuidores.distribuidorId,
		Distribuidores.nombreDistribuidor,
		Distribuidores.telefonoDistribuidor,
        Distribuidores.nitDistribuidor,
        Distribuidores.direccionDistribuidor,
        Distribuidores.web
			From Distribuidores
				Where distribuidorId = disId;
End$$
Delimiter ;

Delimiter $$
Create procedure sp_EditarDistribuidor(In disId int, In nom varchar(30), In tel varchar(15), In nt varchar(15), In dir varchar(200), In wb varchar(50))
Begin
	Update Distribuidores
		Set
			nombreDistribuidor = nom,
			telefonoDistribuidor = tel,
			nitDistribuidor = nt,
			direccionDistribuidor = dir,
			web = wb
				Where distribuidorId = disId;
End$$
Delimiter ;

Delimiter $$
create procedure sp_agregarCategoriaProducto(In nom varchar(30), In des varchar(100))
Begin
	insert into CategoriaProductos(nombreCategoria, descripcionCategoria) values
		(nom, des);
End $$
Delimiter ;

Delimiter $$
Create procedure sp_ListarCategoriaProductos()
Begin
	Select
		CategoriaProductos.categoriaProductoId,
		CategoriaProductos.nombreCategoria,
		CategoriaProductos.descripcionCategoria
			From CategoriaProductos;
End$$
Delimiter ;

Delimiter $$
Create procedure sp_EliminarCategoriaProducto(In capId int)
Begin
	Delete from CategoriaProductos
		Where categoriaProductoId = capId;
End$$
Delimiter ;

Delimiter $$
Create procedure sp_BuscarCategoriaProducto(In capId int)
Begin
	Select
		CategoriaProductos.categoriaProductoId,
		CategoriaProductos.nombreCategoria,
		CategoriaProductos.descripcionCategoria
			From CategoriaProductos
				Where categoriaProductoId = capId;
End$$
Delimiter ;

Delimiter $$
Create procedure sp_EditarCategoriaProducto(In capId int, In nom varchar(30), In des varchar(100))
Begin
	Update CategoriaProductos
		Set
			nombreCategoria = nom,
			descripcionCategoria = des
				Where categoriaProductoId = capId;
End$$ 
Delimiter ;

delimiter $$ 
create procedure sp_agregarTicketSoporte(In des varchar(250), In cliId int, In facId int)
begin 
    insert into TicketSoporte(descripcionTicket, estatus, clienteId, facturaId) values
		(des, 'Recien creado', cliId, facId); 
end $$ 
delimiter ;
 

delimiter $$ 

create procedure sp_listarTicketSoporte() 
begin 
    select TS.ticketSoporteId, TS.descripcionTicket, TS.estatus,
    concat("Id: ", C.clienteId, " | ", C.nombre, " ", C.apellido, " ") As cliente, TS.facturaId from TicketSoporte TS
    Join Clientes C on TS.clienteId = C.clienteId;
end $$ 
delimiter ;

call sp_listarTicketSoporte();
 
 
delimiter $$ 
create procedure sp_eliminarTicketSoporte(In ticId int) 
begin 
    delete from TicketSoporte 
		where ticketSoporteId = ticId; 
end $$ 
delimiter ;
 
delimiter $$ 
create procedure sp_buscarTicketSoporte(In ticId int) 
begin 
    select
		TicketSoporte.ticketSoporteId, 
        TicketSoporte.descripcionTicket, 
        TicketSoporte.estatus, 
        TicketSoporte.clienteId, 
        TicketSoporte.facturaId
			from TicketSoporte 
				where ticketSoporteId = ticId; 
end $$ 
delimiter ;
 
delimiter $$ 
create procedure sp_editarTicketSoporte(In ticId int, In des varchar(250), In est varchar(30), In cliId int, In facId int) 
begin 
    update TicketSoporte 
		set 
			descripcionTicket = des, 
			estatus = est, 
			clienteId = cliId,
            facturaId = facId
				where ticketSoporteId = ticId; 
end $$ 
delimiter ; 

delimiter $$
create procedure sp_agregarProducto(In nom varchar(50), In des varchar(100), In cant int, In preU decimal(10,2), In preM decimal(10,2), In preC decimal(10,2), In img blob, In disId int, In capId int)
begin
    insert into Productos(nombreProducto, descripcionProducto, cantidadStock, precioVentaUnitario, precioVentaMayor, precioCompra, imagenProducto, distribuidorId, categoriaProductoId) values 
		(nom, des, cant, preU, preM, preC, img, disId, capId);
end $$
delimiter ; 

delimiter $$
create procedure sp_listarProductos()
begin
    select
        Productos.productoId,
        Productos.nombreProducto,
        Productos.descripcionProducto,
        Productos.cantidadStock,
        Productos.precioVentaUnitario,
        Productos.precioVentaMayor,
        Productos.precioCompra,
        Productos.imagenProducto,
        Productos.distribuidorId,
        Productos.categoriaProductoId
			from Productos;
end $$
delimiter ;

delimiter $$
create procedure sp_buscarProducto(In proId int)
begin
    select
        Productos.productoId,
        Productos.nombreProducto,
        Productos.descripcionProducto,
        Productos.cantidadStock,
        Productos.precioVentaUnitario,
        Productos.precioVentaMayor,
        Productos.precioCompra,
        Productos.imagenProducto,
        Productos.distribuidorId,
        Productos.categoriaProductoId
			from Productos
				where productoId = proId;
end $$

delimiter $$
create procedure sp_eliminarProducto(In proId int)
begin
    delete from Productos
		where productoId = proId;
end $$
delimiter ;

delimiter $$
create procedure sp_editarProducto(In proId int, In nom varchar(50), In des varchar(100), In cant int, In preU decimal(10,2), In preM decimal(10,2), In preC decimal(10,2), In img blob, In disId int, In capId int)
begin
    update Productos
		set
			nombreProducto = nom,
			descripcionProducto = des,
			cantidadStock = cant,
			precioVentaUnitario = preU,
			precioVentaMayor = preM,
			precioCompra = preC,
			imagenProducto = img,
			distribuidorId = disId,
			categoriaProductoId = capId
				where productoId = proId;
end $$
delimiter ;

delimiter $$
create procedure sp_agregarPromociones(In pre decimal(10,2), In des varchar(200), In fecI date, In fecF date, In proId int)
begin
    insert into Promociones(precioPromocion, descripcionPromocion, fechaInicio, fechaFinalizacion, productoId) values 
		(pre, des, fecI, fecF, proId);
end $$
delimiter ;

delimiter $$
create procedure sp_listarPromociones()
begin
    select
        Promociones.promocionId,
        Promociones.precioPromocion,
        Promociones.descripcionPromocion,
        Promociones.fechaInicio,
        Promociones.fechaFinalizacion,
        Promociones.productoId
			from Promociones;
end $$
delimiter ;

delimiter $$
create procedure sp_eliminarPromociones(In promId int)
begin
    delete from Promociones
		where promocionId = promId;
end $$
delimiter ;

delimiter $$
create procedure sp_buscarPromociones(In promId int)
begin
    select
        Promociones.promocionId,
        Promociones.precioPromocion,
        Promociones.descripcionPromocion,
        Promociones.fechaInicio,
        Promociones.fechaFinalizacion,
        Promociones.productoId
			from promociones
				where promocionId = promId;
end $$
delimiter ;

delimiter $$
create procedure sp_editarPromociones(In promId int, In pre decimal(10,2), In des varchar(200), In fecI date, In fecF date, In proId int)
begin
    update Promociones
    set
        precioPromocion = pre,
        descripcionPromocion = des,
        fechaInicio = fecI,
        fechaFinalizacion = fecF,
        productoId = proId
			where promocionId = promId;
end $$
delimiter ;

delimiter $$
create procedure sp_agregarEmpleado(In nom varchar(30), In ape varchar(30), In sue decimal(10,2), In horaE time, In horaS time, In carId int, in encId int)
begin
    insert into Empleados(nombreEmpleado,apellidoEmpleado,sueldo,horaEntrada,horaSalida,cargoId, EncargadoId) values
		(nom, ape, sue, horaE, horaS, carId, encId);
end $$
delimiter ;

delimiter $$
create procedure sp_listarEmpleados()
begin
   select E.empleadoId, E.nombreEmpleado, E.apellidoEmpleado, E.sueldo, E.horaEntrada, E.horaSalida,
		   concat("Id: ", C.cargoId, " | ", C.nombreCargo, " | ", C.descripcionCargo) As Cargo, concat("Id: ", E.encargadoId) As Encargado from Empleados E
           Join Cargos C on E.cargoId = C.cargoId;
end $$
delimiter ;

delimiter $$
create procedure sp_eliminarEmpleado(In empId int)
begin
    delete from Empleados
		where empleadoId = empId;
end $$
delimiter ;

delimiter $$
create procedure sp_buscarEmpleado(In empId int)
begin
    select
		Empleados.empleadoId,
        Empleados.nombreEmpleado,
        Empleados.apellidoEmpleado,
        Empleados.sueldo,
        Empleados.horaEntrada,
        Empleados.horaSalida,
        Empleados.cargoId,
        Empleados.encargadoId
			from Empleados
				where empleadoId = empId;
end $$
delimiter ;

delimiter $$
create procedure sp_editarEmpleado(In empId int, In nom varchar(30), In ape varchar(30), In sue decimal(10,2), In horaE time, In horaS time, In carId int, In encId int)
begin
    update Empleados
		set
			nombreEmpleado = nom,
			apellidoEmpleado = ape,
			sueldo = sue,
			horaEntrada = horaE,
			horaSalida = horaS,
			cargoId = carId,
			encargadoId = encId
				where empleadoId = empId;
end $$
delimiter ;

delimiter $$
create procedure sp_AsignarEncargado(In empId Int, In encId int)
begin
	Update Empleados  
		Set 
			Empleados.encargadoId = encarId
				Where empleadoId = empId;
end$$
Delimiter ;

delimiter $$
create procedure sp_agregarFactura(In fec date, In hor time, In cliId int, In empId int, In tot decimal)
begin
    insert into Facturas(fecha, hora, clienteId, empleadoId, total) values 
		(fec, hor, cliId, empId, tot);
end $$
delimiter ;

delimiter $$
create procedure sp_listarFacturas()
begin
   select F.facturaId, F.fecha, F.hora, F.total,
		   concat("Id: ", C.clienteId, " | ", C.nombre, " ", C.apellido) As Cliente, concat("Id: ", E.empleadoId, " | ", E.nombreEmpleado) As Empleado from Facturas F
           Join Clientes C on F.clienteId = C.clienteId
           Join Empleados E on F.empleadoId = E.empleadoId;
end $$
delimiter ;

delimiter $$
create procedure sp_eliminarFactura(In facId int)
begin
    delete from Facturas
		where facturaId = facId;
end $$
delimiter ;

delimiter $$
create procedure sp_buscarFactura(In facId int)
begin
    select
        Facturas.facturaId,
        Facturas.fecha,
        Facturas.hora,
        Facturas.clienteId,
        Facturas.empleadoId,
        Facturas.total
			from Facturas
				where facturaId = facId;
end $$
delimiter ;

delimiter $$
create procedure sp_editarFactura(In facId int, In fec date, In hor time, In cliId int, In empId int, In tot decimal)
begin
    update Facturas
		set
			fecha = fec,
			hora = hor,
			clienteId = cliId,
			empleadoId = empId,
			total = tot
				where facturaId = facId;
end $$
delimiter ;

delimiter $$
create procedure sp_agregarDetalleFactura(In facId int, In proId int)
begin
    insert into DetalleFactura(facturaId, productoId) values 
		(facId, proId);
end $$
delimiter ;

delimiter $$
create procedure sp_listarDetalleFactura()
begin
    select DF.detalleFacturaId,
		   concat("Id: ", F.facturaId) As factura, concat("Id: ", P.productoId, " | ", P.nombreProducto, " | ", P.descripcionProducto) As producto From DetalleFactura DF
           Join Facturas F on DF.facturaId = F.facturaId
           Join Productos P on DF.productoId = P.productoId;
end $$
delimiter ;

delimiter $$
create procedure sp_eliminarDetalleFactura(In detFacId int)
begin
    delete from DetalleFactura
		where detalleFacturaId = detFacId;
end $$
delimiter ;

delimiter $$
create procedure sp_buscarDetalleFactura(In detFacId int)
begin
    select
        DetalleFactura.detalleFacturaId,
        DetalleFactura.facturaId,
        DetalleFactura.productoId
			from detallefactura
				where detalleFacturaId = detFacId;
end $$
delimiter ;

delimiter $$
create procedure sp_editarDetalleFactura(In detFacId int, In facId int, In proId int)
begin
    update DetalleFactura
    set
        facturaId = facId,
        productoId = proId
			where detalleFacturaId = detFacId;
end $$
delimiter ;

delimiter $$
create procedure sp_agregarDetalleCompra(In can int, In proId int, In comId int)
begin
    insert into DetalleCompra(cantidadCompra, productoId, compraId) values 
		(can, prodId, comId);
end $$
delimiter ;

delimiter $$
create procedure sp_listarDetalleCompra()
begin
    select
        DetalleCompra.detalleCompraId,
        DetalleCompra.cantidadCompra,
        DetalleCompra.productoId,
        DetalleCompra.compraId
			from DetalleCompra;
end $$
delimiter ;

delimiter $$
create procedure sp_eliminarDetalleCompra(In detComId int)
begin
    delete from DetalleCompra
		where detalleCompraId = detComId;
end $$
delimiter ;

delimiter $$
create procedure sp_buscarDetalleCompra(In detComId int)
begin
    select
        DetalleCompra.detalleCompraId,
        DetalleCompra.cantidadCompra,
        DetalleCompra.productoId,
        DetalleCompra.compraId
			from DetalleCompra
				where detalleCompraId = detComId;
end $$
delimiter ;

delimiter $$
create procedure sp_editarDetalleCompra(In detComId int, can int, In proId int, In comId int)
begin
    update DetalleCompra
		set
			cantidadCompra = can,
			productoId = proId,
			compraId = comId
				where detalleCompraId = detComId;
end $$
delimiter ;