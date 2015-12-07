Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [spCF_tFieldValueSetDefaults]

	 @CustomFieldKey int
	 
AS --Encrypt

insert tFieldValue
(
 FieldValueKey
,FieldDefKey
,ObjectFieldSetKey
,FieldValue
)

select newid()
	  ,def.FieldDefKey
	  ,@CustomFieldKey
	  ,'NO'
from tFieldDef def (nolock) inner join tFieldSetField fset (nolock) on def.FieldDefKey = fset.FieldDefKey
inner join tObjectFieldSet objfs (nolock) on fset.FieldSetKey = objfs.FieldSetKey
where objfs.ObjectFieldSetKey = @CustomFieldKey
and def.DisplayType = 9
and def.FieldDefKey not in 
(
select fd.FieldDefKey
from tObjectFieldSet ofs (nolock) inner join tFieldSet fs (nolock) on ofs.FieldSetKey = fs.FieldSetKey
inner join tFieldSetField fsf (nolock) on fs.FieldSetKey = fsf.FieldSetKey
inner join tFieldDef fd (nolock) on fsf.FieldDefKey = fd.FieldDefKey
inner join tFieldValue fv (nolock) on fd.FieldDefKey = fv.FieldDefKey
where ofs.ObjectFieldSetKey = @CustomFieldKey
and fv.ObjectFieldSetKey = @CustomFieldKey
and isnull(fs.Active, 0) = 1
and fd.DisplayType = 9
)
