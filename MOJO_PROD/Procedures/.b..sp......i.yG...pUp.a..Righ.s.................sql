USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSecurityGroupUpdateRights]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSecurityGroupUpdateRights]
	@CompanyKey int
	
AS --Encrypt

  /*
  || When     Who Rel		What
  || 01/26/10 MAS 10.5.1.8	Created  
  */
  

-- Delete 
Delete tRightAssigned Where RightAssignedKey in ( 
	Select ra.RightAssignedKey 
	From tRightAssigned ra
	inner join tSecurityGroup sg on ra.EntityKey = sg.SecurityGroupKey
	Where sg.CompanyKey = @CompanyKey

)-- 

-- Insert
Insert tRightAssigned (RightKey, EntityKey, EntityType) 
Select tra.RightKey, tra.EntityKey, 'Security Group' 
From #tRightAssigned tra
GO
