USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Header_ResetAllOK]    Script Date: 12/21/2015 15:36:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850Header_ResetAllOK] As
Update ED850Header Set UpdateStatus = 'OK' Where UpdateStatus = 'IN'
GO
