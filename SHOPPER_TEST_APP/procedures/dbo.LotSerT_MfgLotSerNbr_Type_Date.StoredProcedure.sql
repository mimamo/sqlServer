USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_MfgLotSerNbr_Type_Date]    Script Date: 12/21/2015 16:07:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LotSerT_MfgLotSerNbr_Type_Date    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.LotSerT_MfgLotSerNbr_Type_Date    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[LotSerT_MfgLotSerNbr_Type_Date] @parm1 varchar (30), @parm2 varchar (25), @parm3 varchar (2) , @parm4 smalldatetime, @parm5 smalldatetime as
    Select * from LotSerT where InvtID = @parm1
		and MfgrLotSerNbr = @parm2
	        and TranType = @parm3
                and TranDate >= @parm4
                and TranDate <= @parm5
                order by LotSerNbr
GO
