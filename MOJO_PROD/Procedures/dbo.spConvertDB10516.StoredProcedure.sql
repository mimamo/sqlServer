USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10516]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10516]
AS
	SET NOCOUNT ON
	
-- Cleanup mismatches of projects bewteen TaskKey and DetailTaskKey due to transfers
 	
Update tTime Set DetailTaskKey = null Where TransferToKey is not null
GO
