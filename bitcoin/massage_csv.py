import sys
import base58
import Crypto.Hash.SHA256 as SHA256

def hash_to_address(version, hash):
    vh = version + hash
    return base58.b58encode(vh + double_sha256(vh)[:4])

def sha256(s):
    return SHA256.new(s).digest()

def double_sha256(s):
    return sha256(sha256(s))

#hash = '11b366edfc0a8b66feebae5c2e25a7b6a5d1cf31'
#print hash_to_address("00".decode('hex'), hash.decode('hex'))

print next(sys.stdin).rstrip()
for line in sys.stdin:
    fields = line.rstrip().split("\t")

    fields[6] = '['+fields[6]+']'
    fields[9] = '['+fields[9]+']'

    fields[8] = '['+fields[8]+']'
    fields[11] = '['+fields[11]+']'

    ihash = fields[7].split(",")
    iaddr = map(lambda i: '"'+hash_to_address('00'.decode('hex'), i.decode('hex'))+'"', ihash)
    fields[7] = '['+(','.join(iaddr))+']'
    #print '['+(','.join(iaddr))+']'

    ohash = fields[10].split(",")
    oaddr = map(lambda i: '"'+hash_to_address('00'.decode('hex'), i.decode('hex'))+'"', ohash)
    fields[10] = '['+(','.join(oaddr))+']'

    print '{"block_version":'+fields[0]+',"block_time":"'+fields[1]+',"block_height":'+fields[2]+',"block_hash":"'+fields[3]+'"'+',"tx_version":'+fields[4]+',"tx_hash":"'+fields[5]+'"'+',"i_pos":'+fields[6]+',"i_pubkey_hash":'+fields[7]+',"i_value":'+fields[8]+',"o_pos":'+fields[9]+',"o_pubkey_hash":'+fields[10]+',"o_value":'+fields[11]+'}'

