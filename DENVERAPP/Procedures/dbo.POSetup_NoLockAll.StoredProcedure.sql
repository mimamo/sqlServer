USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[POSetup_NoLockAll]    Script Date: 12/21/2015 15:43:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[POSetup_NoLockAll] as
       Select * from POSetup With(NoLock)
GO
