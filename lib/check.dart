// // ignore_for_file: import_of_legacy_library_into_null_safe, use_key_in_widget_constructors, non_constant_identifier_names, avoid_print, prefer_final_fields, prefer_const_constructors, unused_element, unnecessary_cast

// import 'dart:convert';
// import 'dart:developer';

// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:lbm_crm/util/app_key.dart';

// class Check extends StatefulWidget {
//   static const id = 'Check';
//   @override
//   State<Check> createState() => _CheckState();
// }

// class _CheckState extends State<Check> {
//   // List l1 = [
//   //   " LBM ",
//   //   " SOLUTIONS ",
//   //   " Leads ",
//   //   " Invoice ",
//   //   " See all ",
//   //   " LEADS OVERVIEW ",
//   //   " PROJECT STATUS ",
//   //   " Status ",
//   //   " Filter ",
//   //   " A-Z Sort ",
//   //   " Z-A Sort ",
//   //   " Company ",
//   //   " Added ",
//   //   " Billing Address ",
//   //   " Source ",
//   //   " Last Contact ",
//   //   " Last Status Change ",
//   //   " Last Lead Status ",
//   //   " Staff Name ",
//   //   " Notes ",
//   //   " Tasks ",
//   //   " Reminders ",
//   //   " Related ",
//   //   " Proposal ",
//   //   " Detail ",
//   //   " Add Estimate ",
//   //   " Customer ",
//   //   " Invoice Number ",
//   //   " Estimate Date ",
//   //   " Expire Date ",
//   //   " Currency ",
//   //   " Reference ",
//   //   " Sale Agent ",
//   //   " Discount ",
//   //   " Admin Note ",
//   //   " Total Item ",
//   //   " Choose Item ",
//   //   " Select One ",
//   //   " Select Invoice Date ",
//   //   " Select Currency ",
//   //   " Select Status ",
//   //   " Select Sale Agent ",
//   //   " Select ",
//   //   " Add Item ",
//   //   " Submit ",
//   //   " Due Amount ",
//   //   " Total Amount ",
//   //   " Add Invoice ",
//   //   " Invoice Date ",
//   //   " Prevent Sending Overdue Reminders For This Invoice ",
//   //   " Allow payment modes for this invoice ",
//   //   " Recurring Invoice ",
//   //   " Invoices ",
//   //   " Invoice Date ",
//   //   " Due Date ",
//   //   " Shipping Address ",
//   //   " Address ",
//   //   " Country ",
//   //   " ITEMS ",
//   //   " Sub Total ",
//   //   " Total ",
//   //   " QTY ",
//   //   " Amount ",
//   //   " IGST ",
//   //   " Total Paid ",
//   //   " View PDF ",
//   //   " Add Announcement ",
//   //   " Subject ",
//   //   " Search Task ",
//   //   " Show to Staff ",
//   //   " Show to Client ",
//   //   " Show my Name ",
//   //   " Announcements ",
//   //   " Name ",
//   //   " Date ",
//   //   " Appointment ",
//   //   " Description ",
//   //   " Date/Time ",
//   //   " Location ",
//   //   " Attendees ",
//   //   " Enter Subject ",
//   //   " Select Date ",
//   //   " Your Text Here... ",
//   //   " Nothing Selected ",
//   //   "  Select Follower ",
//   //   " SMS Notification ",
//   //   " Email Notification ",
//   //   " New Contracts ",
//   //   " Public ",
//   //   " Private ",
//   //   " Please enter the subject ",
//   //   " Contract Value ",
//   //   " Contract Type ",
//   //   " Start Date ",
//   //   " End Date ",
//   //   " Please enter the description ",
//   //   " Save ",
//   //   " Contracts ",
//   //   " Search Text ",
//   //   " Project ",
//   //   " Signature ",
//   //   " Add New Customer ",
//   //   " Enter the details asked below ",
//   //   " Comapny Name ",
//   //   " Website ",
//   //   " GSTIN Number ",
//   //   " Phone Number ",
//   //   " Groups ",
//   //   " Search ",
//   //   " System Default ",
//   //   " City ",
//   //   " Street ",
//   //   " State ",
//   //   " ZIp Code ",
//   //   " Same As ",
//   //   " Fields ",
//   //   " Customers ",
//   //   " Search Customers ",
//   //   " Exclude Inactive Customers ",
//   //   " Details ",
//   //   " Contacts ",
//   //   " Performa Invoices ",
//   //   " Estimates ",
//   //   " Projects ",
//   //   " Tickets ",
//   //   " Files ",
//   //   " Search Contacts ",
//   //   " Search Notes ",
//   //   " Search Performa ",
//   //   " Search Estimates ",
//   //   " Search Projects ",
//   //   " Search Tickets ",
//   //   " Search Files ",
//   //   " Search Reminders ",
//   //   " GST ",
//   //   " Last Login ",
//   //   " Add New Expenses ",
//   //   " Attach Reciept ",
//   //   " Note ",
//   //   " Expense Category ",
//   //   " Expense Date ",
//   //   " Select Expense Date ",
//   //   " Advanced Options ",
//   //   " Tax 1 ",
//   //   " Tax 2 ",
//   //   " Payment Mode ",
//   //   " Repeat ",
//   //   " EXPENSES ",
//   //   " Search Expenses ",
//   //   " Category ",
//   //   " Title ",
//   //   " Company Name ",
//   //   " City Name ",
//   //   " Language ",
//   //   " State Name ",
//   //   " Select Tags ",
//   //   " Select Assigned ",
//   //   " Select Language ",
//   //   " Select Source ",
//   //   " Select Contact Date ",
//   //   " Select Contact Today ",
//   //   " ADD NEW PROPOSALS ",
//   //   " Allow Comment ",
//   //   " Open Till ",
//   //   " Discount Type ",
//   //   " Assigned ",
//   //   " To ",
//   //   " Email ",
//   //   " Phone ",
//   //   " PROPOSALS ",
//   //   " Proposal-TO ",
//   //   " ADD NEW TASKS ",
//   //   " Billable ",
//   //   " Hourly Rate ",
//   //   " Enter Hourly Rate ",
//   //   " Repeat Every ",
//   //   " Select Priority ",
//   //   " Related To ",
//   //   " Tags ",
//   //   " Cancel ",
//   //   " Start Timer ",
//   //   " CheckList Items ",
//   //   " Comments ",
//   //   " ADD NEW TICKET ",
//   //   " Email Address ",
//   //   " Department ",
//   //   " CC ",
//   //   " Assign Ticket (default is current user) ",
//   //   " Select Service ",
//   //   " Select and begin typing ",
//   //   " Ticket Body ",
//   //   " Insert Predefined Reply ",
//   //   " No File ",
//   //   " Select Image ",
//   //   " Camera ",
//   //   " Gallery ",
//   //   " SUPPORT ",
//   //   " Dept. ",
//   //   " Last Reply ",
//   //   " PAYMENT ",
//   //   " Mode ",
//   //   " Payment Date ",
//   //   " Payment Reciept ",
//   //   " Amount Due ",
//   //   " Payment Amount ",
//   //   " Invoice Amount ",
//   //   " DeadLine Date ",
//   //   " Create Date ",
//   //   " Finished Line ",
//   //   " Billing Type ",
//   //   " Total Rate ",
//   //   " Deadline ",
//   //   " Domain Name ",
//   //   " Members ",
//   //   " Project Overview ",
//   //   " Discussion ",
//   //   " Chat ",
//   //   " Staff ",
//   //   " Group ",
//   //   " Client ",
//   //   " Download ",
//   //   " Reply ",
//   //   " Created At ",
//   //   " Expired ",
//   //   " Summary ",
//   //   " Personal Informaton ",
//   //   " New Task ",
//   //   " New Notes ",
//   //   " New Reminder ",
//   //   " Priority ",
//   //   " Send Reminder On Email ",
//   //   " I Got in Touch With This Lead ",
//   //   " I Have Not Connected This Lead "
//   // ];

