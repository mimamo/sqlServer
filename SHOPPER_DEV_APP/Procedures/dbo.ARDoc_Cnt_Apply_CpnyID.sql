USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_Cnt_Apply_CpnyID]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_Cnt_Apply_CpnyID    Script Date: 4/7/98 12:30:32 PM ******/
Create proc [dbo].[ARDoc_Cnt_Apply_CpnyID] @parm1 varchar ( 10), @parm2 varchar ( 15) As
    SELECT Count(RefNbr)
    FROM ARDoc,GLSetup
    WHERE
        (ARDoc.CpnyID = @parm1 or GLSetup.Central_Cash_Cntl=1 and GLSetup.CpnyID=@parm1)
        and ARDoc.CustId = @parm2
        and doctype IN ('FI','IN','DM')
        and curydocbal > 0
        and Rlsed = 1
GO
