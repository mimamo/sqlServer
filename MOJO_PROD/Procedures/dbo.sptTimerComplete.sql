USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimerComplete]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimerComplete]
	(
	@TimerKey int
	)
AS

Declare 
	 @CompanyKey int
    ,@UserKey int
    ,@ProjectKey int
    ,@TaskKey int
    ,@DetailTaskKey int
    ,@ServiceKey int
    ,@RateLevel int 
	,@Comments varchar(2000)
	,@DefaultServiceKey int
	,@DefaultRateLevel int
	,@RequireProject tinyint
	,@RequireService tinyint










Delete tTimer Where TimerKey = @TimerKey
GO
