USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[IRMatMsg_DelAll]    Script Date: 12/21/2015 13:44:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[IRMatMsg_DelAll] As
	Delete from IRMatMsg
GO
