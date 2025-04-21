import hashlib
import binascii

def pbkdf2_sha1(password, ssid, iterations=4096):
    """
    PBKDF2-SHA1 algorithm to hash the password with the provided SSID.
    
    :param password: The password to hash
    :param ssid: The SSID (network identifier) used as the salt
    :param iterations: The number of iterations for PBKDF2 (default is 4096)
    :return: The hashed password in hexadecimal format
    """
    password = password.encode('utf-8')  # Encode password to bytes
    ssid = ssid.encode('utf-8')  # Encode SSID to bytes
    
    # Use PBKDF2-HMAC-SHA1 to generate the derived key
    dk = hashlib.pbkdf2_hmac('sha1', password, ssid, iterations, dklen=32)
    
    # Return the hashed password as a hexadecimal string
    return binascii.hexlify(dk).decode('utf-8')


def hash_passwords_from_file(input_file, ssid, output_file):
    """
    Hash passwords from the input file using the pbkdf2_sha1 algorithm 
    and write the hashed passwords to the output file.
    
    :param input_file: Path to the input file containing passwords
    :param ssid: The SSID (network identifier) used as the salt
    :param output_file: Path to the output file where hashed passwords will be saved
    """
    # Open input file for reading and output file for writing
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        for line in infile:
            password = line.strip()  # Read password from file and remove any extra whitespace
            hashed_password = pbkdf2_sha1(password, ssid)  # Hash the password with the SSID
            outfile.write(hashed_password + '\n')  # Write the hashed password to output file
            
    print(f"Hashed passwords have been written to {output_file}")

# Example usage
input_file = 'rockyou.txt'  # Input file containing passwords
ssid = 'SSID'  # SSID used as the salt for hashing
output_file = 'rockyou_hashed.txt'  # Output file to save hashed passwords

# Call the function to hash the passwords from the file
hash_passwords_from_file(input_file, ssid, output_file)
