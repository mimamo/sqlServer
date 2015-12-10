USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSecurityGroupUpdateDesktop]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSecurityGroupUpdateDesktop]
	(
		@SecurityGroupKey int,
		@StandardDesktop text
	)
AS

Update tSecurityGroup
Set StandardDesktop = @StandardDesktop
Where SecurityGroupKey = @SecurityGroupKey
GO
