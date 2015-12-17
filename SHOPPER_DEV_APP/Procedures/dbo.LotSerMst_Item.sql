USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerMst_Item]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LotSerMst_Item    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.LotSerMst_Item    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[LotSerMst_Item] @parm1 varchar ( 30), @parm2 varchar (25) as
    Select *  from LotSerMst where InvtId like @parm1
                  and LotSerNbr Like @parm2
                  order by LotSerNbr
GO
