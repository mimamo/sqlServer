USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSecurityAccessDeleteEntity]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptSecurityAccessDeleteEntity]

   @CompanyKey int
  ,@Entity varchar(50)
  ,@EntityKey int 
    
AS --Encrypt
 	
	delete tSecurityAccess
	 where CompanyKey = @CompanyKey
	   and Entity = @Entity
	   and EntityKey = @EntityKey
 
 return 1
GO
