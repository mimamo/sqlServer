USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOHeader_Cpnyid_OrdNbr]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSOHeader_Cpnyid_OrdNbr] @parm1 Char(10), @Parm2 Char(15) As
select * From EDSOHeader where Cpnyid like @parm1 and OrdNbr like @Parm2
order by Cpnyid, OrdNbr
GO
