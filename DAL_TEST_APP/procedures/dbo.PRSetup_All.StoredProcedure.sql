USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRSetup_All]    Script Date: 12/21/2015 13:57:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRSetup_All] as
       Select * from PRSetup
GO
