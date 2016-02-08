package gui.login;

import core.exceptions.LoginException;
import gui.Main;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;

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
        imageState.setImage(new Image(getClass().getResourceAsStream("./login_64x64.png")));
        imageState.resize(64,64);

    }

    @FXML // fire this event when user clicks Login Button
    private void btnLoginOnAction(){
        try{
            boolean result = userControl.login(txtUserName.getText(), txtPassword.getText());
            if(result){
                // open main window
                showMainScene();
            }
        }
        catch (LoginException ex){
            if(ex.getExType() == LoginException.ExType.INVALID_ID_PASS){
                //error image
                imageState.setImage(new Image(getClass().getResourceAsStream("error_64x64.png")));
            }
            else
                ex.printStackTrace();
        }
        catch (Exception ex){

        }
    }
}