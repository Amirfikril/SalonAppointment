#!/bin/bash

#PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
PSQL="psql --username=postgres --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo "Welcome to My Salon, how can I help you?"
MAIN_MENU()
{  
    #to return error
    if [[ $1 ]]
    then
    echo "$1"
    fi

   #list of services
   echo "$($PSQL "SELECT service_id, name FROM services")" | while read SERVICE_ID BAR SERVICE_NAME;
   do
     echo "$SERVICE_ID) $SERVICE_NAME"
   done
   
   #Check for services
   read  SERVICE_ID_SELECTED
   SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
   if [[ -z $SERVICE_ID ]]
   then
     echo -e 
     MAIN_MENU "I could not find that service. What would you like today?" 
   fi
   SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID'")
}
MAIN_MENU
   #check phone number
   echo -e "\nWhat's your phone number?"
   read CUSTOMER_PHONE
   CUSTOMER_ID=$($PSQL "SELECT customer_id from customers where phone='$CUSTOMER_PHONE'")
   if [[ -z $CUSTOMER_ID ]]
   then
     echo -e "\nI don't have a record for that phone number, what's your name?" 
     read CUSTOMER_NAME
     #insert new customer
     INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')" )
   else
     CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
   fi
   #new customer_id
   CUSTOMER_ID=$($PSQL "SELECT customer_id from customers where phone='$CUSTOMER_PHONE'")

   #service schedule
   echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
   read SERVICE_TIME

   #insert data in appointment
   INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ('$CUSTOMER_ID', '$SERVICE_ID', '$SERVICE_TIME')")
   echo -e "\nI have put you down for a cut at $SERVICE_TIME, $CUSTOMER_NAME."

