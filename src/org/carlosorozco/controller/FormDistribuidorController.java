/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.carlosorozco.controller;

import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ResourceBundle;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.ButtonType;
import javafx.scene.control.TextField;
import org.carlosorozco.dao.Conexion;
import org.carlosorozco.dto.DistribuidorDTO;
import org.carlosorozco.model.Distribuidor;
import org.carlosorozco.system.Main;
import org.carlosorozco.utils.SuperKinalAlert;

public class FormDistribuidorController implements Initializable {
    private Main stage;
    
    private int op;
    
    private static Connection conexion = null;
    private static PreparedStatement statement = null;
    
    @FXML
    TextField tfDistribuidorId, tfNombre, tfTelefono, tfNit, tfDireccion, tfWeb;
    
    @FXML
    Button btnGuardar, btnCancelar;
    
    @FXML
    public void handleButtonAction(ActionEvent event){
        if(event.getSource() == btnCancelar){
            stage.menuDistribuidorView();
            DistribuidorDTO.getDistribuidorDTO().setDistribuidor(null);
        }else if(event.getSource() == btnGuardar){
            if(op == 1){
                if(!tfNombre.getText().equals("") && !tfTelefono.getText().equals("") && !tfNit.getText().equals("") && !tfDireccion.getText().equals("") && !tfWeb.getText().equals("")){
                    agregarDistribuidor();
                    SuperKinalAlert.getInstance().mostrarAlertaInformacion(400);
                    stage.menuDistribuidorView();
                }else{
                    SuperKinalAlert.getInstance().mostrarAlertaInformacion(600);
                    tfNombre.requestFocus();
                }
            }else if(op == 2){
                if(!tfNombre.getText().equals("") && !tfTelefono.getText().equals("") && !tfNit.getText().equals("") && !tfDireccion.getText().equals("") && !tfWeb.getText().equals("")){
                    if(SuperKinalAlert.getInstance().mostrarAlertaConfirmacion(505).get() == ButtonType.OK){
                        editarDistribuidor();
                        DistribuidorDTO.getDistribuidorDTO().setDistribuidor(null);
                        SuperKinalAlert.getInstance().mostrarAlertaInformacion(500);
                        stage.menuDistribuidorView();
                    }else{
                        stage.menuDistribuidorView();
                    }
                }else{
                    SuperKinalAlert.getInstance().mostrarAlertaInformacion(600);
                    tfNombre.requestFocus();
                }
            }
        }
    }
    
    @Override
    public void initialize(URL location, ResourceBundle resources) {
        if(DistribuidorDTO.getDistribuidorDTO().getDistribuidor() != null){
            cargarDatos(DistribuidorDTO.getDistribuidorDTO().getDistribuidor());
        }
    }
    
    public void cargarDatos(Distribuidor distribuidor){
        tfDistribuidorId.setText(Integer.toString(distribuidor.getDistribuidorId()));
        tfNombre.setText(distribuidor.getNombreDistribuidor());
        tfTelefono.setText(distribuidor.getTelefonoDistribuidor());
        tfNit.setText(distribuidor.getNitDistribuidor());
        tfDireccion.setText(distribuidor.getDireccionDistribuidor());
        tfWeb.setText(distribuidor.getWeb());
    }
    
    public void agregarDistribuidor(){
        try{
            conexion = Conexion.getInstance().obtenerConexion();
            String sql = "call sp_agregarDistribuidor(?, ?, ?, ?, ?)";
            statement = conexion.prepareStatement(sql);
            statement.setString(1, tfNombre.getText());
            statement.setString(2, tfTelefono.getText());
            statement.setString(3, tfNit.getText());
            statement.setString(4, tfDireccion.getText());
            statement.setString(5, tfWeb.getText());
            statement.execute();
        }catch(SQLException e){
            System.out.println(e.getMessage());
        }finally{
            try{
                if(statement != null){
                    statement.close();
                }
                if(conexion != null){
                    conexion.close();
                }
            }catch(SQLException e){
                System.out.println(e.getMessage());
            }
        }
    }
    
    public void editarDistribuidor(){
        try{
            conexion = Conexion.getInstance().obtenerConexion();
            String sql = "call sp_editarDistribuidor(?, ?, ?, ?, ?, ?)";
            statement = conexion.prepareCall(sql);
            statement.setInt(1, Integer.parseInt(tfDistribuidorId.getText()));
            statement.setString(2, tfNombre.getText());
            statement.setString(3, tfTelefono.getText());
            statement.setString(4, tfNit.getText());
            statement.setString(5, tfDireccion.getText());
            statement.setString(6, tfWeb.getText());
            statement.execute();
        }catch(SQLException e){
            System.out.println(e.getMessage());
        }finally{
            try{
                if(statement != null){
                    statement.close();
                }
                if(conexion != null){
                    conexion.close();
                }
            }catch(SQLException e){
                System.out.println(e.getMessage());
            }
        }
    }

    public Main getStage() {
        return stage;
    }

    public void setStage(Main stage) {
        this.stage = stage;
    }

    public void setOp(int op) {
        this.op = op;
    }
    
}