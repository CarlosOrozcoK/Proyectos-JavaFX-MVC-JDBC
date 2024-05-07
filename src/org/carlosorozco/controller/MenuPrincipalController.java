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
    MenuItem btnClientes, btnTicketSoporte;
    
    @FXML
    public void handleButtonAction(ActionEvent event) throws Exception{
        if(event.getSource() == btnClientes){
            stage.menuClienteView();
        } else if(event.getSource() == btnTicketSoporte){
            stage.menuTicketSoporteView();
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