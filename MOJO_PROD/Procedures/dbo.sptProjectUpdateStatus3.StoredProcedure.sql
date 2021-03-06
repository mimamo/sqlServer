USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectUpdateStatus3]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectUpdateStatus3]
 @ProjectKey int,
 @ProjectStatusKey int,
 @ProjectBillingStatusKey int,
 @StartDate smalldatetime,
 @CompleteDate smalldatetime,
 @ProjectTypeKey int,
 @StatusNotes varchar(100),
 @DetailedNotes varchar(4000),
 @ClientNotes varchar(4000),
 @AccountManager int = null,
 @ProjectColor varchar(10) = null,
 @UpdateProjectStatus tinyint,
 @EditLocked tinyint
AS --Encrypt

/*
|| When     Who Rel      What
|| 07/15/10  GWG 10.532   Extending Update2
|| 09/12/11  RLB 10.548   (121105) Added ProjectTypeKey because sptProjectUpdateStatus2 requires it because of issue 119571
|| 11/14/14  GAR 10.586   (236577) Added explicit parameter names as there have been optional columns added to called proc.
*/

exec sptProjectUpdateStatus2 @ProjectKey = @ProjectKey, @ProjectStatusKey = @ProjectStatusKey, @ProjectBillingStatusKey = @ProjectBillingStatusKey, @ProjectTypeKey = @ProjectTypeKey, @StatusNotes = @StatusNotes, @DetailedNotes = @DetailedNotes, @ClientNotes = @ClientNotes, @AccountManager = @AccountManager, @ProjectColor = @ProjectColor, @UpdateProjectStatus = @UpdateProjectStatus, @EditLocked = @EditLocked

Update tProject Set StartDate = @StartDate, CompleteDate = @CompleteDate Where ProjectKey = @ProjectKey
GO
