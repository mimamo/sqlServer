USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_GetDocData]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCF_GetDocData]
	
AS

/*
|| When      Who Rel     What
|| 07/30/10  MFT 10.533  Added tFieldSet and FieldSetName
*/
	
    --create table #tCFEntityData
    --(
    --  EntityKey int null
    --, OwnerEntityKey int null
    --, ObjectFieldSetKey int null
    --)
	
select
	 ed.EntityKey
	,ed.OwnerEntityKey
	,ed.ObjectFieldSetKey
	,ofs.FieldSetKey
	,fv.FieldDefKey
	,fv.FieldValue
	,fs.FieldSetName
from #tCFEntityData ed
inner join tObjectFieldSet ofs (nolock) on ed.ObjectFieldSetKey = ofs.ObjectFieldSetKey
inner join tFieldValue fv (nolock) on ofs.ObjectFieldSetKey = fv.ObjectFieldSetKey
inner join tFieldSet fs (nolock) on ofs.FieldSetKey = fs.FieldSetKey

return 1
GO
