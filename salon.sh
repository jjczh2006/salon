#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {

  echo "Welcome to My Salon, how can I help you?" 
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) MAKE_APPOINT $SERVICE_ID_SELECTED ;;
    2) MAKE_APPOINT $SERVICE_ID_SELECTED ;;
    3) MAKE_APPOINT $SERVICE_ID_SELECTED ;;
    4) MAKE_APPOINT $SERVICE_ID_SELECTED ;;
    5) MAKE_APPOINT $SERVICE_ID_SELECTED ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

#Your script should prompt users to enter a service_id, phone number, a name if they aren’t already a customer, and a time. 
#You should use read to read these inputs into variables named SERVICE_ID_SELECTED, CUSTOMER_PHONE, CUSTOMER_NAME, and SERVICE_TIME
MAKE_APPOINT() {
  SERVICE_ID_SELECTED=$1
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  #What's your phone number?
  #555-555-5555
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  # if customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get new customer name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    # insert new customer
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
  fi
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name = '$CUSTOMER_NAME'")
  
  #I don't have a record for that phone number, what's your name?
  #Fabio

  #What time would you like your cut, Fabio?
  #10:30
  echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
  read SERVICE_TIME
  #I have put you down for a cut at 10:30, Fabio.
  MAKE_APPOINT_RESULT=$($PSQL "insert into appointments(customer_id,service_id,time) values('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")
  echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

}

MAIN_MENU