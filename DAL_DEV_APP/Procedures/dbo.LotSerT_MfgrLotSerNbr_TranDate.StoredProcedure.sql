USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_MfgrLotSerNbr_TranDate]    Script Date: 12/21/2015 13:35:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LotSerT_MfgrLotSerNbr_TranDate    Script Date: 4/17/98 10:58:19 AM ******/
/****** Object:  Stored Procedure dbo.LotSerT_MfgrLotSerNbr_TranDate    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[LotSerT_MfgrLotSerNbr_TranDate] @parm1 varchar ( 30), @parm2 varchar (25), @parm3 smalldatetime, @parm4 smalldatetime as
        Select * from LotSerT where InvtId = @parm1
	            and MfgrLotSerNbr = @parm2
                    and TranDate >= @parm3
                    and TranDate <= @parm4
                    order by InvtId, MfgrLotSerNbr, TranDate
GO