//   // /// ///

//   // /// ///

//   // List l2 = [
//   //   "LBM",
//   //   "SOLUCIONES",
//   //   "Dirige",
//   //   "Factura",
//   //   "Ver todo",
//   //   "DESCRIPCIÓN GENERAL DE LOS CLIENTES",
//   //   "ESTADO DEL PROYECTO",
//   //   "Estado",
//   //   "Filtrar",
//   //   "Orden A-Z",
//   //   "Clasificación Z-A",
//   //   "Compañía",
//   //   "Adicional",
//   //   "Dirección de Envio",
//   //   "Fuente",
//   //   "Último contacto",
//   //   "Último cambio de estado",
//   //   "Estado del último cliente potencial",
//   //   "Nombre del personal",
//   //   "Notas",
//   //   "Tareas",
//   //   "Recordatorios",
//   //   "Relacionado",
//   //   "Propuesta",
//   //   "Detalle",
//   //   "Añadir presupuesto",
//   //   "Cliente",
//   //   "Número de factura",
//   //   "Fecha estimada",
//   //   "Fecha de caducidad",
//   //   "Divisa",
//   //   "Referencia",
//   //   "Agente de Ventas",
//   //   "Descuento",
//   //   "Nota de administrador",
//   //   "Artículo total",
//   //   "Elegir artículo",
//   //   "Seleccione uno",
//   //   "Seleccionar fecha de factura",
//   //   "Seleccione el tipo de moneda",
//   //   "Seleccionar Estado",
//   //   "Seleccionar Agente de Ventas",
//   //   "Seleccione",
//   //   "Añadir artículo",
//   //   "Enviar",
//   //   "Cantidad debida",
//   //   "Cantidad total",
//   //   "Añadir Factura",
//   //   "Fecha de la factura",
//   //   "Evitar el envío de recordatorios vencidos para esta factura",
//   //   "Permitir modos de pago para esta factura",
//   //   "Factura recurrente",
//   //   "Facturas",
//   //   "Fecha de la factura",
//   //   "Fecha de vencimiento",
//   //   "Dirección de Envío",
//   //   "Dirección",
//   //   "País",
//   //   "ELEMENTOS",
//   //   "Subtotal",
//   //   "Total",
//   //   "CANTIDAD",
//   //   "Monto",
//   //   "IGST",
//   //   "Total pagado",
//   //   "Ver PDF",
//   //   "Añadir Anuncio",
//   //   "Tema",
//   //   "Tarea de búsqueda",
//   //   "Mostrar al personal",
//   //   "Mostrar al cliente",
//   //   "Mostrar mi nombre",
//   //   "Anuncios",
//   //   "Nombre",
//   //   "Fecha",
//   //   "Cita",
//   //   "Descripción",
//   //   "Fecha y hora",
//   //   "Ubicación",
//   //   "asistentes",
//   //   "Ingrese Asunto",
//   //   "Seleccione fecha",
//   //   "Tu texto aqui...",
//   //   "Nada seleccionado",
//   //   "Seleccionar seguidor",
//   //   "Notificación SMS",
//   //   "Notificación de correo electrónico",
//   //   "Nuevos Contratos",
//   //   "Público",
//   //   "Privado",
//   //   "Por favor ingrese el asunto",
//   //   "Valor del contrato",
//   //   "Tipo de contrato",
//   //   "Fecha de inicio",
//   //   "Fecha final",
//   //   "Por favor ingrese la descripción",
//   //   "Ahorrar",
//   //   "Contratos",
//   //   "Buscar texto",
//   //   "Proyecto",
//   //   "Firma",
//   //   "Agregar nuevo cliente",
//   //   "Ingrese los detalles solicitados a continuación",
//   //   "Nombre de la empresa",
//   //   "Sitio web",
//   //   "Número GSTIN",
//   //   "Número de teléfono",
//   //   "Grupos",
//   //   "Búsqueda",
//   //   "Sistema por defecto",
//   //   "Ciudad",
//   //   "Calle",
//   //   "Estado",
//   //   "Código postal",
//   //   "Igual que",
//   //   "Campos",
//   //   "Clientes",
//   //   "Buscar Clientes",
//   //   "Excluir Clientes Inactivos",
//   //   "Detalles",
//   //   "Contactos",
//   //   "Performa Facturas",
//   //   "Estimados",
//   //   "Proyectos",
//   //   "Entradas",
//   //   "Archivos",
//   //   "Buscar contactos",
//   //   "Buscar notas",
//   //   "Buscar performa",
//   //   "Buscar estimaciones",
//   //   "Buscar Proyectos",
//   //   "Buscar entradas",
//   //   "Buscar archivos",
//   //   "Recordatorios de búsqueda",
//   //   "GST",
//   //   "Último acceso",
//   //   "Agregar nuevos gastos",
//   //   "Adjuntar recibo",
//   //   "Nota",
//   //   "Categoría de gastos",
//   //   "Fecha de gastos",
//   //   "Seleccionar Fecha de Gasto",
//   //   "Opciones avanzadas",
//   //   "Impuesto 1",
//   //   "Impuesto 2",
//   //   "Modo de pago",
//   //   "Repetir",
//   //   "GASTOS",
//   //   "Buscar Gastos",
//   //   "Categoría",
//   //   "Título",
//   //   "Nombre de empresa",
//   //   "Nombre de la ciudad",
//   //   "Idioma",
//   //   "Nombre del Estado",
//   //   "Seleccionar etiquetas",
//   //   "Seleccionar Asignado",
//   //   "Seleccione el idioma",
//   //   "Seleccionar fuente",
//   //   "Seleccionar fecha de contacto",
//   //   "Seleccione contacto hoy",
//   //   "AGREGAR NUEVAS PROPUESTAS",
//   //   "Permitir comentario",
//   //   "Abierto hasta",
//   //   "Tipo de descuento",
//   //   "Asignado",
//   //   "A",
//   //   "Correo electrónico",
//   //   "Teléfono",
//   //   "PROPUESTAS",
//   //   "Propuesta-TO",
//   //   "AGREGAR NUEVAS TAREAS",
//   //   "Facturable",
//   //   "Tarifa por hora",
//   //   "Ingresar tarifa por hora",
//   //   "Repite cada",
//   //   "Seleccionar Prioridad",
//   //   "Relacionado con",
//   //   "Etiquetas",
//   //   "Cancelar",
//   //   "Iniciar temporizador",
//   //   "Elementos de la lista de verificación",
//   //   "Comentarios",
//   //   "AÑADIR NUEVO BILLETE",
//   //   "Dirección de correo electrónico",
//   //   "Departamento",
//   //   "CC",
//   //   "Asignar ticket (el valor predeterminado es el usuario actual)",
//   //   "Seleccionar Servicio",
//   //   "Seleccione y comience a escribir",
//   //   "Cuerpo del boleto",
//   //   "Insertar respuesta predefinida",
//   //   "Ningún archivo",
//   //   "Seleccionar imagen",
//   //   "Cámara",
//   //   "Galería",
//   //   "APOYO",
//   //   "Depto.",
//   //   "Última respuesta",
//   //   "PAGO",
//   //   "Modo",
//   //   "Fecha de pago",
//   //   "Recibo de pago",
//   //   "Cantidad adeudada",
//   //   "Monto del pago",
//   //   "Monto de la factura",
//   //   "Fecha límite",
//   //   "Fecha de Creación",
//   //   "Línea Terminada",
//   //   "Tipo de facturación",
//   //   "Tarifa total",
//   //   "Plazo",
//   //   "Nombre de dominio",
//   //   "Miembros",
//   //   "Descripción del proyecto",
//   //   "Discusión",
//   //   "Charlar",
//   //   "Personal",
//   //   "Grupo",
//   //   "Cliente",
//   //   "Descargar",
//   //   "Respuesta",
//   //   "Creado en",
//   //   "Venció",
//   //   "Resumen",
//   //   "Información Personal",
//   //   "Nueva tarea",
//   //   "Nuevas Notas",
//   //   "Nuevo recordatorio",
//   //   "Prioridad",
//   //   "Enviar recordatorio por correo electrónico",
//   //   "Me puse en contacto con este cliente potencial",
//   //   "No he conectado este cliente potencial"
//   // ];

