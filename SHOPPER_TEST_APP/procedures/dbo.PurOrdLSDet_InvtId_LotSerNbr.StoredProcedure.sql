USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdLSDet_InvtId_LotSerNbr]    Script Date: 12/21/2015 16:07:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurOrdLSDet_InvtId_LotSerNbr                             ******/
Create Proc [dbo].[PurOrdLSDet_InvtId_LotSerNbr] @parm1 varchar (30), @parm2 varchar (10), @parm3 varchar(25) as
       Select * from PurOrdLSDet
                Where InvtId = @parm1
                  and SiteId = @parm2
                  and LotSerNbr = @parm3
GO
