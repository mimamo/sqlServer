USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRMatMsg_DelAll]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[IRMatMsg_DelAll] As
	Delete from IRMatMsg
GO
