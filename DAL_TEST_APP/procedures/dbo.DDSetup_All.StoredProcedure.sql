USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DDSetup_All]    Script Date: 12/21/2015 13:56:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[DDSetup_All] as
    Select * from DDSetup ORDER by SetupId
GO