//   // getlang() {
//   //   Map newmap = {};
//   //   for (var i = 0; i < l1.length; i++) {
//   //     newmap.addAll({'"${l1[i]}"': '"${l2[i]}"'});
//   //   }
//   //   log(newmap.toString());
//   //   print(newmap.length);
//   // }

//   Future<void> getNotification() async {
//     String firebaseServerKey =
//         'AAAAMue_ylA:APA91bHIASApWJVz-VTt2PJ0wVGo4lik1x9OtO290ECgYgFemSBFM6R5uRDdLHO_riqN9XQO12r2AJwu1j-BjSp7zZpHVdZopjCsOuqOLB5E0bPKtyfLauV97cRqI9ZfTCCrMu2spAHy';
//     String customerFcmToken =
//         'fASiHrx_SrCuWK0b7-i5E2:APA91bHXSbyr_7Ji5C2Z2zPlzJnPKeDb53wXqreSsEbQTmBMKsdFfxCQ3tkWmsXedZnV9KpGu4b55767acXCRSOe3FbRrOnUAYV-eNagWoedYIu7ABu0NjFejn_6KpilY9nNl0dQrnLf';
//     try {
//       await http
//           .post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
//               headers: <String, String>{
//                 'Content-Type': 'application/json',
//                 'Authorization': 'key=$firebaseServerKey'
//               },
//               body: jsonEncode({
//                 'notification': <String, dynamic>{
//                   'title': 'My Notification',
//                   'body':
//                       '[{id: 13, name: bandhu, description: , status: 2, clientid: 117, billing_type: 1, start_date: 2022-09-12, deadline: null, project_created: 2022-09-12, date_finished: null, progress: 0, progress_from_tasks: 1, project_cost: 1000.00, project_rate_per_hour: 0.00, estimated_hours: 0.00, addedfrom: 1, currency_name: null, addedfrom_name: John Doe, projectstatusname: {id: 2, color: #03a9f4, name: In Progress, order: 2, filter_default: true}, status_color: #84c529, extra_field: [], tags_field: [], datamembers: [{id: 13, project_id: 13, staff_id: 1, profile_image: logo lbm-WHITE.png, member_name: John Doe}, {id: 14, project_id: 13, staff_id: 3, profile_image: null, member_name: John Doe}, {id: 15, project_id: 13, staff_id: 2, profile_image: images.png, member_name: demo test}]}]',
//                   'sound': 'true'
//                 },
//                 'priority': 'high',
//                 'data': <String, dynamic>{
//                   'root': 'null',
//                   'data':
//                       '[{id: 13, name: bandhu, description: , status: 2, clientid: 117, billing_type: 1, start_date: 2022-09-12, deadline: null, project_created: 2022-09-12, date_finished: null, progress: 0, progress_from_tasks: 1, project_cost: 1000.00, project_rate_per_hour: 0.00, estimated_hours: 0.00, addedfrom: 1, currency_name: null, addedfrom_name: John Doe, projectstatusname: {id: 2, color: #03a9f4, name: In Progress, order: 2, filter_default: true}, status_color: #84c529, extra_field: [], tags_field: [], datamembers: [{id: 13, project_id: 13, staff_id: 1, profile_image: logo lbm-WHITE.png, member_name: John Doe}, {id: 14, project_id: 13, staff_id: 3, profile_image: null, member_name: John Doe}, {id: 15, project_id: 13, staff_id: 2, profile_image: images.png, member_name: demo test}]}]'
//                 },
//                 'to': customerFcmToken
//               }))
//           .whenComplete(() => print('Message Sent  '));
//     } catch (e) {
//       log('Error Occoured --> $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(
//             // width: width,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     getNotification();
//                   },
//                   child: Text(KeyValues.advancedOptions).tr(),
//                 ),
//                 GestureDetector(
//                   onTap: () {},
//                   child: Text(KeyValues.notConnected).tr(),
//                 ),
//               ],
//             ),
//           ),
//           // SizedBox(
//           //   width: width * 0.5,
//           //   child:
//           // child: DropdownButtonFormField(
//           //   isExpanded: true,
//           //   hint: Text(
//           //     "Select",
//           //     style: TextStyle(fontSize: 14.0),
//           //   ),
//           //   value: selectedItem,
//           //   onChanged: (Value) {
//           //     FocusManager.instance.primaryFocus?.unfocus();
//           //     setState(() {
//           //       selectedItem = Value as String?;
//           //       crmleadlist.clear();
//           //       crmleadlist.addAll(newcrmleadlist
//           //           .where((element) => element.status == selectedItem));
//           //       print("value : " + selectedItem!);
//           //     });
//           //   },
//           //   validator: (value) => value == null ? 'Select Related' : null,
//           //   items: statusList.map((user) {
//           //     return DropdownMenuItem(
//           //       value: user,
//           //       child: Row(
//           //         children: <Widget>[
//           //           Text(
//           //             user,
//           //             style: TextStyle(fontSize: 14.0),
//           //           ),
//           //         ],
//           //       ),
//           //     );
//           //   }).toList(),
//           // ),
//           // ),
//         ],
//       ),
//     );
//   }
// }

// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lbm_crm/util/colors.dart';
import 'package:lbm_crm/util/image_picker.dart';

import 'Support/support_detail_screen.dart';
import 'util/commonClass.dart';

class P2PChatPage extends StatefulWidget {
  static const id = 'P2PChatPage';
  var orderId;

  @override
  State<P2PChatPage> createState() => _P2PChatPageState();
}

class _P2PChatPageState extends State<P2PChatPage> {
  bool light = false;
  bool loading = true;
  bool sending = false;
  Map orderData = {};
  String userID = '';
  List messagesList = [];
  TextEditingController messageController = TextEditingController();
  File? image;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (image != null)
            Container(
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.file(
                    image!,
                    height: 30,
                    width: 30,
                    fit: BoxFit.fill,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        image = null;
                      });
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3, vertical: 0.5),
            color: ColorCollection.backColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 50,
                  child: TextFormField(
                    controller: messageController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write A Message....',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        image = await pickImageFromGallery();
                        setState(() {});
                      },
                      icon: RotatedBox(
                        quarterTurns: 1,
                        child: Icon(
                          Icons.attach_file,
                          size: 30,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        // if (sending) {
                        //   return;
                        // }

                        // if (image != null && messageController.text.isEmpty) {
                        //   setState(() {
                        //     sending = true;
                        //   });

                        //   await p2pSendMessage(
                        //           matchID: widget.orderId.toString(),
                        //           message: messageController.text,
                        //           image: image)
                        //       .then((result) {
                        //     if (result) {
                        //       setState(() {
                        //         sending = false;
                        //         image = null;
                        //         messageController.clear();
                        //         FocusManager.instance.primaryFocus?.unfocus();
                        //       });

                        //       getmessages();
                        //     } else {
                        //       setState(() {
                        //         sending = false;
                        //       });
                        //       print(' here == 2');
                        //     }
                        //   });
                        // } else if (image != null &&
                        //     messageController.text.isNotEmpty) {
                        //   setState(() {
                        //     sending = true;
                        //   });

                        //   await p2pSendMessage(
                        //           matchID: widget.orderId.toString(),
                        //           message: messageController.text,
                        //           image: image)
                        //       .then((result) {
                        //     if (result) {
                        //       p2pSendMessage(
                        //               matchID: widget.orderId.toString(),
                        //               message: messageController.text)
                        //           .then((value) {
                        //         if (value) {
                        //           setState(() {
                        //             sending = false;
                        //             image = null;
                        //             messageController.clear();
                        //             FocusManager.instance.primaryFocus
                        //                 ?.unfocus();
                        //           });

                        //           getmessages();
                        //         } else {
                        //           print(' here == 1');
                        //           setState(() {
                        //             sending = false;
                        //           });
                        //         }
                        //       });
                        //     } else {
                        //       setState(() {
                        //         sending = false;
                        //       });
                        //       print(' here == 2');
                        //     }
                        //   });
                        // } else if (image == null &&
                        //     messageController.text.isNotEmpty) {
                        //   setState(() {
                        //     sending = true;
                        //   });
                        //   p2pSendMessage(
                        //     matchID: widget.orderId.toString(),
                        //     message: messageController.text,
                        //   ).then((value) {
                        //     if (value) {
                        //       setState(() {
                        //         sending = false;
                        //         image = null;
                        //         messageController.clear();
                        //         FocusManager.instance.primaryFocus?.unfocus();
                        //       });

                        //       getmessages();
                        //     } else {
                        //       setState(() {
                        //         sending = false;
                        //       });
                        //     }
                        //   });
                        // } else {}
                      },
                      icon: Icon(
                        Icons.send,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      body: 
      loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          :
           Column(
              children: [
                Container(
                  color: ColorCollection.backColor,
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 1,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Text(
                              '${orderData['receiver_user']['name'] == null ? '' : orderData['receiver_user']['name'][0]}'
                                  .toUpperCase(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11.5),
                            ),
                          ),
                          SizedBox(
                            width: 1.5,
                          ),
                          Column(
                            children: [
                              Text(
                                '${orderData['receiver_user']['name'] == null ? '' : ''}'
                                    .toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 3.5,
                          ),
                          Text(
                            orderData['receiver_user']['user_verify']
                                ? 'Verified User'
                                : 'Unverified User',
                            style: TextStyle(
                                color: ColorCollection.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(left: 18),
                      //   child: Row(
                      //     children: [
                      //       Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Text(
                      //             '30d Trades',
                      //             style: TextStyle(
                      //               color: Colors.white,
                      //             ),
                      //           ),
                      //           Text(
                      //             '451',
                      //             style: TextStyle(
                      //               color: Colors.white,
                      //               fontWeight: FontWeight.w700,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         width: 18,
                      //       ),
                      //       Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Text(
                      //             '30d Completion Rate',
                      //             style: TextStyle(
                      //               color: Colors.white,
                      //             ),
                      //           ),
                      //           Text(
                      //             '90.93%',
                      //             style: TextStyle(
                      //               color: Colors.white,
                      //               fontWeight: FontWeight.w700,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      SizedBox(
                        height: 2,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  height: 2,
                ),
                Flexible(
                    child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < messagesList.length; i++)
                        userID == messagesList[i]['sender_id']
                            ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      children: [
                                        if (messagesList[i]['image'] != null)
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                CommanClass.FileURL =
                                                    'https://dnode.avxglobal.io/chatImages/${messagesList[i]['image']}';
                                              });
                                              showGeneralDialog(
                                                  barrierColor: Colors.black
                                                      .withOpacity(0.5),
                                                  transitionBuilder: (context,
                                                      a1, a2, widget) {
                                                    return Transform.scale(
                                                      scale: a1.value,
                                                      child: Opacity(
                                                        opacity: a1.value,
                                                        child:
                                                            PreviewDialogBox(),
                                                      ),
                                                    );
                                                  },
                                                  transitionDuration: Duration(
                                                      milliseconds: 100),
                                                  context: context,
                                                  pageBuilder: (context,
                                                      animation1, animation2) {
                                                    return SizedBox();
                                                  });
                                            },
                                            child: Image.network(
                                              'https://dnode.avxglobal.io/chatImages/${messagesList[i]['image']}',
                                              fit: BoxFit.fill,
                                              height: 30,
                                              width: 30,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  SizedBox(
                                                child: Text('Image Not Found'),
                                              ),
                                            ),
                                          ),
                                        if (messagesList[i]['message'] != null)
                                          Bubble(
                                            stick: true,
                                            margin: BubbleEdges.only(bottom: 2),
                                            padding: BubbleEdges.symmetric(
                                                horizontal: 4, vertical: 1),
                                            nip: BubbleNip.rightTop,
                                            color: light
                                                ? Colors.white
                                                : ColorCollection.backColor,
                                            radius: Radius.circular(10),
                                            nipWidth: 15,
                                            child: SizedBox(
                                                width: 52,
                                                child: Text(
                                                    messagesList[i]
                                                                ['message'] ==
                                                            'customMsg'
                                                        ? 'Confirm Payment by you please wait for seller confilrmation'
                                                        : messagesList[i]
                                                            ['message'],
                                                    textAlign: TextAlign.left)),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        if (messagesList[i]['image'] != null)
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                CommanClass.FileURL =
                                                    'https://dnode.avxglobal.io/chatImages/${messagesList[i]['image']}';
                                              });
                                              showGeneralDialog(
                                                  barrierColor: Colors.black
                                                      .withOpacity(0.5),
                                                  transitionBuilder: (context,
                                                      a1, a2, widget) {
                                                    return Transform.scale(
                                                      scale: a1.value,
                                                      child: Opacity(
                                                        opacity: a1.value,
                                                        child:
                                                            PreviewDialogBox(),
                                                      ),
                                                    );
                                                  },
                                                  transitionDuration: Duration(
                                                      milliseconds: 100),
                                                  context: context,
                                                  pageBuilder: (context,
                                                      animation1, animation2) {
                                                    return SizedBox();
                                                  });
                                            },
                                            child: Image.network(
                                              'https://dnode.avxglobal.io/chatImages/${messagesList[i]['image']}',
                                              fit: BoxFit.fill,
                                              height: 30,
                                              width: 30,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  SizedBox(
                                                child: Text('Image Not Found'),
                                              ),
                                            ),
                                          ),
                                        if (messagesList[i]['message'] != null)
                                          Bubble(
                                            stick: true,
                                            margin: BubbleEdges.only(bottom: 2),
                                            padding: BubbleEdges.symmetric(
                                                horizontal: 4, vertical: 1),
                                            color: light
                                                ? Color(0xFFFBF5E5)
                                                : Color(0xFF1E1808),
                                            nip: BubbleNip.leftBottom,
                                            radius: Radius.circular(10),
                                            nipWidth: 15,
                                            child: SizedBox(
                                              width: 52,
                                              child: Text(
                                                  messagesList[i]['message'] ==
                                                          'customMsg'
                                                      ? 'Confirm Payment by you please wait for seller confilrmation'
                                                      : messagesList[i]
                                                          ['message'],
                                                  textAlign: TextAlign.left),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                )),
                // Container(
                //   margin: EdgeInsets.symmetric(horizontal: 5),
                //   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                //   decoration: kYellowContainerDeco.copyWith(
                //       color: light ? AppColors.white : null),
                //   child: Text(
                //       'The Order Has Been Cancelled. Please Contact Customer Support If You Have Any Questions'),
                // ),
                SizedBox(
                  height: image == null ? 10 : 14,
                ),
              ],
            ),
    );
  }
}
