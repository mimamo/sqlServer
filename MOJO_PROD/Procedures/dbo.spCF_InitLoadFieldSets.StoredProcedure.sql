USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_InitLoadFieldSets]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCF_InitLoadFieldSets]

	@CompanyKey int

AS

/*
|| When       Who Rel      What
|| 05/20/2014 MFT 10.5.7.9 (216955) Removed fs.Active=1 condition
*/
	select fs.FieldSetKey
		  ,fs.OwnerEntityKey as FSOwnerEntityKey
		  ,fs.AssociatedEntity as FSAssociatedEntity
	      ,fd.*
	      ,fsf.DisplayOrder
	from tFieldDef fd (nolock) 
	inner join tFieldSetField fsf (nolock) on fd.FieldDefKey = fsf.FieldDefKey
	inner join tFieldSet fs (nolock) on fsf.FieldSetKey = fs.FieldSetKey 
	where fd.OwnerEntityKey = @CompanyKey
	--and fs.Active = 1
	and fd.Active = 1
	order by fsf.FieldSetKey, fsf.DisplayOrder 
	
	
	return 1
GO
