USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDOutbound_AllDMG]    Script Date: 12/21/2015 16:07:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDOutbound_AllDMG] @Parm1 varchar(15), @Parm2 varchar(3) As
Select * From EDOutbound Where CustId = @Parm1 And Trans Like @Parm2
Order By Custid, Trans
GO
