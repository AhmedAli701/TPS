package gui;

import core.Authorization;
import core.exceptions.LoginException;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.ResourceBundle;
import javafx.scene.control.TextField;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;

public class LoginController extends Main implements Initializable {

    @FXML private TextField txtUserName;
    @FXML private TextField txtPassword;
    @FXML private ImageView imageState;

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        //empty for now
        imageState.setImage(new Image(getClass().getResourceAsStream("images/login_64x64.png")));
        imageState.resize(64,64);

    }

    @FXML
    private void btnLoginOnAction(){
        try{
            boolean result = userControl.login(txtUserName.getText(), txtPassword.getText());
            if(result){
                System.out.println("logged");
            }
        }
        catch (LoginException ex){
            if(ex.getExType() == LoginException.ExType.INVALID_ID_PASS){
                // open alert
                // temp msg
                System.out.println("invalid id & pass");
            }
            else
                ex.printStackTrace();
        }
    }
}
