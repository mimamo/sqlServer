USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimerPause]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimerPause]
	(
	@TimerKey int,
	@Paused tinyint,  -- 1 to pause, 0 to unpause
	@PauseTime datetime = NULL
	)

AS

Declare @PauseSeconds int
Declare @CurTime datetime
Declare @UserKey int

if @Paused = 1
BEGIN
	-- can't repause a paused timer
	if exists(Select 1 from tTimer Where TimerKey = @TimerKey and Paused = 1)
		return -1
	
	Update tTimer
	Set Paused = 1, 
		PauseTime = ISNULL(@PauseTime, GETUTCDATE()) -- , 
-- 		PauseMinutes = @PauseMinutes
	Where TimerKey = @TimerKey	

END
ELSE
BEGIN

	-- if already started, do nothing	
	if exists(Select 1 from tTimer Where TimerKey = @TimerKey and Paused = 0)
		return -2
	
	Select	@PauseSeconds = ISNULL(PauseSeconds, 0), 
			@PauseTime = ISNULL(PauseTime, GETUTCDATE())
	From tTimer (nolock) 
	Where TimerKey = @TimerKey
	
	-- if it had been paused, need to calc the new pause minutes(seconds)
	Select @PauseSeconds = @PauseSeconds + ISNULL(DATEDIFF(ss, @PauseTime, GETUTCDATE()),0)
	
	Update tTimer 
	Set PauseTime = NULL, 
		Paused = 0, 
		PauseSeconds = @PauseSeconds
	Where TimerKey = @TimerKey

END
GO
