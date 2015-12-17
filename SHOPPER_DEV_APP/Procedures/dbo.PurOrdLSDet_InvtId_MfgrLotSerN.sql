USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdLSDet_InvtId_MfgrLotSerN]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurOrdLSDet_InvtId_MfgrLotSerN                           ******/
Create Proc [dbo].[PurOrdLSDet_InvtId_MfgrLotSerN] @parm1 varchar (30), @parm2 varchar (10), @parm3 varchar(25) as
       Select * from PurOrdLSDet
                Where InvtId = @parm1
                  and SiteId = @parm2
                  and MfgrLotSerNbr = @parm3
GO
