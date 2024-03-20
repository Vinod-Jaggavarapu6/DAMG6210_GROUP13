SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE create_sequence(seqName IN VARCHAR2, startWith IN NUMBER) AS
BEGIN
   -- Check if sequence exists
   FOR seq IN (SELECT sequence_name FROM all_sequences WHERE sequence_name = seqName) LOOP
      -- If sequence exists, return without creating it
      dbms_output.put_line('Sequence : ' || seqName || ' already exists');
      RETURN;
   END LOOP;

   -- Create sequence if it doesn't exist
   dbms_output.put_line('Creating the Sequence: ' || seqName);
   EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || seqName || ' INCREMENT BY 1 START WITH ' || startWith;
EXCEPTION
   WHEN OTHERS THEN
      dbms_output.put_line('Exception Occurred');
      dbms_output.put_line('Error Message: ' || SQLERRM);
END create_sequence;
/

BEGIN
   create_sequence('Customer_ID_SEQ', 1);
   create_sequence('Location_ID_SEQ', 1);
   create_sequence('Warehouse_Type_ID_SEQ', 1);
   create_sequence('Owner_ID_SEQ', 1);
   create_sequence('Warehouse_ID_SEQ', 1);
   create_sequence('Employee_ID_SEQ', 1);
   create_sequence('Service_Request_ID_SEQ', 1);
   create_sequence('Payment_ID_SEQ', 1);
   create_sequence('Lease_Unit_ID_SEQ', 1);
   create_sequence('Lease_ID_SEQ', 1);
   create_sequence('Unit_ID_SEQ', 1);
   COMMIT;
END;
/
