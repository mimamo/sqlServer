USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_tFieldSetGetEntityValues]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spCF_tFieldSetGetEntityValues]


as --Encrypt


--CREATE TABLE #tCFEntityCFKeys (EntityKey int NULL, OwnerEntityKey NULL, ObjectFieldSetKey NULL)


	select 
		 wrk.*
		,ofs.FieldSetKey
		,fv.FieldDefKey
		,fv.FieldValue
	from 
		#tCFEntityCFKeys wrk 
		inner join tObjectFieldSet ofs (nolock) on wrk.ObjectFieldSetKey = ofs.ObjectFieldSetKey
		inner join tFieldSet fs (nolock) on ofs.FieldSetKey = fs.FieldSetKey
		inner join tFieldSetField fsf (nolock) on fs.FieldSetKey = fsf.FieldSetKey
		inner join tFieldDef fd (nolock) on fsf.FieldDefKey = fd.FieldDefKey
		inner join tFieldValue fv (nolock) on fd.FieldDefKey = fv.FieldDefKey
	where 
		ofs.ObjectFieldSetKey = fv.ObjectFieldSetKey
	and fd.Active = 1
	order by
		 wrk.ObjectFieldSetKey
		,fsf.DisplayOrder
GO
