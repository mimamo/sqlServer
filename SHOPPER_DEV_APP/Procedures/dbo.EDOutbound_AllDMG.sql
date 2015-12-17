USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDOutbound_AllDMG]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDOutbound_AllDMG] @Parm1 varchar(15), @Parm2 varchar(3) As
Select * From EDOutbound Where CustId = @Parm1 And Trans Like @Parm2
Order By Custid, Trans
GO
