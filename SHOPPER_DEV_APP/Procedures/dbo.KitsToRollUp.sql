USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[KitsToRollUp]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[KitsToRollUp] as
        Select * from Kit where bomtype = 'Y'
           Order by Kit.LevelNbr Desc, Kit.Descr DESC, Kit.Kitid DESC, Kit.Siteid DESC, Kit.Status DESC
GO
