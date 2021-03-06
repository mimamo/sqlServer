USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSecurityAccessInsert]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptSecurityAccessInsert]

   @CompanyKey int
  ,@Entity varchar(50)
  ,@EntityKey int 
  ,@SecurityGroupKey int
    
AS --Encrypt
 	
	insert tSecurityAccess
	      (CompanyKey
	      ,Entity
	      ,EntityKey
	      ,SecurityGroupKey
	      )
   values (@CompanyKey
	      ,@Entity
	      ,@EntityKey
	      ,@SecurityGroupKey
	      )
 
 return 1
GO
