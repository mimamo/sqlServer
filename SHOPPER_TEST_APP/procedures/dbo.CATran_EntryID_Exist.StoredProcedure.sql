USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[CATran_EntryID_Exist]    Script Date: 12/21/2015 16:06:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CATran_EntryID_Exist    Script Date: 4/7/98 12:49:20 PM ******/
create Proc [dbo].[CATran_EntryID_Exist] @parm1 varchar ( 2) as
  Select * from CATran
  Where EntryID = @parm1
 Order by EntryId
GO
