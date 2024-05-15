package org.carlosorozco.controller;

import java.net.URL;
import java.util.ResourceBundle;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.MenuItem;
import org.carlosorozco.system.Main;


public class MenuPrincipalController implements Initializable {
    private Main stage;
    @FXML
    MenuItem btnClientes, btnTickets, btnCargos, btnCompras, btnDistribuidores, btnCategoriaProducto, btnEmpleados;
    
    @FXML
    public void handleButtonAction(ActionEvent event) throws Exception{
        if(event.getSource() == btnClientes){
            stage.menuClienteView();
        } else if(event.getSource() == btnTickets){
            stage.menuTicketSoporteView();
        }else if(event.getSource() == btnCargos){
            stage.menuCargoView();
        }else if(event.getSource() == btnCompras){
            stage.menuCompraView();
        }else if(event.getSource() == btnDistribuidores){
            stage.menuDistribuidorView();
        }else if(event.getSource() == btnCategoriaProducto){
            stage.menuCategoriaProductoView();
        }else if(event.getSource() == btnEmpleados){
            stage.menuEmpleadoView();
        }
    }
    
    @Override
    public void initialize(URL location, ResourceBundle resources){
    
    }

    public Main getStage() {
        return stage;
    }

    public void setStage(Main stage) {
        this.stage = stage;
    }
    
    
}
