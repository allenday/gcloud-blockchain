#!/bin/bash

USER=$1
PASS=$2
BEGIN=$3
END=$4

echo "
SELECT
	b.block_version AS block_version,
	FROM_UNIXTIME(block_nTime) AS block_time,
	b.block_height AS block_height,
	HEX(b.block_hash) AS block_hash,
	t.tx_version AS tx_version,
	HEX(t.tx_hash) AS tx_hash,
	id.i_pos, id.i_pubkey_hash, id.i_value,
	od.o_pos, od.o_pubkey_hash, od.o_value
FROM
	(SELECT
		id.tx_id,
		GROUP_CONCAT(DISTINCT id.txin_pos ORDER BY txin_pos) AS i_pos,
		GROUP_CONCAT(DISTINCT HEX(id.pubkey_hash) ORDER BY txin_pos) AS i_pubkey_hash,
		GROUP_CONCAT(DISTINCT id.txin_value ORDER BY txin_pos) AS i_value
	FROM
		block_tx AS bt,
		txin_detail AS id
	WHERE
		id.tx_id = bt.tx_id AND
		bt.block_id IN (SELECT block_id FROM block WHERE block_nTime >= UNIX_TIMESTAMP('${BEGIN}') AND block_nTime < UNIX_TIMESTAMP('${END}'))
	GROUP BY
		tx_id
	HAVING
		i_value IS NOT NULL
	) AS id,
	(SELECT
		od.tx_id,
		GROUP_CONCAT(DISTINCT od.txout_pos ORDER BY txout_pos) AS o_pos,
		GROUP_CONCAT(DISTINCT HEX(od.pubkey_hash) ORDER BY txout_pos) AS o_pubkey_hash,
		GROUP_CONCAT(od.txout_value ORDER BY txout_pos) AS o_value
	FROM
		block_tx AS bt,
		txout_detail AS od
	WHERE
		od.tx_id = bt.tx_id AND
		bt.block_id IN (SELECT block_id FROM block WHERE block_nTime >= UNIX_TIMESTAMP('${BEGIN}') AND block_nTime < UNIX_TIMESTAMP('${END}'))
	GROUP BY
		tx_id
	HAVING
		o_value IS NOT NULL
	) AS od,
	tx AS t,
	block AS b,
	block_tx AS bt
WHERE
	b.block_id = bt.block_id AND
	t.tx_id = bt.tx_id AND
	t.tx_id = id.tx_id AND
	t.tx_id = od.tx_id
;
" | mysql -h 35.227.51.92 -u $USER -p$PASS abe

