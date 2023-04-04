import hashlib
s = input('Enter string to hash:')
print(hashlib.sha256(s.encode('utf-8')).hexdigest())
