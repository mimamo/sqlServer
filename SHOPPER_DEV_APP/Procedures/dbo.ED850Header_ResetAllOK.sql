USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Header_ResetAllOK]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850Header_ResetAllOK] As
Update ED850Header Set UpdateStatus = 'OK' Where UpdateStatus = 'IN'
GO
