USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[POSetup_NoLockAll]    Script Date: 12/21/2015 16:07:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[POSetup_NoLockAll] as
       Select * from POSetup With(NoLock)
GO
