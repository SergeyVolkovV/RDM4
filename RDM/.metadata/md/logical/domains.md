<?xml version='1.0' encoding='UTF-8'?>
<domains>
	<domain elemId="26557828" regexp="" min="" validationMsg="" size="255" max="" rowsCount="" fkTable="" format="" name="string" type="STRING"/>
	<domain elemId="26557829" regexp="" min="" validationMsg="" size="" max="" rowsCount="" fkTable="" format="" name="datetime" type="DATETIME"/>
	<domain elemId="26690377" regexp="" min="" validationMsg="" size="" max="" rowsCount="" fkTable="" format="" name="integer" type="INTEGER"/>
	<domain elemId="26557830" regexp="" min="" validationMsg="" size="" max="" rowsCount="" fkTable="" format="0#" name="integer2" type="INTEGER"/>
	<domain elemId="26557831" regexp="" min="" validationMsg="" size="" max="" rowsCount="" fkTable="" format="" name="long" type="LONG"/>
	<domain elemId="26557833" regexp="" min="" validationMsg="" size="" max="" rowsCount="" fkTable="" format="" name="float" type="FLOAT"/>
	<domain elemId="26557832" regexp="" min="" validationMsg="" size="" max="" rowsCount="" fkTable="" format="" name="boolean" type="BOOLEAN"/>
	<domain elemId="26557834" regexp="^[A-Z]{3}$" min="" validationMsg="Char-3 country code incorrect format." size="" max="" rowsCount="" fkTable="" format="" name="iso_c3_country" type="STRING"/>
	<domain elemId="26557835" regexp="^[A-Z]{2}$" min="" validationMsg="Char-2 country code incorrect format." size="" max="" rowsCount="" fkTable="" format="" name="iso_c2_country" type="STRING"/>
	<domain elemId="26557839" regexp="[NAP]" min="" validationMsg="Invalid flag. (e.g. N, A or P)" size="1" max="" rowsCount="" fkTable="" format="" name="dwh_flag" type="STRING"/>
	<domain elemId="26775972" regexp=".{2,7}" min="" validationMsg="Code must contain between 2 and 7 characters." size="" max="" rowsCount="" fkTable="" format="" name="code7" type="STRING"/>
	<domain elemId="26768255" regexp=".{2}_.{2}\|.{2,7}" min="" validationMsg="GUID must conform to the following format: (2 characters)_(2 characters)|productCode. Please, use the enrich option for generating a valid GUID based on table ID and code." size="" max="" rowsCount="" fkTable="" format="" name="guid" type="STRING"/>
	<domain elemId="26557838" regexp="^(((\(\d{2,3}\) )|\d{2,3}[ -])\d{3}[ -]\d{4})$" min="" validationMsg="Invalid phone number. (e.g. (xxx) xxx-xxxx)" size="" max="" rowsCount="" fkTable="" format="" name="phone_number" type="STRING"/>
	<domain elemId="26698752" regexp="^[^\s]*@example.ca" min="" validationMsg="Work e-mail must be on example.ca domain and it cannot contain a white space" size="" max="" rowsCount="" fkTable="" format="" name="mail_example" type="STRING"/>
	<domain elemId="26906928" regexp="\d{1,3}°\d{1,2}&#39;\d{1,2}(\.\d+)?\&quot;[N|S|W|E]\s\d{1,3}°\d{1,2}&#39;\d{1,2}(\.\d+)?\&quot;[N|S|W|E]" min="" validationMsg="Invalid format. Please, follow this example: 12°34&#39;56.789&quot;N 12°34&#39;56.789&quot;W" size="" max="" rowsCount="" fkTable="" format="" name="gps" type="STRING"/>
	<domain elemId="26557836" regexp="" min="" validationMsg="" size="" max="" rowsCount="" fkTable="PRODUCT_GROUP" format="" name="prod_groups" type="MNREFERENCES"/>
	<domain elemId="26557837" regexp="" min="" validationMsg="" size="" max="" rowsCount="" fkTable="PERSON" format="" name="sales_reps" type="MNREFERENCES"/>
</domains>