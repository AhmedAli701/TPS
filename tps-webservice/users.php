<?php
    include 'connection.php';

    // call the passes in function 
    if($_POST['method'] === "login"){
        login($_POST['json']);
    }
    
    function login($json){
        global $mysqli;
        
        $params = json_decode($json); 
        $uName = $params->{'uName'};
        $uPass = $params->{'uPass'};
        
        // check if user exist 
        $strQuery = sprintf("SELECT `Name`, `Title`, `Auth`, `LastEdit`, `LastLogged`, `SecKey`
                                FROM Users WHERE (Name = '%s' AND Password = '%s')", $uName, $uPass);
                            
        $result = $mysqli->query($strQuery);
        
        if($result->num_rows > 0){
            $row = $result->fetch_assoc();
            $row["SecKey"] = rand();
            
            // add key to db 
            $insQuery = sprintf("UPDATE Users SET SecKey='%s' WHERE (Name='%s')", $row["SecKey"], $row["Name"]);
            $mysqli->query($insQuery);
            echo json_encode($row);
        }
    }
    
    mysqli_close($mysqli);

            //while($row = $result->fetch_assoc()){
              //  echo $row["Name"];
            //}
?>