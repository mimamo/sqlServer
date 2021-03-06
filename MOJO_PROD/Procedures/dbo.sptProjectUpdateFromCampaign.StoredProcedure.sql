USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectUpdateFromCampaign]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectUpdateFromCampaign]
	(
	@ProjectKey int,
	@ProjectName varchar(100),
	@Description text,
	@AccountManager int,
	@ProjectStatusKey int
	)
AS --Encrypt

/*
  || When     Who Rel      What
  || 11/19/10 GHL 10.538   Creation to update fields from the campaign screen
  ||                       Created stored proc versus SQL update because of Description (text field)  
  || 04/08/15 WDF 10.591   (252676) Added ProjectStatusKey checks modeled after sptProjectUpdateSetup
  ||
*/
	SET NOCOUNT ON 
	
Declare @Closed tinyint, @Active tinyint, @AllowTime tinyint, @AllowExpense tinyint

	select @Closed = Closed from tProject (nolock) where ProjectKey = @ProjectKey

	select @Active = IsActive, @AllowTime = TimeActive, @AllowExpense = ExpenseActive
	  from tProjectStatus (NOLOCK) 
	 where ProjectStatusKey = @ProjectStatusKey
	
	IF @Active IS NULL RETURN -1
	
	IF @Closed = 1 and @Active = 1 
		return -2

	if @Closed = 1 and @Active = 0 and (@AllowTime = 1 OR @AllowExpense = 1)
		return -3
	
	update tProject
	set    ProjectName = @ProjectName
	      ,Description = @Description
		  ,AccountManager = @AccountManager
		  ,ProjectStatusKey = @ProjectStatusKey
		  ,Active = @Active
    where  ProjectKey = @ProjectKey

	RETURN 1
GO
