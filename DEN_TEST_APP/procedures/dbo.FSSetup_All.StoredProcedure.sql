USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[FSSetup_All]    Script Date: 12/21/2015 15:36:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.FSSetup_All    Script Date: 4/7/98 12:45:04 PM ******/
Create Proc [dbo].[FSSetup_All] as
     Select * from FSSetup
GO
