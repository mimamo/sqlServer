USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAppSettingGetSetup]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptAppSettingGetSetup]
(
	@CompanyKey int,
	@GroupID varchar(200),
	@SettingsOnly tinyint = 0
)

AS

if @SettingsOnly = 0
BEGIN
	-- get the security groups
	SELECT *
	FROM   tSecurityGroup (NOLOCK)
	WHERE  CompanyKey = @CompanyKey and Active = 1 
	ORDER BY GroupName

	Select * from tAppSettingGroup Where GroupID = @GroupID

	-- Get the setting Setups
	Select * from tAppSetting Where GroupID = @GroupID Order By DisplayOrder

	-- Get the company settings
	Select * from tAppSession (nolock) 
	Where Entity = 'company' 
	and EntityKey = @CompanyKey
	and GroupID = @GroupID

	-- Get the individual stored values
	Select * from tAppSession (nolock) 
	Where Entity = 'securitygroup' 
	and EntityKey in (Select SecurityGroupKey from tSecurityGroup (nolock) Where CompanyKey = @CompanyKey and Active = 1)
	and GroupID = @GroupID

END
ELSE
BEGIN
	Select * from tAppSetting Where GroupID = @GroupID Order By DisplayOrder

END
GO
