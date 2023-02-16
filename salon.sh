
echo -e "\n~~~~~ MY SALON ~~~~~\n"

PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

MAIN_MENU(){

  if [[ $1 ]]
  then
     echo -e "\n$1"
  fi
  echo -e "\nWelcome to My Salon, how can I help you?"

  echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim\n6) exit"
  read SERVICE_ID_SELECTED

}



APPOINTMENT_MENU(){
  # Get service id from selected menu
  SERVICE_ID_SELECTED=$($PSQL "SELECT service_id FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")

  # if not found
  if [[ -z $SERVICE_ID_SELECTED ]]
  then
  # send to main menu
    MAIN_MENU "I could not find that service. What would you like today?"
  else
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE

    # look for customer using phone number
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    # if not found
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME

      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    fi

    # get name from selected menu serive
    SELECTED_MENU_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")

    echo -e "\nWhat time would you like your $SELECTED_MENU_SERVICE, $CUSTOMER_NAME?"
    read SERVICE_TIME

    # get customer id
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")

   
     echo "I have put you down for a $SELECTED_MENU_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
    
  fi
  
}

EXIT(){
  echo -e "\nYou really don't want to groom?. Okay, bye bye!\n"
}

MAIN_MENU

case $SERVICE_ID_SELECTED in
  1 | 2 |3 | 4 | 5 ) APPOINTMENT_MENU ;;
  6) EXIT ;;
  *) MAIN_MENU "I could not find that service. What would you like today?" ;;
esac
