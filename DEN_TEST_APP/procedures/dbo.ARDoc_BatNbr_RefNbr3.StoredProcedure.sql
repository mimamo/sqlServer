USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_BatNbr_RefNbr3]    Script Date: 12/21/2015 15:36:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_BatNbr_RefNbr3    Script Date: 7/27/00 12:30:32 PM ******/
Create Procedure [dbo].[ARDoc_BatNbr_RefNbr3] @parm1 varchar ( 10), @parm2 varchar ( 10) as
    Select * from ARDoc where BatNbr = @parm1
        and ARDoc.RefNbr like @parm2
        order by Doctype,RefNbr
GO
