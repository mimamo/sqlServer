USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ProcessQueueCPSOff_ComputerName]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_ProcessQueueCPSOff_ComputerName]
	@ComputerName    VARCHAR(21)
AS
	SELECT		TOP 1 *
	FROM		ProcessQueue (TABLOCK)
	WHERE		ProcessCPSOff = 1
	AND		ComputerName LIKE @ComputerName
	ORDER BY	ProcessPriority, ProcessQueueID
GO
