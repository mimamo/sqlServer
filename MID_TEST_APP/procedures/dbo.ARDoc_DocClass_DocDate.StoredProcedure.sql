USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_DocClass_DocDate]    Script Date: 12/21/2015 15:49:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[ARDoc_DocClass_DocDate] @parm1 smalldatetime, @parm2 varchar(47), @parm3 varchar(7), @parm4 varchar(1)
WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
    Select * from ARDoc where ARDoc.DocClass = 'R'
        and ARDoc.NbrCycle > 0
        and ARDoc.DocDate <= @parm1
	and ardoc.cpnyid in

(select Cpnyid
 from vs_share_usercpny
   where userid = @parm2
   and scrn = @parm3
   and seclevel >= @parm4)

        order by CuryId, RefNbr
GO
