USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSecurityAccessGetAssigned]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptSecurityAccessGetAssigned]

   @CompanyKey int
  ,@Entity varchar(50)
  ,@EntityKey int 
    
AS --Encrypt
 	
	select sg.GroupName
	      ,sg.SecurityGroupKey
	  from tSecurityAccess sa (nolock) inner join tSecurityGroup sg (nolock) on sa.SecurityGroupKey = sg.SecurityGroupKey 
	 where sa.CompanyKey = @CompanyKey
	   and sa.Entity = @Entity
	   and sa.EntityKey = @EntityKey
  order by sg.GroupName
 
 return 1
GO
