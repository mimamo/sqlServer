USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRMatMsg_DelAll]    Script Date: 12/21/2015 14:17:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[IRMatMsg_DelAll] As
	Delete from IRMatMsg
GO
