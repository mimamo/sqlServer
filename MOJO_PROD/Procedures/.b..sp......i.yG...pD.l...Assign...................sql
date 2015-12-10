USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSecurityGroupDeleteAssigned]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSecurityGroupDeleteAssigned]
(
	@SecurityGroupKey int
	,@SetGroup varchar(35) = NULL
)

AS --Encrypt

IF @SetGroup IS NULL

DELETE
FROM tRightAssigned
WHERE
	EntityType = 'Security Group' and
	EntityKey = @SecurityGroupKey 

ELSE

DELETE tRightAssigned
WHERE
	EntityType = 'Security Group' and
	EntityKey = @SecurityGroupKey and
	RightKey IN (
				SELECT RightKey FROM tRight (NOLOCK)
				WHERE UPPER(tRight.SetGroup) = UPPER(@SetGroup)
				)
GO
