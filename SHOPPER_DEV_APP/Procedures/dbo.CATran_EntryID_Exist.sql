USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CATran_EntryID_Exist]    Script Date: 12/16/2015 15:55:15 ******/
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
