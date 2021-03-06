USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_DocClass_DocDate_RefNbr]    Script Date: 12/21/2015 15:49:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[ARDoc_DocClass_DocDate_RefNbr] @parm1 smalldatetime, @parm2 varchar ( 10)
WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
    Select * from ARDoc where ARDoc.DocClass = 'R'
        and ARDoc.NbrCycle > 0
        and ARDoc.DocDate <= @parm1
        and ARDoc.RefNbr like @parm2
        order by CuryId, RefNbr
GO
