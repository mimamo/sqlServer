USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Location_Whseloc]    Script Date: 12/21/2015 16:07:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Location_Whseloc    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.Location_Whseloc    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[Location_Whseloc] @parm1 varchar ( 10) as
Select * from Location where WhseLoc = @parm1
Order by WhseLoc
GO
