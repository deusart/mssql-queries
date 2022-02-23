/*
	Updated based on comments:

    NEWID generates random string (for each row in return)
    CHECKSUM takes value of string and creates number
    modulus (%) divides by that number and returns the remainder (meaning max value is one less than the number you use)
    ABS changes negative results to positive
    then add one to the result to eliminate 0 results (to simulate a dice roll)

*/
-- random value
SELECT ABS(CHECKSUM(NEWID()))
-- random value from 0 to 9
SELECT ABS(CHECKSUM(NEWID()) % 10)
-- random value from 1 to 6
SELECT ABS(CHECKSUM(NEWID()) % 6) + 1
-- random value from 3 to 6
SELECT ABS(CHECKSUM(NEWID()) % 4) + 3
-- random value from 3 to 6
SELECT 3 + CRYPT_GEN_RANDOM(1) % 4

