USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spLoadStandardWidgetSecurity]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLoadStandardWidgetSecurity]
(
	@CompanyKey			INT,
	@WidgetKey			INT,
	@GroupName			VARCHAR(100),
	@CanView			INT,
	@CanEdit			INT
)	

AS --Encrypt

	SET NOCOUNT ON
	
	Declare @SecurityGroupKey int
	
	Select @SecurityGroupKey = SecurityGroupKey
	From   tSecurityGroup (nolock)
	Where  CompanyKey = @CompanyKey
	And    GroupName = @GroupName
	
	If @SecurityGroupKey > 0
		exec sptWidgetSecurityUpdate @WidgetKey, @SecurityGroupKey, @CanView, @CanEdit
	
	RETURN 1
GO
