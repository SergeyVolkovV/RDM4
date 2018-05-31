<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="*">
	
<physicalAdjustments>
	<afterTableCreationCommands>
		<cmd>
			<tableNameRegex>.*</tableNameRegex>
			<command>
				<sql>
	begin
  dbms_stats.set_table_stats
    (
      ownname       =>'REF',
      tabname       => upper('$tableName$'), 
      numrows      => 200000
    );
    for i in (select index_name from user_indexes where table_name = '$tableName$') loop
  dbms_stats.set_index_stats
    (
      ownname       =>'REF',
      indname       => i.index_name, 
      numrows      => 200000
    );    
    end loop;
    DBMS_STATS.LOCK_TABLE_STATS(  
      ownname       =>'REF',
      tabname       => upper('$tableName$'));
    end;
    			</sql>
			</command>
		</cmd>
	</afterTableCreationCommands>
</physicalAdjustments>

</xsl:template>
</xsl:stylesheet>	
