USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_tFieldSetGetEntityList]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spCF_tFieldSetGetEntityList]

 @AssociatedEntity varchar(50)
 
AS --Encrypt


	select 
		 FieldSetKey
		,OwnerEntityKey
	from tFieldSet (nolock)
	where AssociatedEntity = @AssociatedEntity
	and Active = 1
	
 return 1
GO
