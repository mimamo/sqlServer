USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_InvtID_TranDate]    Script Date: 12/21/2015 16:13:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LotSerT_InvtID_TranDate    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.LotSerT_InvtID_TranDate    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[LotSerT_InvtID_TranDate] @parm1 varchar ( 30), @parm2 smalldatetime, @parm3 smalldatetime as
        Select * from LotSerT where InvtId = @parm1
                    and TranDate >= @parm2
                    and TranDate <= @parm3
                    order by InvtId, TranDate
GO
