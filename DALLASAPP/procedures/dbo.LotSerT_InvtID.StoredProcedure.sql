USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_InvtID]    Script Date: 12/21/2015 13:44:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LotSerT_InvtID    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.LotSerT_InvtID    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[LotSerT_InvtID] @parm1 varchar (30) as
    Select * from LotSerT where InvtID = @parm1
                order by LotSerNbr
GO
