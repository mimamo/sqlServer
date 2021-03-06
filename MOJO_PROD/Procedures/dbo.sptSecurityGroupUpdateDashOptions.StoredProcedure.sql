USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSecurityGroupUpdateDashOptions]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSecurityGroupUpdateDashOptions]
	(
		@SecurityGroupKey int,
		@ChangeLayout tinyint,
		@ChangeDesktop tinyint,
		@ChangeWindow tinyint
	)
AS

Update tSecurityGroup
Set
	ChangeLayout = @ChangeLayout,
	ChangeDesktop = @ChangeDesktop,
	ChangeWindow = @ChangeWindow
Where
	SecurityGroupKey = @SecurityGroupKey
GO
