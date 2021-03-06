USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10578]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10578]
AS
	SET NOCOUNT ON 

	--
	-- Default new rights
	--
	 DECLARE @RK INT, @NewRK INT, @RAK INT
	 
	 SELECT @RAK = -1
	 SELECT @RK = RightKey FROM tRight WHERE RightID = 'acct_gl_pl_ytd'
	 SELECT @NewRK = RightKey FROM tRight WHERE RightID = 'acct_client_gl_pl_ytd'
	 
	 IF @NewRK IS NOT NULL
	 BEGIN
		 WHILE (1=1)
		 BEGIN
			SELECT @RAK = MIN(RightAssignedKey)
			  FROM   tRightAssigned
			 WHERE RightKey = @RK
			   AND RightAssignedKey > @RAK
			
			IF @RAK IS NULL
				BREAK
			
			INSERT tRightAssigned (EntityType, EntityKey, RightKey)
			SELECT EntityType, EntityKey, @NewRK
			  FROM tRightAssigned 
			 WHERE RightAssignedKey = @RAK

		 END
	 END
	
	--
    --  NULL out RetainerKey if BillingMethod not 3
	--
	UPDATE tCompany
	  SET DefaultRetainerKey = null
	WHERE DefaultBillingMethod <> 3 AND DefaultRetainerKey IS NOT NULL

	UPDATE tProject
	  SET RetainerKey = null
	WHERE BillingMethod <> 3 AND RetainerKey IS NOT NULL

	--
    --  Clean out tSystemPreferences
	--
	DELETE tSystemPreferences
	
	RETURN
GO
